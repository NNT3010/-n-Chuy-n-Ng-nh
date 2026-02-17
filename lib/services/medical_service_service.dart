import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medical_service_model.dart';

class MedicalServiceService {
  final CollectionReference _col =
  FirebaseFirestore.instance.collection('medical_services');

  // 🔍 Hàm tìm kiếm dịch vụ
  Future<List<MedicalServiceModel>> searchServices({
    required String search,
    required String typeFilter,
  }) async {
    Query query = _col;

    // 1. Lọc theo loại (nếu không phải chọn "All")
    if (typeFilter != "All") {
      query = query.where('type', isEqualTo: typeFilter);
    }

    // 2. Lấy dữ liệu về
    QuerySnapshot snapshot = await query.get();

    List<MedicalServiceModel> services = snapshot.docs.map((doc) {
      return MedicalServiceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    // 3. Lọc theo tên (Search Text) ở phía Client (vì Firestore search chuỗi hạn chế)
    if (search.isNotEmpty) {
      services = services.where((s) {
        return (s.name?.toLowerCase().contains(search.toLowerCase()) ?? false) ||
            (s.address?.toLowerCase().contains(search.toLowerCase()) ?? false);
      }).toList();
    }

    return services;
  }
}
