import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/logic/models/user_model.dart';

class ChatModelF {
  String? id;
  String? type = "user";
  String? lastMessageId;
  UserModel? user;
  GroupModel? group;
  DateTime? createdAt;

  ChatModelF({
    this.id,
    this.type,
    this.createdAt,
    this.lastMessageId,
    this.user,
    this.group,
  });

  // factory ChatModelF.fromJson({
  //   String? id,
  //   String? lastMessageId,
  //   UserModel? user,
  //   DateTime? createdAt,
  //   String? type,
  //   GroupModel? group,
  // }) {
  //   return ChatModelF(
  //     id: id,
  //     createdAt: createdAt,
  //     lastMessageId: lastMessageId,
  //     user: type == 'user' ? user : null,
  //     type: type,
  //     group: type == "group" ? group : null,
  //   );
  // }

  factory ChatModelF.convertChatModelToChatModelF({
    String? id,
    String? lastMessageId,
    UserModel? user,
    DateTime? createdAt,
    String? type,
    GroupModel? group,
  }) {
    return ChatModelF(
      id: id,
      createdAt: createdAt,
      lastMessageId: lastMessageId,
      user: type == 'user' ? user : null,
      type: type,
      group: type == "group" ? group : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt?.toIso8601String(),
      "last_message_id": lastMessageId,
      "type": type,
      "user": user?.toJson(),
      "group": group?.toJson(),
    };
  }
}
