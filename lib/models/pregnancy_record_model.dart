import 'package:cloud_firestore/cloud_firestore.dart';

class PregnancyRecordModel {
  String? id;
  String? user_id;
  int? week_number;
  String? notes;
  DateTime? checkup_date;
  DateTime? created_at;
  DateTime? updated_at;

  PregnancyRecordModel({
    this.id,
    this.user_id,
    this.week_number,
    this.notes,
    this.checkup_date,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'week_number': week_number,
      'notes': notes,
      'checkup_date': checkup_date,
      'created_at': created_at ?? DateTime.now(),
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  /// 🔹 Convert Firestore → Dart
  factory PregnancyRecordModel.fromMap(Map<String, dynamic> map, String id) {
    return PregnancyRecordModel(
      id: id,
      user_id: map['user_id'],
      week_number: (map['week_number'] is int)
          ? map['week_number']
          : int.tryParse(map['week_number'].toString()),
      notes: map['notes'],
      checkup_date: _toDate(map['checkup_date']),
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  /// 🕒 Helper: chuyển Timestamp/String/DateTime → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
