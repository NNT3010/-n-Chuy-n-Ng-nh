// lib/models/appointment_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String? id;
  // --- SỬA CÁC TRƯỜNG DƯỚI ĐÂY ---
  String? userId;
  String? doctorId;
  DateTime? appointmentDate;
  String? notes;
  String? status; // pending, confirmed, completed, cancelled
  DateTime? createdAt;
  DateTime? updatedAt;

  AppointmentModel({
    this.id,
    // --- SỬA CONSTRUCTOR ---
    this.userId,
    this.doctorId,
    this.appointmentDate,
    this.notes,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  /// 🔹 Convert từ Dart → Firestore
  Map<String, dynamic> toMap() {
    // --- SỬA CÁC KEY TRONG MAP ---
    return {
      'userId': userId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate, // Không cần gán DateTime.now() nữa
      'notes': notes,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// 🔹 Convert từ Firestore → Dart
  factory AppointmentModel.fromMap(Map<String, dynamic> map, String id) {
    // --- SỬA CÁC KEY KHI ĐỌC TỪ MAP ---
    return AppointmentModel(
      id: id,
      userId: map['userId'],
      doctorId: map['doctorId'],
      appointmentDate: _toDate(map['appointmentDate']),
      notes: map['notes'],
      status: map['status'] ?? 'pending',
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
    );
  }

  /// 🕒 Helper: chuyển Timestamp hoặc String → DateTime
  static DateTime? _toDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return null; // Đơn giản hóa, vì Firestore sẽ trả về Timestamp
  }
}
