import 'package:chatapp/logic/MyMethods/encrpt.dart';
import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MsgGroup {
  final String? id;
  final String? userId;
  final String? groupId;
  final String? message;
  final String? mediaType;
  final String? media;
  final List<String>? readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? storeMsgAt;

  MsgGroup({
    this.id,
    this.userId,
    this.groupId,
    this.message,
    this.mediaType,
    this.media,
    this.readAt,
    this.createdAt,
    this.updatedAt,
    this.storeMsgAt,
  });

  factory MsgGroup.fromJson(Map<String, dynamic> json, {bool cc = false}) {
    // print(".....................................GGG");
    // print(json);
    if (cc) {
      return MsgGroup(
        id: json['id'],
        userId: json['user_id'],
        groupId: json['group_id'],
        message: json['message'] != null
            ? EncryptData.decryptAES(json['message'])
            : null,
        mediaType: json['media_type'],
        media: json['media'],
        readAt: json['read_at'] != null && json['read_at'] is List
            ? (json['read_at'] as List).map((e) => e.toString()).toList()
            : null,
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
    return MsgGroup(
      id: json['id'],
      userId: json['user_id'],
      groupId: json['group_id'],
      message: json['message'] != null
          ? EncryptData.decryptAES(json['message'])
          : null,
      mediaType: json['media_type'],
      media: json['media'],
      readAt: json['read_at'] != null && json['read_at'] is List
          ? (json['read_at'] as List).map((e) => e.toString()).toList()
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
      'group_id': groupId,
      'message': message != null ? EncryptData.encryptAES(message!) : null,
      'media_type': mediaType,
      'media': media,
      'read_at': [],
      'created_at': DateTime.now(),
      'updated_at': DateTime.now(),
      'store_msg_at': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFullJson() {
    return {
      'id': id,
      'user_id': userId,
      'group_id': groupId,
      'message': message != null ? EncryptData.encryptAES(message!) : null,
      'media_type': mediaType,
      'media': media,
      'read_at': readAt,
      'created_at': createdAt != null ? (createdAt)!.toIso8601String() : null,
      'updated_at': updatedAt != null ? (updatedAt)!.toIso8601String() : null,
      'store_msg_at':
          storeMsgAt != null ? (storeMsgAt)!.toIso8601String() : null,
    };
  }
}
