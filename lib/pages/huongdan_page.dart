import 'package:flutter/material.dart';

class HuongDanPage extends StatefulWidget {
  const HuongDanPage({super.key});

  @override
  State<HuongDanPage> createState() => _HuongDanPageState();
}

class _HuongDanPageState extends State<HuongDanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color primaryColor = const Color(0xFF5B9BD5);
  final Color textLight = const Color(0xFF4A5568);
  final Color lightBg = const Color(0xFFF7FAFC);
  final Color white = Colors.white;

  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentTab = _tabController.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text('Hướng dẫn sử dụng'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          Column(
            children: [
              const Text(
                "Hướng dẫn sử dụng",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent),
              ),
              const SizedBox(height: 8),
              Text(
                "Tìm hiểu cách sử dụng hệ thống quản lý sức khỏe mẹ và bé hiệu quả",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: textLight),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Tabs chính
          Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9F3FF),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: primaryColor,
                    labelColor: primaryColor,
                    unselectedLabelColor: textLight,
                    tabs: const [
                      Tab(icon: Icon(Icons.favorite), text: "Bắt đầu"),
                      Tab(icon: Icon(Icons.pregnant_woman), text: "Thai kỳ"),
                      Tab(icon: Icon(Icons.vaccines), text: "Tiêm chủng"),
                      Tab(icon: Icon(Icons.bar_chart), text: "Báo cáo"),
                      Tab(icon: Icon(Icons.support_agent), text: "Tư vấn"),
                    ],
                  ),
                ),

                // Nội dung có hiệu ứng fade + slide
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> anim) {
                    final offsetAnim = Tween<Offset>(
                        begin: const Offset(0.2, 0), end: Offset.zero)
                        .animate(anim);
                    return SlideTransition(
                      position: offsetAnim,
                      child: FadeTransition(opacity: anim, child: child),
                    );
                  },
                  child: SizedBox(
                    key: ValueKey<int>(_currentTab),
                    height: 600,
                    child: _getTabView(_currentTab),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // FAQ
          _buildFAQ(),
        ],
      ),
    );
  }

  /// Tách riêng nội dung tab theo index
  Widget _getTabView(int index) {
    switch (index) {
      case 0:
        return _buildTabContent(
          title: "Bắt đầu với Mẹ & Bé",
          description:
          "Chào mừng bạn đến với hệ thống quản lý sức khỏe Mẹ & Bé! Làm theo các bước sau:",
          steps: const [
            ["Đăng ký tài khoản", "Tạo tài khoản cá nhân và điền thông tin cá nhân."],
            ["Hoàn thiện hồ sơ", "Cập nhật thông tin sức khỏe của bạn và bé."],
            ["Khám phá tính năng", "Tìm hiểu các công cụ theo dõi và hỗ trợ sức khỏe."]
          ],
          buttonText: "Xem video hướng dẫn",
          color: Colors.pinkAccent,
        );
      case 1:
        return _buildTabContent(
          title: "Theo dõi thai kỳ",
          description:
          "Theo dõi sự phát triển của thai nhi và sức khỏe mẹ từng tuần:",
          steps: const [
            ["Nhập ngày dự sinh", "Hệ thống tự động tính toán tuổi thai."],
            ["Ghi chỉ số sức khỏe", "Lưu cân nặng, huyết áp, và các chỉ số định kỳ."],
            ["Nhận thông tin mỗi tuần", "Cập nhật thông tin phát triển thai nhi."]
          ],
          buttonText: "Xem lịch thai kỳ",
          color: Colors.pinkAccent,
        );
      case 2:
        return _buildTabContent(
          title: "Lịch tiêm chủng",
          description: "Theo dõi và ghi nhận lịch tiêm của bé dễ dàng:",
          steps: const [
            ["Xem lịch chuẩn", "Theo khuyến cáo của Bộ Y tế."],
            ["Nhắc lịch tự động", "Nhận thông báo trước ngày tiêm."],
            ["Lưu thông tin tiêm", "Ghi lại mũi đã tiêm và phản ứng."]
          ],
          buttonText: "Xem lịch tiêm mẫu",
          color: Colors.pinkAccent,
        );
      case 3:
        return _buildTabContent(
          title: "Báo cáo sức khỏe",
          description:
          "Tổng hợp, phân tích và chia sẻ dữ liệu sức khỏe mẹ và bé:",
          steps: const [
            ["Biểu đồ phát triển", "Theo dõi cân nặng, chiều cao, chu vi đầu."],
            ["Nhật ký sức khỏe", "Ghi lại triệu chứng và chế độ ăn."],
            ["Chia sẻ với bác sĩ", "Xuất báo cáo PDF hoặc gửi trực tiếp."]
          ],
          buttonText: "Xem báo cáo mẫu",
          color: Colors.pinkAccent,
        );
      default:
        return _buildTabContent(
          title: "Tư vấn y tế",
          description:
          "Kết nối trực tiếp với chuyên gia để nhận hỗ trợ chuyên môn:",
          steps: const [
            ["Tìm chuyên gia", "Chọn chuyên ngành và kinh nghiệm phù hợp."],
            ["Đặt lịch tư vấn", "Tư vấn trực tuyến hoặc tại phòng khám."],
            ["Chat / Video call", "Gặp chuyên gia dễ dàng qua hệ thống."]
          ],
          buttonText: "Tìm chuyên gia ngay",
          color: Colors.pinkAccent,
        );
    }
  }

  Widget _buildTabContent({
    required String title,
    required String description,
    required List<List<String>> steps,
    required String buttonText,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 15),
          Column(
            children: List.generate(steps.length, (i) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: color,
                  child: Text("${i + 1}",
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text(steps[i][0],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(steps[i][1]),
              );
            }),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "Câu hỏi thường gặp",
            style: TextStyle(
              fontSize: 24,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildFaqItem(
            "Thông tin của tôi có an toàn không?",
            "Tất cả dữ liệu được mã hóa và chỉ bạn có quyền truy cập.",
          ),
          _buildFaqItem(
            "Hệ thống có miễn phí không?",
            "Có. Bạn có thể sử dụng miễn phí với các tính năng cơ bản, hoặc nâng cấp gói Premium.",
          ),
          _buildFaqItem(
            "Làm sao để kết nối với bác sĩ?",
            "Bạn có thể đặt lịch tư vấn trực tuyến hoặc tại phòng khám trong phần Tư vấn y tế.",
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(answer, style: const TextStyle(color: Colors.black54)),
        )
      ],
    );
  }
}
