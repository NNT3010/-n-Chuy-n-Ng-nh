import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  String? id;
  String? expert_id;
  String? title;
  String? content;
  String? image_url;
  String? category;
  bool? is_published;
  DateTime? created_at;
  DateTime? updated_at;

  ArticleModel({
    this.id,
    this.expert_id,
    this.title,
    this.content,
    this.image_url,
    this.category,
    this.is_published = false,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'expert_id': expert_id,
      'title': title,
      'content': content,
      'image_url': image_url,
      'category': category,
      'is_published': is_published ?? false,
      'created_at': created_at ?? DateTime.now(),
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory ArticleModel.fromMap(Map<String, dynamic> map, String id) {
    return ArticleModel(
      id: id,
      expert_id: map['expert_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      image_url: map['image_url'],
      category: map['category'],
      is_published: map['is_published'] ?? false,
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
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
