import 'package:chatapp/logic/MyMethods/encrpt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Msg {
  final String? id;
  final String? userId;
  final String? rUserId;
  final String? message;
  final String? mediaType;
  final String? media;
  final DateTime? readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? storeMsgAt;

  Msg({
    this.id,
    this.userId,
    this.rUserId,
    this.message,
    this.mediaType,
    this.media,
    this.readAt,
    this.createdAt,
    this.updatedAt,
    this.storeMsgAt,
  });

  factory Msg.fromJson(Map<String, dynamic> json, {bool cc = false}) {
    print(EncryptData.decryptAES(json['message']));
    if (cc) {
      return Msg(
        id: json['id'],
        userId: json['user_id'],
        rUserId: json['r_user_id'],
        message: json['message'] != null
            ? EncryptData.decryptAES(json['message'])
            : null,
        mediaType: json['media_type'],
        media: json['media'],
        readAt:
            json['read_at'] != null ? (DateTime.parse(json['read_at'])) : null,
        createdAt: json['created_at'] != null
            ? (DateTime.parse(json['created_at']))
            : null,
        updatedAt: json['updated_at'] != null
            ? (DateTime.parse(json['updated_at']))
            : null,
        storeMsgAt: json['store_msg_at'] != null
            ? (DateTime.parse(json['store_msg_at']))
            : null,
      );
    }
    return Msg(
      id: json['id'],
      userId: json['user_id'],
      rUserId: json['r_user_id'],
      message: json['message'] != null
          ? EncryptData.decryptAES(json['message'])
          : null,
      mediaType: json['media_type'],
      media: json['media'],
      readAt: json['read_at'] != null
          ? (json['read_at'] as Timestamp).toDate()
          : null,
      createdAt: json['created_at'] != null
          ? (json['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: json['updated_at'] != null
          ? (json['updated_at'] as Timestamp).toDate()
          : null,
      storeMsgAt: json['store_msg_at'] != null
          ? (json['store_msg_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'r_user_id': rUserId,
      'message': message != null ? EncryptData.encryptAES(message!) : null,
      'media_type': mediaType,
      'media': media,
      'read_at': null,
      'created_at': DateTime.now(),
      'updated_at': DateTime.now(),
      'store_msg_at': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFullJson() {
    return {
      'id': id,
      'user_id': userId,
      'r_user_id': rUserId,
      'message': message != null ? EncryptData.encryptAES(message!) : null,
      'media_type': mediaType,
      'media': media,
      'read_at': readAt != null ? (readAt)!.toIso8601String() : null,
      'created_at': createdAt != null ? (createdAt)!.toIso8601String() : null,
      'updated_at': updatedAt != null ? (updatedAt)!.toIso8601String() : null,
      'store_msg_at':
          storeMsgAt != null ? (storeMsgAt)!.toIso8601String() : null,
    };
  }
}
