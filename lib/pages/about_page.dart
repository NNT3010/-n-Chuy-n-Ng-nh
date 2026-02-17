// --- Thay thế toàn bộ file AboutPage bằng bản đã sửa ổn định ---
import 'package:flutter/material.dart';
import 'register_page.dart'; // đảm bảo file này tồn tại

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Giới thiệu MeBeCare 🌸'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Tiêu đề ---
              Center(
                child: Text(
                  '🌸 Giới thiệu về MeBeCare',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color(0xFFF06292),
                          Color(0xFF7E57C2),
                          Color(0xFF42A5F5)
                        ],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Nền tảng chăm sóc sức khỏe mẹ và bé toàn diện, thông minh, và dễ sử dụng.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 25),

              // --- Hình ảnh ---
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'https://khoinguonsangtao.vn/wp-content/uploads/2022/10/hinh-anh-me-va-be-hoat-hinh.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                '🌱 Mục tiêu của MeBeCare',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'MeBeCare được phát triển nhằm hỗ trợ các bà mẹ trong suốt thai kỳ và giai đoạn chăm sóc trẻ sơ sinh. '
                    'Chúng tôi cung cấp các công cụ tiện ích giúp bạn theo dõi sức khỏe, tiêm chủng, dinh dưỡng, phát triển thể chất và hơn thế nữa.',
                style: TextStyle(color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 25),

              // --- Lưới tính năng ---
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: const [
                  _FeatureCard(
                      icon: "🤰",
                      title: "Theo dõi thai kỳ",
                      desc: "Theo dõi tuần thai, nhận lời khuyên mỗi tuần."),
                  _FeatureCard(
                      icon: "💉",
                      title: "Lịch tiêm & Nhắc nhở",
                      desc: "Nhắc lịch tiêm chủng tự động theo chuẩn Bộ Y Tế."),
                  _FeatureCard(
                      icon: "📈",
                      title: "Chỉ số phát triển",
                      desc: "Ghi nhận cân nặng, chiều cao, vòng đầu từng mốc."),
                  _FeatureCard(
                      icon: "📅",
                      title: "Đặt lịch với bác sĩ",
                      desc: "Đặt lịch và nhận xác nhận qua email tức thì."),
                ],
              ),
              const SizedBox(height: 30),

              // --- Bảo mật & AI ---
              const _InfoSection(
                title: '🔐 Cam kết bảo mật',
                content:
                'MeBeCare cam kết bảo mật dữ liệu người dùng tuyệt đối. Mọi thông tin được mã hóa và lưu trữ an toàn. Bạn hoàn toàn kiểm soát quyền riêng tư của mình.',
              ),
              const SizedBox(height: 20),
              const _InfoSection(
                title: '🤖 Công nghệ AI hỗ trợ',
                content:
                'Tích hợp chatbot AI giúp mẹ bầu và phụ huynh hỏi đáp nhanh chóng về dinh dưỡng, lịch tiêm, thai kỳ và nhiều hơn nữa.',
              ),
              const SizedBox(height: 40),

              // --- Nút ---
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('🎉 Đăng ký ngay'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterPage()),
                        );
                      },
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.home),
                      label: const Text('🏠 Về trang chủ'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.pinkAccent),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget phụ - thẻ tính năng
class _FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;

  const _FeatureCard(
      {required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.pink[50],
      elevation: 3,
      shadowColor: Colors.pink.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style:
                const TextStyle(fontSize: 13, color: Colors.black54, height: 1.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget phụ - phần mô tả dài
class _InfoSection extends StatelessWidget {
  final String title;
  final String content;

  const _InfoSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
        const SizedBox(height: 10),
        Text(content,
            style: const TextStyle(color: Colors.black87, height: 1.5)),
      ],
    );
  }
}
