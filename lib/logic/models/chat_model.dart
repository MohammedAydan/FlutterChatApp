class ChatModel {
  String? id;
  String? type;
  String? lastMessageId;
  List<String>? members;
  DateTime? createdAt;

  ChatModel({
    this.id,
    this.type,
    this.createdAt,
    this.lastMessageId,
    this.members,
  });

  factory ChatModel.fromJson(String? id, Map<String, dynamic> json) {
    return ChatModel(
      id: id,
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      lastMessageId: json['last_message_id'],
      members:
          (json['members'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "created_at": createdAt?.toIso8601String(),
      "last_message_id": lastMessageId,
      "members": members?.map((e) => e.toString()).toList(),
    };
  }
}
