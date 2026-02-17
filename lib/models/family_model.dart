import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyModel {
  String? id;
  String? primary_user_id;
  String? family_name;
  DateTime? created_at;
  DateTime? updated_at;

  FamilyModel({
    this.id,
    this.primary_user_id,
    this.family_name,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'primary_user_id': primary_user_id,
      'family_name': family_name,
      'created_at': created_at ?? DateTime.now(),
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory FamilyModel.fromMap(Map<String, dynamic> map, String id) {
    return FamilyModel(
      id: id,
      primary_user_id: map['primary_user_id'],
      family_name: map['family_name'] ?? '',
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  /// 🕒 Helper: Chuyển Timestamp/String → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
