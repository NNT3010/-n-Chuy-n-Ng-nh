import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLogModel {
  String? id;
  String? user_id;
  String? action;
  String? details;
  DateTime? created_at;

  ActivityLogModel({
    this.id,
    this.user_id,
    this.action,
    this.details,
    this.created_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'action': action,
      'details': details,
      'created_at': created_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory ActivityLogModel.fromMap(Map<String, dynamic> map, String id) {
    return ActivityLogModel(
      id: id,
      user_id: map['user_id'] ?? '',
      action: map['action'] ?? '',
      details: map['details'] ?? '',
      created_at: _toDate(map['created_at']),
    );
  }

  /// 🕒 Helper: Chuyển Timestamp hoặc String → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
