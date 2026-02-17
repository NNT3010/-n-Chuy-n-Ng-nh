import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_growth_record.dart';

class GrowthListPage extends StatelessWidget {
  const GrowthListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📈 Danh sách chỉ số phát triển")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("growth_records")
            .orderBy("record_date", descending: true)
            .snapshots(),

        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          if (snap.data!.docs.isEmpty) return const Center(child: Text("⚠ Chưa có dữ liệu chỉ số phát triển"));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snap.data!.docs.length,

            itemBuilder: (_, i) {
              var doc = snap.data!.docs[i];
              var data = doc.data() as Map<String, dynamic>;
              String id = doc.id;
              String childId = data['childId'] ?? ''; // Lấy ID bé

              /// 🔥 Xử lý ngày record_date (timestamp → text)
              String date = (data["record_date"] is Timestamp)
                  ? DateFormat("dd/MM/yyyy").format(data["record_date"].toDate())
                  : "Không rõ";

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(

                  // 🔥 SỬA ĐỔI: Dùng _ChildNameFetcher để lấy tên bé từ ID
                  title: _ChildNameFetcher(childId: childId),

                  subtitle: Text(
                    "📅 $date\n"
                        "⚖ Cân nặng: ${data['weight']} kg\n"
                        "📏 Chiều cao: ${data['height']} cm\n"
                        "🧠 Vòng đầu: ${data['head_circumference']} cm\n"
                        "📝 ${data['notes'] ?? ''}",
                  ),
                  isThreeLine: true,

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// 🔷 Sửa
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditGrowthRecordPage(id, data),
                            ),
                          );
                        },
                      ),

                      /// 🔺 Xoá
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("growth_records")
                              .doc(id)
                              .delete();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("🗑 Đã xóa chỉ số phát triển")),
                            );
                          }
                        },
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

// ==================================================
// Widget nhỏ giúp lấy tên bé từ ID
// ==================================================
class _ChildNameFetcher extends StatelessWidget {
  final String childId;

  const _ChildNameFetcher({required this.childId});

  @override
  Widget build(BuildContext context) {
    if (childId.isEmpty) {
      return const Text("👶 Bé: (Không có ID)", style: TextStyle(fontWeight: FontWeight.bold));
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('children').doc(childId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("👶 Đang tải tên...", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey));
        }

        String name = "Không tìm thấy tên";
        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          name = data['name'] ?? data['fullname'] ?? "Bé không tên";
        }

        return Text("👶 Bé: $name", style: const TextStyle(fontWeight: FontWeight.bold));
      },
    );
  }
}
