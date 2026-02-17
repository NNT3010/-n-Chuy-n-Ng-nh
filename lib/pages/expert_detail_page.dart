import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/expert_model.dart';

class ExpertDetailPage extends StatelessWidget {
  final ExpertModel expert;

  const ExpertDetailPage({super.key, required this.expert});

  // Hàm mở trình gọi điện
  void _makePhoneCall(BuildContext context, String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể thực hiện cuộc gọi')),
        );
      }
    }
  }

  // Hàm gửi email
  void _sendEmail(BuildContext context, String email) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Liên hệ tư vấn&body=Xin chào bác sĩ...',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở ứng dụng email')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. HEADER ẢNH (SliverAppBar)
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.pinkAccent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                expert.full_name ?? "Chi tiết chuyên gia",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 5)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh nền
                  (expert.avatar_url != null && expert.avatar_url!.isNotEmpty)
                      ? Image.network(
                    expert.avatar_url!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                  )
                      : Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, size: 100, color: Colors.grey),
                  ),
                  // Lớp phủ đen mờ để text dễ đọc
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. NỘI DUNG CHI TIẾT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên và Chuyên môn
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expert.full_name ?? "Không rõ tên",
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.pink[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                expert.specialization ?? "Chuyên môn chưa cập nhật",
                                style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Rating giả định (nếu có)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 28),
                            Text("5.0", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Thông tin Kinh nghiệm & Bằng cấp
                  Row(
                    children: [
                      _buildInfoCard(
                        icon: Icons.work_outline,
                        title: "Kinh nghiệm",
                        value: "${expert.experience_years ?? 0} năm",
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 15),
                      _buildInfoCard(
                        icon: Icons.school_outlined,
                        title: "Bằng cấp",
                        value: expert.degree ?? "Cử nhân",
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Tiểu sử (Bio)
                  const Text(
                    "Tiểu sử",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    expert.biography ?? "Chưa có thông tin giới thiệu về chuyên gia này.",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
                  ),

                  const SizedBox(height: 30),

                  // Nút Liên hệ
                  const Text(
                    "Thông tin liên hệ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  if (expert.phone != null && expert.phone!.isNotEmpty)
                    ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.phone, color: Colors.white)),
                      title: const Text("Số điện thoại"),
                      subtitle: Text(expert.phone!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      contentPadding: EdgeInsets.zero,
                      onTap: () => _makePhoneCall(context, expert.phone!),
                    ),

                  if (expert.email != null && expert.email!.isNotEmpty)
                    ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.email, color: Colors.white)),
                      title: const Text("Email"),
                      subtitle: Text(expert.email!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      contentPadding: EdgeInsets.zero,
                      onTap: () => _sendEmail(context, expert.email!),
                    ),

                  const SizedBox(height: 40), // Khoảng trống dưới cùng
                ],
              ),
            ),
          ),
        ],
      ),

      // Nút Đặt lịch hẹn (Floating Action Button - Tuỳ chọn)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            // Điều hướng sang trang đặt lịch (nếu có)
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tính năng đặt lịch đang phát triển")));
          },
          child: const Text(
            "Đặt lịch hẹn ngay",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
