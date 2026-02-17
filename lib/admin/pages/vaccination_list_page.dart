import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_vaccination_page.dart';

class VaccinationListPage extends StatefulWidget {
  const VaccinationListPage({super.key});

  @override
  State<VaccinationListPage> createState() => _VaccinationListPageState();
}

class _VaccinationListPageState extends State<VaccinationListPage> {

  void reload() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📍 ADMIN — Danh sách lịch tiêm chủng")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("vaccination_records")
            .orderBy("vaccination_date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("❗ Chưa có lịch tiêm nào", style: TextStyle(color: Colors.red)));
          }

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, i) {
              var doc = docs[i];
              var data = doc.data() as Map<String, dynamic>;
              String id = doc.id;

              // 1. Lấy dữ liệu thô
              String vaccine = data["vaccine_name"] ?? "Không rõ";
              String childId = data["child_id"] ?? "";
              String userId  = data["userId"] ?? data["user_id"] ?? "";

              String date = data['vaccination_date'] != null
                  ? DateFormat('dd/MM/yyyy').format(data['vaccination_date'].toDate())
                  : "Chưa đặt ngày";
              bool done = data['is_completed'] == true;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Icon(
                    done ? Icons.check_circle : Icons.pending,
                    color: done ? Colors.green : Colors.orange,
                    size: 32,
                  ),
                  title: Text("💉 $vaccine", style: const TextStyle(fontWeight: FontWeight.bold)),

                  // 🔥 SỬ DỤNG WIDGET LOGIC MỚI ĐỂ TÌM TÊN
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NameFetcher(
                        id: childId,
                        collection: 'children',
                        label: "👶 Bé",
                        isUser: false, // Tìm trong bảng children
                      ),
                      _NameFetcher(
                        id: userId,
                        collection: 'users',
                        label: "👤 Người tạo",
                        isUser: true, // 🔥 Bật chế độ tìm đa bảng cho User
                      ),
                      const SizedBox(height: 4),
                      Text("📅 Ngày tiêm: $date"),
                      Text("📌 Trạng thái: ${done ? "Đã tiêm" : "Chưa tiêm"}"),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => EditVaccinationPage(docId: id, data: data)));
                          reload();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection("vaccination_records").doc(id).delete();
                          if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🗑 Đã xóa lịch tiêm")));
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
// 🔥 WIDGET THÔNG MINH TỰ TÌM TÊN ĐA BẢNG
// ==================================================
class _NameFetcher extends StatelessWidget {
  final String id;
  final String collection; // Collection mặc định
  final String label;
  final bool isUser; // Nếu là user thì tìm nhiều bảng

  const _NameFetcher({
    required this.id,
    required this.collection,
    required this.label,
    required this.isUser,
  });

  // Hàm tìm tên thông minh
  Future<String> _getName() async {
    if (id.isEmpty) return "Không có ID";

    try {
      // 1. Nếu là User, thử tìm trong 'users', 'experts', 'parents'
      if (isUser) {
        // Thử bảng 'users'
        var userDoc = await FirebaseFirestore.instance.collection('Users').doc(id).get();
        if (userDoc.exists) return _extractName(userDoc.data());

        // Thử bảng 'experts'
        var expertDoc = await FirebaseFirestore.instance.collection('experts').doc(id).get();
        if (expertDoc.exists) return _extractName(expertDoc.data());

        // Thử bảng 'parents'
        var parentDoc = await FirebaseFirestore.instance.collection('parents').doc(id).get();
        if (parentDoc.exists) return _extractName(parentDoc.data());

        print("❌ Không tìm thấy User ID: $id trong bất kỳ bảng nào.");
        return "ID: $id (Không tìm thấy)";
      }

      // 2. Nếu là Child, chỉ tìm bảng 'children'
      else {
        var doc = await FirebaseFirestore.instance.collection(collection).doc(id).get();
        if (doc.exists) return _extractName(doc.data());
      }
    } catch (e) {
      print("❌ Lỗi khi load tên ($label): $e");
    }

    return "ID: $id"; // Fallback nếu lỗi
  }

  // Hàm tách tên từ data (thử mọi trường có thể là tên)
  String _extractName(Map<String, dynamic>? data) {
    if (data == null) return "Không tên";
    return data['name'] ??
        data['fullName'] ??
        data['fullname'] ??
        data['display_name'] ??
        data['email'] ??
        "Không tên";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("$label: Đang tải...");
        }
        return Text("$label: ${snapshot.data}", style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87));
      },
    );
  }
}
