import 'dart:async';
import 'dart:io';

import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AuthLogic {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<UserCredential> login(String email, String password) async {
    UserCredential res = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res;
  }

  static Future<UserCredential> register(
    String displayName,
    String email,
    String password,
    XFile img,
  ) async {
    String? imgUrl = await uploadImage(img);

    UserCredential res = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await res.user?.updatePhotoURL(imgUrl);
    await res.user?.updateDisplayName(displayName);

    if (res.user != null) {
      await addUser(res.user!, imgUrl!, displayName);
    }

    return res;
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }

  static Future<User?> getCurrentUser() async {
    User? user = auth.currentUser;
    return user;
  }

  static Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> addUser(
      User user, String imgUrl, String displayName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(user.uid).set(
          UserModel(
            uid: user.uid,
            email: user.email,
            displayName: displayName,
            photoUrl: imgUrl,
            isAnonymous: user.isAnonymous,
            isEmailVerified: user.emailVerified,
            phoneNumber: user.phoneNumber,
            providerId: user.providerData[0].providerId,
            refreshToken: user.refreshToken,
            tenantId: user.tenantId,
            lastSignInTimestamp:
                user.metadata.lastSignInTime!.microsecondsSinceEpoch,
            creationTimestamp:
                user.metadata.creationTime!.microsecondsSinceEpoch,
          ).toJson(),
        );
  }

  static Future<User?> updateUser({
    required String displayName,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await auth.currentUser?.updateDisplayName(displayName);
    await firestore.collection('users').doc(auth.currentUser?.uid).update({
      "displayName": displayName,
    });
    await auth.currentUser?.reload();
    return auth.currentUser;
  }

  static Future<User?> updateUserImage({
    required XFile fileImg,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? imgUrl = await uploadImage(fileImg);
    await auth.currentUser?.updatePhotoURL(imgUrl);
    await firestore.collection('users').doc(auth.currentUser?.uid).update({
      "photoUrl": imgUrl,
    });
    await auth.currentUser?.reload();
    return auth.currentUser;
  }

  static Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
        return await auth.signInWithPopup(googleProvider);
      }
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentSnapshot doc = await firestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .get();
        if (!doc.exists) {
          await addUser(
            userCredential.user!,
            userCredential.user!.photoURL!,
            userCredential.user!.displayName!,
          );
        }
      }

      return userCredential;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'sign_in_failed',
        message: 'Failed to sign in with Google: $e',
      );
    }
  }

  static Future<String?> uploadImage(XFile file) async {
    String nameOnly = file.name.split('.').first;
    String entension = file.name.split('.').last;
    String uid = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath = '$nameOnly-$uid.$entension';

    FirebaseStorage firestore = FirebaseStorage.instance;
    final ref = firestore.ref().child("profilesImages/$filePath");
    await ref.putFile(File(file.path));
    return await ref.getDownloadURL();
  }
}
