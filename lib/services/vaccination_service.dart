import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vaccination_record_model.dart';

class VaccinationService {
  final _col = FirebaseFirestore.instance.collection("vaccination_records");

  /// Lấy danh sách theo user — dùng để load list chính
  Stream<List<VaccinationRecordModel>> getByUser() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _col.where("userId", isEqualTo: uid)
        .orderBy("vaccination_date")
        .snapshots()
        .map((snap)=> snap.docs
        .map((d)=> VaccinationRecordModel.fromMap(d.data(), d.id))
        .toList());
  }

  //---------------------------------------------------------------------------
  // 🔥 2) LẤY DANH SÁCH THEO TỪNG BÉ
  //---------------------------------------------------------------------------
  Stream<List<VaccinationRecordModel>> getByChild(String childId) {
    return _col
        .where("child_id", isEqualTo: childId)
        .orderBy("vaccination_date")
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => VaccinationRecordModel.fromMap(d.data(), d.id))
        .toList());
  }

  //---------------------------------------------------------------------------
  // 🔥 3) LẤY THEO FAMILY — hỗ trợ nhiều bé/1 user, lọc theo hộ gia đình
  //---------------------------------------------------------------------------
  Stream<List<VaccinationRecordModel>> getByFamily(String familyId) {
    return _col
        .where("family_id", isEqualTo: familyId)
        .orderBy("vaccination_date")
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => VaccinationRecordModel.fromMap(d.data(), d.id))
        .toList());
  }

  //---------------------------------------------------------------------------
  // 📌 4) GỢI Ý THEO THÁNG TUỔI (giữ nguyên)
  //---------------------------------------------------------------------------
  Future<List<String>> suggestVaccines(int months) async {
    const data = {
      0: ["BCG", "Viêm gan B mũi 1"],
      2: ["6 trong 1 mũi 1", "Rota mũi 1"],
      4: ["6 trong 1 mũi 2", "Rota mũi 2"],
      6: ["6 trong 1 mũi 3", "Phế cầu mũi 1"],
      9: ["Sởi đơn"],
      12: ["MMR", "Thủy đậu"],
      18: ["6 trong 1 nhắc lại", "Viêm gan A"],
    };
    return data[months] ?? [];
  }

  /// THÊM MỚI RECORD
  Future<void> create({
    required String childId,
    required String vaccineName,
    required DateTime date,
    required bool isCompleted,
    String? notes,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _col.add({
      "userId": uid,
      "child_id": childId,
      "vaccine_name": vaccineName,
      "vaccination_date": date,
      "is_completed": isCompleted,
      "notes": notes ?? "",
      "created_at": DateTime.now(),
      "updated_at": DateTime.now(),
    });
  }

  /// CẬP NHẬT RECORD
  Future<void> update(String id, Map<String,dynamic> data) async {
    data["updated_at"] = DateTime.now();
    await _col.doc(id).update(data);
  }

  /// XÓA RECORD
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
