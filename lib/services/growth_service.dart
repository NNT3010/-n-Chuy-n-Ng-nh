// lib/services/growth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/growth_record_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GrowthService {
  // Khai báo biến CollectionReference dùng chung
  final CollectionReference _col =
  FirebaseFirestore.instance.collection('growth_records');

  // 1. Thêm record mới
  Future<String> addGrowthRecord(GrowthRecordModel record) async {
    // Chuyển object thành map để lưu lên Firestore
    final doc = await _col.add(record.toMap());
    return doc.id;
  }

  // 2. Cập nhật record
  Future<void> updateGrowthRecord(String id, GrowthRecordModel updated) {
    return _col.doc(id).update(updated.toMap());
  }

  // 3. Xóa record
  Future<void> deleteGrowthRecord(String id) {
    return _col.doc(id).delete();
  }

  // 4. Stream lấy danh sách chỉ số theo childId
  Stream<List<GrowthRecordModel>> getRecordsByChild(String childId) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Nếu chưa đăng nhập thì trả về Stream rỗng để tránh lỗi crash
    if (uid == null) return const Stream.empty();

    return _col // Sử dụng biến _col đã khai báo ở trên
        .where('childId', isEqualTo: childId)
    // 👇 Thêm dòng này để khớp với Security Rules (người dùng chỉ đọc được data của chính mình)
        .where('userId', isEqualTo: uid)
        .orderBy('record_date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      // Sử dụng fromMap để chuyển đổi dữ liệu từ Firestore về Model
      // Truyền thêm doc.id để model nắm giữ ID của document
      return GrowthRecordModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList());
  }

  // 5. Lấy 1 record cụ thể bằng ID
  Future<GrowthRecordModel?> getById(String id) async {
    try {
      final doc = await _col.doc(id).get();
      if (!doc.exists) return null;
      return GrowthRecordModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      print("Lỗi khi lấy record: $e");
      return null;
    }
  }

  // 6. Lấy record mới nhất của bé (để hiển thị tóm tắt)
  Future<List<GrowthRecordModel>> getLatestRecord(String childId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    try {
      final snap = await _col
          .where("childId", isEqualTo: childId) // Dùng childId (camelCase) cho thống nhất
          .where("userId", isEqualTo: uid)      // Thêm điều kiện userId để qua Rules
          .orderBy("record_date", descending: true)
          .limit(1)
          .get();

      return snap.docs.map((d) {
        return GrowthRecordModel.fromMap(
          d.data() as Map<String, dynamic>,
          d.id,
        );
      }).toList();
    } catch (e) {
      print("Lỗi lấy record mới nhất: $e");
      return [];
    }
  }
}
