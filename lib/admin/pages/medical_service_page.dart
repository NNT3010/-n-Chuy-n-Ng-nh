import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_medical_service.dart';
import 'edit_medical_service.dart';

class MedicalServicePage extends StatelessWidget {
  const MedicalServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏥 Quản lý Dịch vụ Y tế")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => AddMedicalServicePage()),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("medical_services").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              var doc = docs[i];
              // 👇 Lấy dữ liệu dạng Map để hiển thị an toàn
              var dataMap = doc.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  // Dùng dataMap['key'] ?? '' để tránh lỗi null
                  title: Text("🏥 ${dataMap['name'] ?? 'Chưa có tên'}"),
                  subtitle: Text("${dataMap['type'] ?? 'Other'} • ${dataMap['phone'] ?? 'Không có SĐT'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditMedicalServicePage(
                                  doc.id,
                                  dataMap // 👈 SỬA LỖI TẠI ĐÂY: Truyền Map thay vì Snapshot
                              )
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => FirebaseFirestore.instance
                            .collection("medical_services")
                            .doc(doc.id).delete(),
                      ),
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
}
