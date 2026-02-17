import 'package:cloud_firestore/cloud_firestore.dart';

class ExpertModel {
  String? id;
  String? full_name;      // Họ tên
  String? specialization; // Chuyên môn (field)
  String? degree;         // Bằng cấp
  int? experience_years;  // Số năm kinh nghiệm
  String? biography;      // Tiểu sử (bio)
  String? avatar_url;     // Ảnh đại diện
  String? email;
  String? phone;
  DateTime? created_at;

  ExpertModel({
    this.id,
    this.full_name,
    this.specialization,
    this.degree,
    this.experience_years,
    this.biography,
    this.avatar_url,
    this.email,
    this.phone,
    this.created_at,
  });

  /// 🔹 Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'full_name': full_name,
      'specialization': specialization,
      'degree': degree,
      'experience_years': experience_years ?? 0,
      'biography': biography,
      'avatar_url': avatar_url,
      'email': email,
      'phone': phone,
      'created_at': created_at ?? DateTime.now(),
    };
  }

  /// 🔹 Firestore → Dart
  factory ExpertModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpertModel(
      id: id,
      full_name: map['full_name'] ?? '',
      specialization: map['specialization'] ?? '',
      degree: map['degree'] ?? '',
      experience_years: map['experience_years'] is int
          ? map['experience_years']
          : int.tryParse(map['experience_years'].toString()) ?? 0,
      biography: map['biography'] ?? '',
      avatar_url: map['avatar_url'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      created_at: _toDate(map['created_at']),
    );
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    return DateTime.tryParse(value.toString());
  }
}
