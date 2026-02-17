import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';

class DoctorService {
  // 👇 SỬA LỖI Ở ĐÂY: Đổi 'doctors' thành 'Doctors' (viết Hoa)
  final CollectionReference doctorsRef =
  FirebaseFirestore.instance.collection('Doctors');

  /// 🔥 Lấy danh sách bác sĩ realtime
  Stream<List<DoctorModel>> getDoctors() {
    return doctorsRef
    // Nên lọc thêm điều kiện này để chỉ hiện bác sĩ đang hoạt động
    // Nếu data cũ chưa có field này thì bỏ dòng .where đi cũng được
    // .where('is_active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// 🔥 Lấy chi tiết 1 bác sĩ
  Future<DoctorModel?> getDoctorById(String id) async {
    final doc = await doctorsRef.doc(id).get();
    if (!doc.exists) return null;
    return DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  /// 🔥 Admin thêm bác sĩ
  Future<void> addDoctor(DoctorModel doctor) async {
    await doctorsRef.add(doctor.toMap());
  }

  /// 🔥 Admin cập nhật bác sĩ
  Future<void> updateDoctor(DoctorModel doctor) async {
    await doctorsRef.doc(doctor.id).update(doctor.toMap());
  }

  /// 🔥 Admin xóa bác sĩ
  Future<void> deleteDoctor(String id) async {
    await doctorsRef.doc(id).delete();
  }
}
