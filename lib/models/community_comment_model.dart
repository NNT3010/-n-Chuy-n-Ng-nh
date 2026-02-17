import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityCommentModel {
  String? id;
  String? post_id;
  String? user_id;
  String? content;
  DateTime? created_at;

  CommunityCommentModel({
    this.id,
    this.post_id,
    this.user_id,
    this.content,
    this.created_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'post_id': post_id,
      'user_id': user_id,
      'content': content,
      'created_at': created_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory CommunityCommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityCommentModel(
      id: id,
      post_id: map['post_id'] ?? '',
      user_id: map['user_id'] ?? '',
      content: map['content'] ?? '',
      created_at: _toDate(map['created_at']),
    );
  }

  /// 🕒 Helper: chuyển Timestamp hoặc String → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
