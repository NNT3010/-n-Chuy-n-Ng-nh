import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String? user_id;
  String? title;
  String? message;
  bool? is_read;
  String? type;
  DateTime? created_at;

  NotificationModel({
    this.id,
    this.user_id,
    this.title,
    this.message,
    this.is_read = false,
    this.type,
    this.created_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'title': title,
      'message': message,
      'is_read': is_read ?? false,
      'type': type,
      'created_at': created_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      user_id: map['user_id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      is_read: map['is_read'] ?? false,
      type: map['type'],
      created_at: _toDate(map['created_at']),
    );
  }

  /// 🕒 Helper: Chuyển đổi Timestamp/String/DateTime → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
