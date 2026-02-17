import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalServiceModel {
  String? id;
  String? name;
  String? description;
  double? price;
  String? type;         // Hospital, Clinic, Pharmacy, Other
  String? address;      // Thêm địa chỉ
  String? phone;        // Thêm SĐT
  double? rating;       // Thêm đánh giá
  bool? is_active;
  DateTime? created_at;

  MedicalServiceModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.type,
    this.address,
    this.phone,
    this.rating,
    this.is_active = true,
    this.created_at,
  });

  // 🔹 Convert Dart -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price ?? 0.0,
      'type': type ?? 'Other',
      'address': address,
      'phone': phone,
      'rating': rating ?? 0.0,
      'is_active': is_active ?? true,
      'created_at': created_at ?? DateTime.now(),
    };
  }

  // 🔹 Firestore -> Dart
  factory MedicalServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return MedicalServiceModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] is int) ? (map['price'] as int).toDouble() : (map['price'] as num?)?.toDouble(),
      type: map['type'] ?? 'Other',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      rating: (map['rating'] is int) ? (map['rating'] as int).toDouble() : (map['rating'] as num?)?.toDouble(),
      is_active: map['is_active'] ?? true,
      created_at: map['created_at'] is Timestamp ? (map['created_at'] as Timestamp).toDate() : null,
    );
  }
}
