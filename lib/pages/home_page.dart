import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mebecare/pages/chuyen_gia_page.dart';
import 'package:mebecare/pages/doctor_list_page.dart';
import 'package:mebecare/pages/huongdan_page.dart';
import 'package:mebecare/pages/lien_he_page.dart';
import 'package:mebecare/pages/medical_record_page.dart';
import 'package:mebecare/pages/service_detail_page.dart';
import 'package:mebecare/services/auth_service.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mebecare/pages/about_page.dart';
import 'package:mebecare/pages/register_page.dart';
import 'package:mebecare/pages/pregnancy_tracking_page.dart';
import 'package:mebecare/pages/search_service_page.dart';
import 'package:mebecare/pages/cost_prediction_page.dart';
import 'package:mebecare/pages/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';






// =================== TRANG CHÍNH =====================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = AuthService();
  final TextEditingController _searchController = TextEditingController();
  List<String> services = [
    'Khám thai định kỳ',
    'Tư vấn dinh dưỡng',
    'Theo dõi phát triển trẻ',
    'Tiêm chủng mở rộng',
    'Siêu âm thai 4D',
    'Tư vấn sau sinh',
  ];
  List<String> filteredServices = [];

  @override
  void initState() {
    super.initState();
    filteredServices = services;
  }

  void _searchService(String keyword) {
    setState(() {
      filteredServices = services
          .where((s) => s.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void _openChatBot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatBotPage()),
    );
  }

  void _openMailBox() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            userId: user.uid,
            userName: user.displayName ?? user.email ?? "Người dùng",
            isAdminView: false, // User đang xem, không phải Admin
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng đăng nhập để chat với Admin")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeBeCare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline),
            tooltip: 'Hộp thư hỗ trợ',
            onPressed: _openMailBox,
          ),
          // Nút menu 3 gạch
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu), // Nút 3 gạch
            onSelected: (value) {
              if (value == 'guide') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HuongDanPage()),
                );
              } else if (value == 'experts') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChuyenGiaPage()),
                );
              } else if (value == 'contact') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LienHePage()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'guide',
                child: Text('📘 Hướng dẫn sử dụng'),
              ),
              PopupMenuItem(
                value: 'experts',
                child: Text('👩‍⚕️ Gặp Gỡ Chuyên Gia'),
              ),
              PopupMenuItem(
                value: 'contact',
                child: Text('📞 Liên hệ'),
              ),
            ],
          ),

          // Nút đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              await auth.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            FeaturesSection(onSearch: _searchService),
            SearchServiceSection(
              controller: _searchController,
              filtered: filteredServices,
              onSearch: _searchService,
            ),
            const HowItWorksSection(),
            const TestimonialsSection(),
            const CTASection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

