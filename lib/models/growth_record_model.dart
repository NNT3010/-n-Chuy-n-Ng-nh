import 'package:cloud_firestore/cloud_firestore.dart';

class GrowthRecordModel {
  String? id;
  String? child_id;
  double? weight;
  double? height;
  double? head_circumference;
  String? notes;
  DateTime? record_date;
  DateTime? created_at;
  DateTime? updated_at;

  GrowthRecordModel({
    this.id,
    this.child_id,
    this.weight,
    this.height,
    this.head_circumference,
    this.notes,
    this.record_date,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'child_id': child_id,
      'weight': weight,
      'height': height,
      'head_circumference': head_circumference,
      'notes': notes,
      'record_date': record_date != null
          ? Timestamp.fromDate(record_date!)
          : FieldValue.serverTimestamp(),
      'created_at': created_at != null
          ? Timestamp.fromDate(created_at!)
          : FieldValue.serverTimestamp(),
      'updated_at': Timestamp.fromDate(DateTime.now()),
    };
  }

  /// 🔹 Convert Firestore → Dart
  factory GrowthRecordModel.fromMap(Map<String, dynamic> map, String id) {
    return GrowthRecordModel(
      id: id,
      child_id: map['child_id'],
      weight: _toDouble(map['weight']),
      height: _toDouble(map['height']),
      head_circumference: _toDouble(map['head_circumference']),
      notes: map['notes'],
      record_date: _toDate(map['record_date']),
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  /// Helper chuyển Timestamp / String → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }

  /// Helper ép kiểu double an toàn
  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
  GrowthRecordModel copyWith({
    String? id,
    String? child_id,
    double? weight,
    double? height,
    double? head_circumference,
    String? notes,
    DateTime? record_date,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return GrowthRecordModel(
      id: id ?? this.id,
      child_id: child_id ?? this.child_id,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      head_circumference: head_circumference ?? this.head_circumference,
      notes: notes ?? this.notes,
      record_date: record_date ?? this.record_date,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

}
