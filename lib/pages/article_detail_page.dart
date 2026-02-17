import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/article_model.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Phần ảnh bìa co giãn (SliverAppBar)
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true, // Giữ thanh AppBar khi cuộn
            backgroundColor: Colors.pinkAccent,
            flexibleSpace: FlexibleSpaceBar(
              background: (article.image_url != null && article.image_url!.isNotEmpty)
                  ? Image.network(
                article.image_url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              )
                  : Container(color: Colors.pink[100]),
            ),
          ),

          // Phần nội dung bài viết
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Danh mục & Ngày tháng
                  Row(
                    children: [
                      if (article.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            article.category!.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.pink, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const Spacer(),
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        article.created_at != null
                            ? DateFormat('dd/MM/yyyy').format(article.created_at!)
                            : "",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tiêu đề lớn
                  Text(
                    article.title ?? "Không có tiêu đề",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Nội dung chi tiết
                  Text(
                    article.content ?? "Không có nội dung.",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 50), // Khoảng trống dưới cùng
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
