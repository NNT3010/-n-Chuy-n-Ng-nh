import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPostModel {
  String? id;
  String? user_id;
  String? title;
  String? content;
  String? image_url;
  int? like_count;
  int? comment_count;
  DateTime? created_at;
  DateTime? updated_at;

  CommunityPostModel({
    this.id,
    this.user_id,
    this.title,
    this.content,
    this.image_url,
    this.like_count,
    this.comment_count,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'title': title,
      'content': content,
      'image_url': image_url,
      'like_count': like_count ?? 0,
      'comment_count': comment_count ?? 0,
      'created_at': created_at ?? DateTime.now(),
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory CommunityPostModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityPostModel(
      id: id,
      user_id: map['user_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      image_url: map['image_url'],
      like_count: map['like_count'] is int ? map['like_count'] : 0,
      comment_count: map['comment_count'] is int ? map['comment_count'] : 0,
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  /// 🕒 Helper: chuyển Timestamp/String → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
