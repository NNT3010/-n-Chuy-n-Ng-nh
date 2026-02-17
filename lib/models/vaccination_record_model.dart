import 'package:cloud_firestore/cloud_firestore.dart';

class VaccinationRecordModel {
  String? id;
  String? childId;         // 🔥 sửa đúng tên Firestore
  String? familyId;        // 🔥 thay user_id => familyId
  String? child_name;
  String? vaccine_name;
  DateTime? vaccination_date;
  bool? is_completed;
  String? notes;
  DateTime? created_at;
  DateTime? updated_at;

  VaccinationRecordModel({
    this.id,
    this.childId,
    this.familyId,
    this.child_name,
    this.vaccine_name,
    this.vaccination_date,
    this.is_completed = false,
    this.notes,
    this.created_at,
    this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,              // 🔥 đúng key
      'family_id': familyId,           // 🔥 đúng key
      'child_name': child_name,
      'vaccine_name': vaccine_name,
      'vaccination_date': vaccination_date,
      'is_completed': is_completed ?? false,
      'notes': notes,
      'created_at': created_at ?? DateTime.now(),
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  factory VaccinationRecordModel.fromMap(Map<String, dynamic> map, String id) {
    return VaccinationRecordModel(
      id: id,
      childId: map['childId'],                   // 🔥 sửa đúng
      familyId: map['family_id'],                // 🔥 sửa đúng
      child_name: map['child_name'],
      vaccine_name: map['vaccine_name'],
      vaccination_date: _toDate(map['vaccination_date']),
      is_completed: map['is_completed'] ?? false,
      notes: map['notes'],
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
