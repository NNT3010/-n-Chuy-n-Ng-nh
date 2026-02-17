import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecordModel {
  String? id;                   // 🔥 Firestore ID luôn là String!
  String? user_id;
  String? child_id;

  // Diagnosis = loại hồ sơ trong hệ thống C#
  String? diagnosis;            // Allergy / Condition / Medication / Other
  String? treatment;
  String? doctor_name;
  String? hospital;

  DateTime? record_date;
  String? attached_file_url;

  DateTime? created_at;
  DateTime? updated_at;

  MedicalRecordModel({
    this.id,
    this.user_id,
    this.child_id,
    this.diagnosis,
    this.treatment,
    this.doctor_name,
    this.hospital,
    this.record_date,
    this.attached_file_url,
    this.created_at,
    this.updated_at,
  });

  /// 🔥 Convert Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'child_id': child_id,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'doctor_name': doctor_name,
      'hospital': hospital,
      'record_date': record_date != null ? Timestamp.fromDate(record_date!) : null,
      'attached_file_url': attached_file_url,
      'created_at': created_at != null ? Timestamp.fromDate(created_at!) : Timestamp.now(),
      'updated_at': updated_at != null ? Timestamp.fromDate(updated_at!) : Timestamp.now(),
    };
  }

  /// 🔥 Convert Firestore → Dart
  factory MedicalRecordModel.fromMap(Map<String, dynamic> map, String id) {
    return MedicalRecordModel(
      id: id,                              // 🔥 ID là String
      user_id: map['user_id']?.toString(),
      child_id: map['child_id']?.toString(),
      diagnosis: map['diagnosis'] ?? '',
      treatment: map['treatment'],
      doctor_name: map['doctor_name'],
      hospital: map['hospital'],
      record_date: _toDate(map['record_date']),
      attached_file_url: map['attached_file_url'],
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  /// 🕒 Helper
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }

  /// ✔ Khi chỉnh sửa
  MedicalRecordModel copyWith({
    String? diagnosis,
    String? treatment,
    String? doctor_name,
    String? hospital,
    String? attached_file_url,
    DateTime? record_date,
    DateTime? updated_at,
  }) {
    return MedicalRecordModel(
      id: id,
      user_id: user_id,
      child_id: child_id,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      doctor_name: doctor_name ?? this.doctor_name,
      hospital: hospital ?? this.hospital,
      record_date: record_date ?? this.record_date,
      attached_file_url: attached_file_url ?? this.attached_file_url,
      created_at: created_at,
      updated_at: updated_at ?? DateTime.now(),
    );
  }

  factory MedicalRecordModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    return MedicalRecordModel.fromMap(doc.data()!, doc.id);
  }
}
