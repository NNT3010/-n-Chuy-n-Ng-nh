import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String id;
  String full_name;
  String specialization;
  String hospital;
  String phone;
  String email;
  String profile_image_url;
  String description;
  bool is_active;
  DateTime? created_at;
  DateTime? updated_at;

  DoctorModel({
    required this.id,
    required this.full_name,
    required this.specialization,
    required this.hospital,
    required this.phone,
    required this.email,
    required this.profile_image_url,
    required this.description,
    required this.is_active,
    this.created_at,
    this.updated_at,
  });

  /// 🔥 Convert Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'full_name': full_name,
      'specialization': specialization,
      'hospital': hospital,
      'phone': phone,
      'email': email,
      'profile_image_url': profile_image_url,
      'description': description,
      'is_active': is_active,
      'created_at': created_at != null ? Timestamp.fromDate(created_at!) : Timestamp.now(),
      'updated_at': updated_at != null ? Timestamp.fromDate(updated_at!) : Timestamp.now(),
    };
  }

  /// 🔥 Convert Firestore → Dart
  factory DoctorModel.fromMap(Map<String, dynamic> map, String id) {
    return DoctorModel(
      id: id,
      full_name: map['full_name'] ?? '',
      specialization: map['specialization'] ?? '',
      hospital: map['hospital'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      profile_image_url: map['profile_image_url'] ?? '',
      description: map['description'] ?? '',
      is_active: map['is_active'] ?? true,
      created_at: _toDate(map['created_at']),
      updated_at: _toDate(map['updated_at']),
    );
  }

  /// Helper: Timestamp → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
