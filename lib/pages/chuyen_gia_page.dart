import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/expert_model.dart';
import 'expert_detail_page.dart';
import 'expert_articles_page.dart';

class ChuyenGiaPage extends StatelessWidget {
  const ChuyenGiaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gặp Gỡ Chuyên Gia'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("experts").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Chưa có chuyên gia nào.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              // 🟢 QUAN TRỌNG: Kiểm tra xem có trường 'uid' hoặc 'user_id' trong data không
              // Nếu document ID trong bảng experts KHÔNG PHẢI là uid đăng nhập,
              // thì bạn phải lưu uid đăng nhập vào một trường (ví dụ: 'uid') trong document đó.

              // Cách xử lý ID ở đây:
              String realExpertId = docs[index].id; // Mặc định lấy ID của document

              // Nếu trong data có chứa 'uid', ta ưu tiên dùng nó vì đó mới là ID người viết bài
              if (data.containsKey('uid') && data['uid'] != null) {
                realExpertId = data['uid'];
              } else if (data.containsKey('user_id') && data['user_id'] != null) {
                realExpertId = data['user_id'];
              }

              // Tạo model, nhưng lưu ý phần id
              final expert = ExpertModel.fromMap(data, realExpertId);

              return ExpertCard(expert: expert);
            },
          );
        },
      ),
    );
  }
}

class ExpertCard extends StatelessWidget {
  final ExpertModel expert;

  const ExpertCard({Key? key, required this.expert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        children: [
          // Phần thông tin phía trên (Ảnh + Tên)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: (expert.avatar_url != null && expert.avatar_url!.isNotEmpty)
                      ? Image.network(
                    expert.avatar_url!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 80, width: 80, color: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  )
                      : Container(
                    height: 80, width: 80, color: Colors.pink[50],
                    child: const Icon(Icons.person, color: Colors.pinkAccent, size: 40),
                  ),
                ),
                const SizedBox(width: 16),

                // Thông tin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expert.full_name ?? "Chuyên gia",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          expert.specialization ?? "Chuyên khoa",
                          style: TextStyle(color: Colors.blue[800], fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        expert.biography ?? "Chưa có mô tả.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const Divider(height: 1),

          // 2 Nút hành động
          Row(
            children: [
              // Nút Xem bài viết
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    // 👇 Debug log để kiểm tra ID trước khi chuyển trang
                    print("Chuyen sang trang bai viet voi Expert ID: ${expert.id}");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpertArticlesPage(expert: expert),
                      ),
                    );
                  },
                  icon: const Icon(Icons.article_outlined, size: 20, color: Colors.orange),
                  label: const Text("Xem bài viết", style: TextStyle(color: Colors.orange)),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),

              Container(width: 1, height: 30, color: Colors.grey[300]), // Đường kẻ dọc

              // Nút Xem chi tiết
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpertDetailPage(expert: expert),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline, size: 20, color: Colors.pinkAccent),
                  label: const Text("Chi tiết", style: TextStyle(color: Colors.pinkAccent)),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
