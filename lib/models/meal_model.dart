import 'package:cloud_firestore/cloud_firestore.dart';

class MealModel {
  String? id;
  String? nutrition_plan_id;
  String? day_of_week;
  String? meal_type; // breakfast, lunch, dinner, snack
  String? food;
  String? notes;
  DateTime? created_at;
  DateTime? updated_at;

  MealModel({
    this.id,
    this.nutrition_plan_id,
    this.day_of_week,
    this.meal_type,
    this.food,
    this.notes,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'nutrition_plan_id': nutrition_plan_id,
      'day_of_week': day_of_week,
      'meal_type': meal_type,
      'food': food,
      'notes': notes,
      'created_at': created_at ?? DateTime.now(),
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory MealModel.fromMap(Map<String, dynamic> map, String id) {
    return MealModel(
      id: id,
      nutrition_plan_id: map['nutrition_plan_id'] ?? '',
      day_of_week: map['day_of_week'] ?? '',
      meal_type: map['meal_type'] ?? '',
      food: map['food'] ?? '',
      notes: map['notes'],
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
