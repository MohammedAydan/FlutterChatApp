import "package:chatapp/logic/models/msg_model.dart";

class UserModel {
  String uid;
  String? email;
  String? displayName;
  String? photoUrl;
  String? phoneNumber;
  bool? isAnonymous;
  bool? isEmailVerified;
  String? providerId;
  String? tenantId;
  String? refreshToken;
  int? creationTimestamp;
  int? lastSignInTimestamp;
  Msg? lastMessage;
  List<String>? tokens = [];

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.isAnonymous,
    this.isEmailVerified,
    this.providerId,
    this.tenantId,
    this.refreshToken,
    this.creationTimestamp,
    this.lastSignInTimestamp,
    this.lastMessage,
    this.tokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json,
      {Msg? lastMessage, List<String>? tokens}) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      phoneNumber: json['phoneNumber'],
      isAnonymous: json['isAnonymous'],
      isEmailVerified: json['isEmailVerified'],
      providerId: json['providerId'],
      tenantId: json['tenantId'],
      refreshToken: json['refreshToken'],
      creationTimestamp: json['creationTimestamp'],
      lastSignInTimestamp: json['lastSignInTimestamp'],
      lastMessage: lastMessage,
      tokens: tokens ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'isAnonymous': isAnonymous,
      'isEmailVerified': isEmailVerified,
      'providerId': providerId,
      'tenantId': tenantId,
      'refreshToken': refreshToken,
      'creationTimestamp': creationTimestamp,
      'lastSignInTimestamp': lastSignInTimestamp,
      'lastMessage': lastMessage?.toFullJson(),
      "tokens": tokens,
    };
  }
}
