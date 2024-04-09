import "package:chatapp/logic/models/msg_model.dart";

class GroupModel {
  String? id;
  String? displayName;
  String? photoUrl;
  String? ownerId;
  List<String>? admins = [];
  List<String>? members = [];
  Msg? lastMessage;
  List<String>? tokens = [];

  GroupModel({
    this.id,
    this.displayName,
    this.photoUrl,
    this.lastMessage,
    this.tokens,
    this.admins,
    this.members,
    this.ownerId,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json,
      {Msg? lastMessage, List<String>? tokens}) {
    return GroupModel(
      id: json['group_id'],
      displayName: json['displayName'],
      photoUrl: json['imgUrl'],
      lastMessage: lastMessage,
      tokens: tokens ?? [],
      ownerId: json['owner_id'],
      admins: json['admins'] != null
          ? List<String>.from(json['admins'].map((x) => x))
          : [],
      members: json['members'] != null
          ? List<String>.from(json['members'].map((x) => x))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'lastMessage': lastMessage?.toFullJson(),
      "tokens": tokens?.toList(),
      'ownerId': ownerId,
      'admins': admins?.toList(),
      'members': members?.toList(),
    };
  }
}
