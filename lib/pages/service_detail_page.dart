import 'package:flutter/material.dart';

class ServiceDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const ServiceDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh đầu trang
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------ TIÊU ĐỀ ------------------
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ------------------ MÔ TẢ NGẮN ------------------
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 28),

                  // ------------------ GIỚI THIỆU ------------------
                  _sectionTitle("📌 Giới thiệu dịch vụ"),
                  _sectionText(
                    _introFor(title),
                  ),

                  const SizedBox(height: 22),

                  // ------------------ LỢI ÍCH ------------------
                  _sectionTitle("✨ Lợi ích mang lại"),
                  _bulletList(_benefitsFor(title)),

                  const SizedBox(height: 22),

                  // ------------------ KHI NÀO CẦN ------------------
                  _sectionTitle("🩺 Khi nào bạn nên sử dụng dịch vụ này?"),
                  _bulletList(_whenToUse(title)),

                  const SizedBox(height: 22),

                  // ------------------ QUY TRÌNH ------------------
                  _sectionTitle("⚙️ Quy trình thực hiện"),
                  _numberList(_processFor(title)),

                  const SizedBox(height: 22),

                  // ------------------ LƯU Ý ------------------
                  _sectionTitle("⚠️ Lưu ý quan trọng"),
                  _bulletList(_notesFor(title)),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // =============== 🎯 PHẦN DỮ LIỆU TỰ ĐỘNG THEO DỊCH VỤ ===========
  // ================================================================

  String _introFor(String name) {
    switch (name) {
      case "Khám thai định kỳ":
        return "Khám thai định kỳ là dịch vụ quan trọng giúp theo dõi sự phát triển của thai nhi và sức khỏe của mẹ trong suốt thai kỳ.";

      case "Tư vấn dinh dưỡng":
        return "Tư vấn dinh dưỡng giúp xây dựng chế độ ăn khoa học, phù hợp từng giai đoạn phát triển của mẹ và bé.";

      case "Theo dõi phát triển trẻ":
        return "Dịch vụ theo dõi tăng trưởng giúp đánh giá chiều cao, cân nặng, BMI và các mốc phát triển quan trọng của trẻ theo chuẩn WHO.";

      case "Tiêm chủng mở rộng":
        return "Dịch vụ tiêm chủng đảm bảo trẻ được tiêm các loại vắc-xin quan trọng, giúp phòng ngừa bệnh tật hiệu quả.";

      case "Siêu âm thai 4D":
        return "Siêu âm 4D sử dụng công nghệ hiện đại giúp quan sát hình ảnh thai nhi sắc nét, chân thật hơn các phương pháp truyền thống.";

      case "Tư vấn sau sinh":
        return "Dịch vụ hỗ trợ mẹ sau sinh về sức khỏe thể chất, tinh thần, dinh dưỡng và chăm sóc trẻ sơ sinh.";
    }
    return description;
  }

  List<String> _benefitsFor(String name) {
    switch (name) {
      case "Khám thai định kỳ":
        return [
          "Theo dõi sự phát triển của thai nhi",
          "Phát hiện sớm các bất thường",
          "Tư vấn chế độ ăn uống và sinh hoạt",
          "Siêu âm, đo tim thai theo từng mốc"
        ];

      case "Tư vấn dinh dưỡng":
        return [
          "Xây dựng chế độ ăn khoa học",
          "Cải thiện sức khỏe mẹ và bé",
          "Giảm nguy cơ thiếu chất hoặc thừa cân",
          "Tư vấn theo từng giai đoạn phát triển"
        ];

      case "Theo dõi phát triển trẻ":
        return [
          "Đánh giá chiều cao, cân nặng theo chuẩn WHO",
          "Theo dõi BMI và chỉ số dinh dưỡng",
          "Hỗ trợ phát hiện sớm suy dinh dưỡng",
          "Đưa ra các khuyến nghị cải thiện"
        ];

      case "Tiêm chủng mở rộng":
        return [
          "Ngăn ngừa nhiều bệnh truyền nhiễm nguy hiểm",
          "Bảo vệ sức khỏe trẻ lâu dài",
          "Theo dõi phản ứng sau tiêm",
          "Nhắc lịch và lưu hồ sơ tiêm chủng"
        ];

      case "Siêu âm thai 4D":
        return [
          "Hình ảnh thai nhi sắc nét, chân thực",
          "Hỗ trợ bác sĩ phát hiện sớm bất thường",
          "Ghi lại khoảnh khắc đáng nhớ của bé",
          "Đánh giá hoạt động và chuyển động của thai"
        ];

      case "Tư vấn sau sinh":
        return [
          "Chăm sóc sức khỏe mẹ sau sinh",
          "Hỗ trợ tâm lý, phòng trầm cảm",
          "Tư vấn nuôi con bằng sữa mẹ",
          "Đưa ra chế độ dinh dưỡng phục hồi"
        ];

      default:
        return [];
    }
  }

  List<String> _whenToUse(String name) {
    switch (name) {
      case "Khám thai định kỳ":
        return [
          "Mẹ bầu trong suốt thai kỳ",
          "Có dấu hiệu đau bụng bất thường",
          "Muốn kiểm tra sự phát triển của bé"
        ];

      case "Tư vấn dinh dưỡng":
        return [
          "Mẹ bầu thiếu cân hoặc thừa cân",
          "Bé chậm tăng trưởng",
          "Cần chế độ ăn cho bé theo từng tháng tuổi"
        ];

      case "Theo dõi phát triển trẻ":
        return [
          "Trẻ từ 0–5 tuổi",
          "Bé chậm tăng cân hoặc thấp còi",
          "Theo dõi định kỳ theo chuẩn WHO"
        ];

      case "Tiêm chủng mở rộng":
        return [
          "Trẻ đúng độ tuổi tiêm chủng",
          "Cần nhắc lịch và theo dõi",
          "Gia đình muốn tiêm đầy đủ để phòng bệnh"
        ];

      case "Siêu âm thai 4D":
        return [
          "Mẹ muốn xem hình ảnh rõ nét của thai",
          "Bác sĩ yêu cầu kiểm tra chuyên sâu",
          "Mẹ ở tuần 22–32 thai kỳ"
        ];

      case "Tư vấn sau sinh":
        return [
          "Mẹ sau sinh cần chăm sóc sức khỏe",
          "Bé bú kém hoặc khó ngủ",
          "Cần hỗ trợ tâm lý và dinh dưỡng"
        ];

      default:
        return [];
    }
  }

  List<String> _processFor(String name) {
    switch (name) {
      case "Khám thai định kỳ":
        return [
          "Tiếp nhận hồ sơ và đo huyết áp",
          "Siêu âm và kiểm tra tim thai",
          "Đánh giá sức khỏe của mẹ",
          "Tư vấn và hẹn lịch khám tiếp theo"
        ];

      case "Tư vấn dinh dưỡng":
        return [
          "Đánh giá hiện trạng dinh dưỡng",
          "Xác định nhu cầu theo từng giai đoạn",
          "Xây dựng thực đơn chi tiết",
          "Theo dõi tiến triển và điều chỉnh"
        ];

      case "Theo dõi phát triển trẻ":
        return [
          "Đo chiều cao, cân nặng",
          "So sánh theo biểu đồ WHO",
          "Đánh giá dinh dưỡng",
          "Đề xuất giải pháp hỗ trợ"
        ];

      case "Tiêm chủng mở rộng":
        return [
          "Kiểm tra tổng quát trước tiêm",
          "Tiêm vắc-xin an toàn",
          "Theo dõi phản ứng sau tiêm",
          "Ghi nhận lịch sử và nhắc lịch"
        ];

      case "Siêu âm thai 4D":
        return [
          "Chuẩn bị và kiểm tra ban đầu",
          "Siêu âm bằng thiết bị công nghệ cao",
          "Quan sát các góc độ của thai nhi",
          "Phân tích kết quả và in hình"
        ];

      case "Tư vấn sau sinh":
        return [
          "Đánh giá sức khỏe mẹ sau sinh",
          "Tư vấn dinh dưỡng",
          "Hỗ trợ tâm lý",
          "Hướng dẫn chăm sóc bé"
        ];

      default:
        return [];
    }
  }

  List<String> _notesFor(String name) {
    return [
      "Thông tin mang tính tham khảo, không thay thế tư vấn bác sĩ.",
      "Nên mang theo hồ sơ y tế nếu có.",
      "Nếu có dấu hiệu bất thường, nên đi khám ngay.",
    ];
  }

  // ================================================================
  // =============== 🎯 CÁC WIDGET HIỂN THỊ =========================
  // ================================================================

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.pinkAccent,
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, height: 1.4),
      textAlign: TextAlign.justify,
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 18)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _numberList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((e) {
        int index = e.key + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$index. ",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  e.value,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
