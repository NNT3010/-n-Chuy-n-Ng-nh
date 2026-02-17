import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? address;
  String? role;
  DateTime? dateOfBirth;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.role = 'Mother',
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'date_of_birth': dateOfBirth,
      'created_at': createdAt ?? DateTime.now(),
      'updated_at': updatedAt ?? DateTime.now(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      role: map['role'],
      dateOfBirth: _toDate(map['date_of_birth']),
      createdAt: _toDate(map['created_at']),
      updatedAt: _toDate(map['updated_at']),
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