// ================= HERO SECTION ===================
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.shade50,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Chăm sóc sức khỏe mẹ và bé toàn diện',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Theo dõi, lưu trữ và quản lý sức khỏe cho mẹ và bé một cách dễ dàng, an toàn và hiệu quả.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              showDialog(context: context, builder: (_) => const QuizDialog());
            },
            child: const Text('Bắt đầu ngay'),
          ),
          const SizedBox(height: 20),
          Image.network(
            'https://khoinguonsangtao.vn/wp-content/uploads/2022/10/hinh-anh-me-va-be-hoat-hinh.jpg',
            height: 220,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

// ================= TÍNH NĂNG NỔI BẬT ===================
class FeaturesSection extends StatelessWidget {
  final Function(String) onSearch;
  const FeaturesSection({super.key, required this.onSearch});

  final List<Map<String, dynamic>> features = const [
    {
      'icon': Icons.favorite,
      'title': 'Theo dõi thai kỳ',
      'desc': 'Theo dõi sự phát triển của thai nhi theo từng tuần.',
      'color': Colors.pinkAccent
    },
    {
      'icon': Icons.folder_shared,
      'title': 'Hồ sơ sức khỏe',
      'desc': 'Lưu trữ hồ sơ sức khỏe của mẹ và bé.',
      'color': Colors.blueAccent
    },
    {
      'icon': Icons.local_hospital,
      'title': 'Kết nối bác sĩ',
      'desc': 'Trao đổi trực tiếp với bác sĩ, nhận tư vấn y tế kịp thời.',
      'color': Colors.green
    },
    {
      'icon': Icons.search,
      'title': 'Tìm kiếm dịch vụ',
      'desc': 'Tìm và đặt lịch khám hoặc tiêm chủng phù hợp.',
      'color': Colors.orange
    },
    {
      'icon': Icons.chat,
      'title': 'Chatbot AI',
      'desc': 'Trò chuyện cùng trợ lý ảo MeBe AI.',
      'color': Colors.deepPurpleAccent
    },
    {
      'icon': Icons.payments,
      'title': 'Dự đoán chi phí',
      'desc': 'Ước tính chi phí y tế, sinh nở, khám chữa bệnh.',
      'color': Colors.deepPurpleAccent
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Tính năng nổi bật',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: features.map((feature) {
              return InkWell(
                onTap: () {
                  if (feature['title'] == 'Theo dõi thai kỳ') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PregnancyTrackingPage()),
                    );
                  }
                  else if (feature['title'] == 'Hồ sơ sức khỏe') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MedicalRecordPage()),
                    );
                  }
                  else if (feature['title'] == 'Kết nối bác sĩ') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorListPage(),   // KHÔNG cần const vì trang có dữ liệu truyền vào
                      ),
                    );
                  }
                  else if (feature['title'] == 'Chatbot AI') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatBotPage()),
                    );
                  }
                  else if (feature['title'] == 'Tìm kiếm dịch vụ') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchServicePage()),
                    );
                  }
                  else if (feature['title'] == 'Dự đoán chi phí') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CostPredictionPage()),
                    );
                  }
                  else {
                    onSearch(feature['title']);
                  }
                },
                child: SizedBox(
                  width: 160,
                  height: 190, // ✅ Chiều cao đồng nhất
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Căn đều
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(feature['icon'],
                              color: feature['color'], size: 40),
                          const SizedBox(height: 8),
                          Text(feature['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(feature['desc'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ================= UI DỊCH VỤ NÂNG CAO ===================
class SearchServiceSection extends StatelessWidget {
  final TextEditingController controller;
  final List<String> filtered;
  final Function(String) onSearch;

  SearchServiceSection({
    super.key,
    required this.controller,
    required this.filtered,
    required this.onSearch,
  });

  // ================== DỮ LIỆU DỊCH VỤ HOÀN CHỈNH ===================
  final Map<String, Map<String, String>> serviceData = {
    "Khám thai định kỳ": {
      "desc": "Theo dõi sức khỏe mẹ và bé, siêu âm và tư vấn đầy đủ theo từng giai đoạn thai kỳ.",
      "img": "https://suckhoedoisong.qltns.mediacdn.vn/thumb_w/640/324455921873985536/2023/9/18/kham-thai-dinh-ky-16950078932842033641462.jpg"
    },
    "Tư vấn dinh dưỡng": {
      "desc": "Xây dựng chế độ ăn phù hợp cho mẹ và bé theo từng thời điểm.",
      "img": "https://nreci.org/wp-content/uploads/2023/05/quy-trinh-tu-van-dinh-duong.webp"
    },
    "Theo dõi phát triển trẻ": {
      "desc": "Đánh giá các chỉ số phát triển theo chuẩn WHO như chiều cao, cân nặng, BMI.",
      "img": "https://cdn.hstatic.net/files/200000426093/article/cac-giai-doan-phat-trien-cua-tre-so-sinh_5b3cc55aec55439fb289adaa712448d6_1024x1024.jpg"
    },
    "Tiêm chủng mở rộng": {
      "desc": "Cập nhật lịch tiêm chủng, nhắc lịch và theo dõi phản ứng sau tiêm.",
      "img": "https://cdn.nhathuoclongchau.com.vn/unsafe/800x0/tiem_chung_mo_rong_0_02d58c36e0.jpg"
    },
    "Siêu âm thai 4D": {
      "desc":
      "Công nghệ siêu âm 4D hiện đại mang tới hình ảnh thai nhi sắc nét và chân thực.",
      "img": "https://benhvienphuongdong.vn/public/uploads/2024/thang-2/sieu-am-4d/sieu-am-4d-ro-net-hon.jpg"
    },
    "Tư vấn sau sinh": {
      "desc": "Chăm sóc mẹ sau sinh, tâm lý, nuôi con bằng sữa mẹ và dinh dưỡng hồi phục.",
      "img": "https://tudu.com.vn/data/2025/02/18/09383188-2.png"
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.shade50,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔍 Tìm hiểu dịch vụ y tế',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Ô tìm kiếm
          TextField(
            controller: controller,
            onChanged: onSearch,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Nhập tên dịch vụ...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================== GRID 2 CỘT ==================
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,

              // ⭐ CHỈ CẦN FIX Ở ĐÂY
              childAspectRatio: 0.64,
            ),
            itemBuilder: (context, index) {
              final service = filtered[index];
              final info = serviceData[service] ?? {};

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceDetailPage(
                        title: service,
                        description: info["desc"]!,
                        imageUrl: info["img"]!,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          info["img"]!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              info["desc"]!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ================= CHATBOT GEMINI AI ===================
class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // ⚠️ THAY BẰNG IP của PC bạn
  final String _apiUrl = "http://192.168.1.4:5000/api/GeminiProxy/generate";

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _controller.clear();
      _isLoading = true;
    });

    try {
      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"prompt": text}),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        final reply = json["output"] ?? "Không hiểu câu hỏi 😅";

        setState(() {
          _messages.add({'role': 'bot', 'content': reply});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'bot',
            'content': "⚠ Lỗi server: ${res.statusCode}"
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'content': "❌ Không thể kết nối server.\nKiểm tra IP + WiFi"
        });
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot AI - MeBeCare"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.pinkAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["content"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const CircularProgressIndicator(color: Colors.pinkAccent),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Nhập câu hỏi...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: _isLoading ? null : sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ================== CÁC PHẦN KHÁC ==================
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  final List<String> steps = const [
    'Đăng ký tài khoản và nhập thông tin cơ bản.',
    'Cập nhật dữ liệu sức khỏe, lịch sử y tế.',
    'Nhận lời khuyên và thông tin chuyên biệt.',
    'Theo dõi tiến trình sức khỏe qua thời gian.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.shade50,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('Cách hệ thống hoạt động',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Column(
            children: steps.asMap().entries.map((e) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.pinkAccent,
                  child:
                  Text('${e.key + 1}', style: const TextStyle(color: Colors.white)),
                ),
                title: Text(e.value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  final List<Map<String, String>> feedbacks = const [
    {
      'name': 'Chị Hương',
      'desc':
      '“Hệ thống giúp tôi theo dõi sức khỏe bé dễ dàng và chia sẻ với bác sĩ khi cần.”'
    },
    {
      'name': 'Chị Linh',
      'desc':
      '“Tính năng theo dõi thai kỳ chi tiết và hữu ích, giúp tôi chuẩn bị tốt hơn.”'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('Phản hồi từ người dùng',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: feedbacks.map((f) {
              return SizedBox(
                width: 250,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(f['desc']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 10),
                        Text(f['name']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pinkAccent,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Text('Bắt đầu hành trình chăm sóc sức khỏe',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          const Text(
            'Đăng ký ngay hôm nay để theo dõi sức khỏe mẹ và bé toàn diện!',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, foregroundColor: Colors.pink),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text('Đăng ký ngay'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutPage()),
                  );
                },
                child: const Text('Tìm hiểu thêm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(20),
      child: const Column(
        children: [
          Text('© 2025 MeBeCare - Chăm sóc mẹ và bé toàn diện'),
          SizedBox(height: 4),
          Text('Email: support@mebe.vn | Hotline: 0988 605 814',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// ================= QUIZ DIALOG ===================
class QuizDialog extends StatefulWidget {
  const QuizDialog({super.key});

  @override
  State<QuizDialog> createState() => _QuizDialogState();
}

class _QuizDialogState extends State<QuizDialog> {
  String? stage;
  String? interest;
  String? result;

  void submitQuiz() {
    if (stage == null || interest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đầy đủ thông tin!')),
      );
      return;
    }
    setState(() {
      if (stage == 'pregnant' && interest == 'tracking') {
        result = '👉 Gợi ý: Theo dõi thai kỳ để biết sự phát triển từng tuần.';
      } else if (stage == 'postpartum' && interest == 'doctor') {
        result = '👩‍⚕️ Gợi ý: Kết nối bác sĩ để nhận tư vấn sau sinh.';
      } else {
        result = '💡 Hãy khám phá thêm các tính năng trong MeBeCare!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Khám phá tính năng phù hợp'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bạn hiện đang ở giai đoạn nào?'),
          for (var s in ['pregnant', 'postpartum', 'parent'])
            RadioListTile(
              title: Text(
                  s == 'pregnant' ? 'Mẹ bầu' : s == 'postpartum' ? 'Mẹ sau sinh' : 'Đã có bé'),
              value: s,
              groupValue: stage,
              onChanged: (v) => setState(() => stage = v),
            ),
          const SizedBox(height: 10),
          const Text('Bạn quan tâm nhất điều gì?'),
          for (var i in ['tracking', 'doctor', 'community'])
            RadioListTile(
              title: Text(
                  i == 'tracking' ? 'Theo dõi sức khỏe' : i == 'doctor' ? 'Kết nối bác sĩ' : 'Cộng đồng hỗ trợ'),
              value: i,
              groupValue: interest,
              onChanged: (v) => setState(() => interest = v),
            ),
          if (result != null) ...[
            const Divider(),
            Text(result!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.pink)),
          ]
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
        ElevatedButton(onPressed: submitQuiz, child: const Text('Xem gợi ý')),
      ],
    );
  }
}
