import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionPlanModel {
  String? id;
  String? week;
  String? description;
  DateTime? created_at;
  DateTime? updated_at;

  NutritionPlanModel({
    this.id,
    this.week,
    this.description,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'week': week,
      'description': description,
      'created_at': created_at ?? DateTime.now(),
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory NutritionPlanModel.fromMap(Map<String, dynamic> map, String id) {
    return NutritionPlanModel(
      id: id,
      week: map['week'] ?? '',
      description: map['description'],
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  /// 🕒 Helper: Chuyển Timestamp/String/DateTime → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
