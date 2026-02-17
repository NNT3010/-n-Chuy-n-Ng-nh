import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'doctor_add_page.dart';
import 'doctor_edit_page.dart';

class DoctorsPage extends StatelessWidget {

  // 👇 SỬA 1: Đổi 'doctors' thành 'Doctors' (viết Hoa)
  final doctorsRef = FirebaseFirestore.instance.collection('Doctors');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🩺 Danh sách Bác sĩ")),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => AddDoctorPage())),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: doctorsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải dữ liệu"));
          }

          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("⚠ Chưa có bác sĩ nào"));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              var d = docs[i];
              // Lấy data dạng Map để truy cập an toàn hơn
              var data = d.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.blue, size: 30),
                  title: Text(
                    // Dùng data['key'] thay vì d['key'] để tránh lỗi type
                      "👨‍⚕️ ${data['full_name'] ?? 'Chưa có tên'}",
                      style: const TextStyle(fontWeight: FontWeight.bold)
                  ),

                  // 👇 SỬA 2: Đổi 'specialty' thành 'specialization'
                  subtitle: Text(
                      "🧬 ${data['specialization'] ?? 'Chưa rõ chuyên khoa'}\n"
                          "🏥 ${data['hospital'] ?? 'Chưa rõ bệnh viện'}"
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  EditDoctorPage(id: d.id, data: data)))), // Truyền data đã cast

                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, d.id))
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Hàm xác nhận xóa cho chuyên nghiệp
  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc muốn xóa bác sĩ này không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await doctorsRef.doc(id).delete();
              Navigator.pop(ctx);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
