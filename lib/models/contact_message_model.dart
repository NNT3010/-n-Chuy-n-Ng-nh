import 'package:cloud_firestore/cloud_firestore.dart';

class ContactMessageModel {
  String? id;
  String? user_id;
  String? admin_id;
  String? subject;
  String? message;
  String? reply;
  bool? is_read;
  bool? is_replied;
  DateTime? sent_at;
  DateTime? replied_at;
  DateTime? created_at;
  DateTime? updated_at;

  ContactMessageModel({
    this.id,
    this.user_id,
    this.admin_id,
    this.subject,
    this.message,
    this.reply,
    this.is_read,
    this.is_replied,
    this.sent_at,
    this.replied_at,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'admin_id': admin_id,
      'subject': subject,
      'message': message,
      'reply': reply,
      'is_read': is_read ?? false,
      'is_replied': is_replied ?? false,
      'sent_at': sent_at ?? DateTime.now(),
      'replied_at': replied_at,
      'created_at': created_at ?? DateTime.now(),
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory ContactMessageModel.fromMap(Map<String, dynamic> map, String id) {
    return ContactMessageModel(
      id: id,
      user_id: map['user_id'] ?? '',
      admin_id: map['admin_id'],
      subject: map['subject'] ?? '',
      message: map['message'] ?? '',
      reply: map['reply'],
      is_read: map['is_read'] ?? false,
      is_replied: map['is_replied'] ?? false,
      sent_at: _toDate(map['sent_at']),
      replied_at: _toDate(map['replied_at']),
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
