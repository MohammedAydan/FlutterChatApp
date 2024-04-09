import 'dart:convert';

class StatusUser {
  String? userId;
  bool? status;
  DateTime? updatedAt;

  StatusUser({
    this.userId,
    this.status,
    this.updatedAt,
  });

  factory StatusUser.fromRawJson(String str) =>
      StatusUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatusUser.fromJson(Map<String, dynamic> json) => StatusUser(
        userId: json["user_id"],
        status: json["status"],
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "status": status,
        "updated_at": DateTime.now().toIso8601String(),
      };
}
