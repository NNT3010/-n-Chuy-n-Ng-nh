import 'package:cloud_firestore/cloud_firestore.dart';

class ChildModel {
  String? id;
  String? family_id;
  String? name;
  String? gender;
  DateTime? date_of_birth;
  DateTime? created_at;  DateTime? updated_at;

  ChildModel({
    this.id,
    this.family_id,
    this.name,
    this.gender,
    this.date_of_birth,
    this.created_at,
    this.updated_at,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'family_id': family_id,
      'name': name,
      'gender': gender ?? 'unknown',
      // Đảm bảo gửi Timestamp lên Firestore
      'date_of_birth': date_of_birth != null ? Timestamp.fromDate(date_of_birth!) : null,
      'created_at': created_at != null ? Timestamp.fromDate(created_at!) : FieldValue.serverTimestamp(),
      'updated_at': updated_at != null ? Timestamp.fromDate(updated_at!) : FieldValue.serverTimestamp(),
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory ChildModel.fromMap(Map<String, dynamic> map, String id) {
    return ChildModel(
      id: id,
      family_id: map['family_id'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? 'unknown',
      date_of_birth: _toDate(map['date_of_birth']),
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  /// 🔥 Bổ sung: Dùng với Firestore converter()
  factory ChildModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    return ChildModel.fromMap(doc.data()!, doc.id);
  }


  /// 🕒 Helper: chuyển Timestamp hoặc String → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
