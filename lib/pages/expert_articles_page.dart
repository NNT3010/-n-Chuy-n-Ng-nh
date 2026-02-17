import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expert_model.dart';
import '../models/article_model.dart';
import 'article_detail_page.dart'; // 👇 Đảm bảo bạn tạo file này ở Bước 2

class ExpertArticlesPage extends StatelessWidget {
  final ExpertModel expert;

  const ExpertArticlesPage({Key? key, required this.expert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Bài viết chuyên gia", style: TextStyle(fontSize: 14)),
            Text("BS. ${expert.full_name ?? ''}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ],
        ),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .where('expert_id', isEqualTo: expert.id) // Lọc theo ID chuyên gia
        // Lưu ý: Nếu bạn chỉ muốn hiện bài đã "Công khai" cho người dùng xem, hãy bỏ comment dòng dưới
        // và nhớ tạo Index nếu Firebase báo lỗi.
        // .where('is_published', isEqualTo: true)
            .orderBy('created_at', descending: true) // Mới nhất lên đầu
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Trạng thái chờ
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Bắt lỗi
          if (snapshot.hasError) {
            debugPrint("❌ Lỗi load bài viết: ${snapshot.error}");
            return Center(
              child: Text("Có lỗi xảy ra: ${snapshot.error}"),
            );
          }

          // 3. Không có dữ liệu
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Bác sĩ chưa có bài viết nào.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // 4. Hiển thị dữ liệu
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;
              var article = ArticleModel.fromMap(data, doc.id);

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // 👇 Chuyển sang trang đọc chi tiết
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ArticleDetailPage(article: article)
                        )
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh bìa bài viết
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: (article.image_url != null && article.image_url!.isNotEmpty)
                            ? Image.network(
                          article.image_url!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 160,
                            color: Colors.grey[200],
                            child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                          ),
                        )
                            : Container(
                          height: 160,
                          width: double.infinity,
                          color: Colors.pink[50],
                          child: const Center(
                              child: Icon(Icons.image, size: 50, color: Colors.pinkAccent)
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Danh mục
                            if (article.category != null && article.category!.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  article.category!.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                            // Tiêu đề
                            Text(
                              article.title ?? "Không có tiêu đề",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            // Ngày đăng
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  article.created_at != null
                                      ? DateFormat('dd/MM/yyyy').format(article.created_at!)
                                      : "Vừa xong",
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                const Text(
                                  "Đọc tiếp ->",
                                  style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
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
