import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medical_record_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalRecordService {

  final CollectionReference records =
  FirebaseFirestore.instance.collection('medical_records');

  /// THÊM (đang hoạt động OK) - GIỮ NGUYÊN
  Future<void> addRecord(MedicalRecordModel record) async {
    await records.add(record.toMap());
  }

  /// 🔥 UPDATE — BỔ SUNG HỖ TRỢ RULE MỚI
  Future<void> updateRecord(String id, MedicalRecordModel record) async {
    final data = record.toMap();

    // Auto map user_id -> userId để vượt Rule
    if (record.user_id != null) {
      data["userId"] = record.user_id;
    }

    await records.doc(id).update(data);
  }

  /// DELETE — giữ nguyên nhưng admin vẫn xóa được
  Future<void> deleteRecord(String id) async {
    await records.doc(id).delete();
  }

  /// 🔥 GET list — User chỉ thấy hồ sơ thuộc mình / Admin thấy tất cả
  Stream<List<MedicalRecordModel>> getUserRecords(String userId) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('medical_records')
        .where('user_id', isEqualTo: uid)   // user chỉ xem hồ sơ của mình
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MedicalRecordModel.fromMap(
      doc.data() as Map<String, dynamic>,
      doc.id,
    ))
        .toList());
  }

  /// 🔥 ADMIN LOAD TẤT CẢ (nếu cần)
  Stream<List<MedicalRecordModel>> getAllRecordsForAdmin() {
    return records.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => MedicalRecordModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }
}
