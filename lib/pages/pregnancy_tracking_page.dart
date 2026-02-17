import 'package:flutter/material.dart';

// ================== TRANG THEO DÕI THAI KỲ ==================
class PregnancyTrackingPage extends StatefulWidget {
  const PregnancyTrackingPage({super.key});

  @override
  State<PregnancyTrackingPage> createState() => _PregnancyTrackingPageState();
}

class _PregnancyTrackingPageState extends State<PregnancyTrackingPage> {
  final TextEditingController _weekController = TextEditingController();
  int? week;
  Map<String, String>? info;
  String? error;

  // ======= ẢNH 40 TUẦN — CHÈN LINK ẢNH CỦA BẠN TẠI ĐÂY =======
  final Map<int, String> weekImages = {
    for (var i = 1; i <= 40; i++) i: 'assets/images/pregnancy/week$i.jpg',
  };
  // ======= THÔNG TIN PHÁT TRIỂN CHI TIẾT 40 TUẦN =======
  final Map<int, Map<String, String>> pregnancyData = {
    1: {
      'Size': '0.1 mm',
      'Weight': '<0.01 g',
      'Milestone': 'Trứng được thụ tinh và bắt đầu phân chia thành phôi.',
      'Advice': 'Bắt đầu bổ sung axit folic 400 mcg mỗi ngày.',
      'Image' : 'assets/images/pregnancy/week1.jpg'
    },
    2: {
      'Size': '0.2 mm',
      'Weight': '<0.01 g',
      'Milestone': 'Phôi thai di chuyển vào tử cung để làm tổ.',
      'Advice': 'Tránh rượu bia, thuốc lá và các chất độc hại.',
      'Image' : 'assets/images/pregnancy/week2.jpg'
    },
    3: {
      'Size': '1 mm',
      'Weight': '0.01 g',
      'Milestone': 'Phôi thai phát triển thành một cụm tế bào nhỏ.',
      'Advice': 'Uống nhiều nước và duy trì chế độ ăn uống lành mạnh.',
      'Image' : 'assets/images/pregnancy/week3.jpg'
    },
    4: {
      'Size': '3 mm',
      'Weight': '0.1 g',
      'Milestone': 'Hình thành túi ối và nhau thai bắt đầu phát triển.',
      'Advice': 'Đi khám thai để xác nhận thai đã làm tổ.',
      'Image' : 'assets/images/pregnancy/week4.jpg'
    },
    5: {
      'Size': '5 mm',
      'Weight': '0.2 g',
      'Milestone': 'Tim thai bắt đầu hình thành và đập nhẹ.',
      'Advice': 'Bổ sung vitamin tổng hợp cho bà bầu.',
      'Image' : 'assets/images/pregnancy/week5.jpg'
    },
    6: {
      'Size': '8 mm',
      'Weight': '0.5 g',
      'Milestone': 'Hệ thần kinh sơ khai bắt đầu hình thành.',
      'Advice': 'Tránh căng thẳng và nghỉ ngơi đầy đủ.',
      'Image' : 'assets/images/pregnancy/week6.jpg'
    },
    7: {
      'Size': '12 mm',
      'Weight': '0.8 g',
      'Milestone': 'Hình thành các chồi chi (tay, chân) và khuôn mặt sơ khai.',
      'Advice': 'Bắt đầu tập các bài tập thở để thư giãn.',
      'Image' : 'assets/images/pregnancy/week7.jpg'
    },
    8: {
      'Size': '15 mm',
      'Weight': '1 g',
      'Milestone': 'Tim thai đập mạnh hơn, các cơ quan nội tạng hình thành.',
      'Advice': 'Khám thai lần đầu để nghe tim thai.',
      'Image' : 'assets/images/pregnancy/week8.jpg'
    },
    9: {
      'Size': '20 mm',
      'Weight': '2 g',
      'Milestone': 'Thai nhi có hình dạng giống người với đầu và thân rõ ràng.',
      'Advice': 'Bổ sung thực phẩm giàu sắt như thịt đỏ và rau xanh.',
      'Image' : 'assets/images/pregnancy/week9.jpg'
    },
    10: {
      'Size': '25 mm',
      'Weight': '4 g',
      'Milestone': 'Ngón tay, ngón chân bắt đầu tách ra từ chồi chi.',
      'Advice': 'Uống đủ nước để hỗ trợ tuần hoàn máu.',
      'Image' : 'assets/images/pregnancy/week10.jpg'
    },
    11: {
      'Size': '35 mm',
      'Weight': '8 g',
      'Milestone': 'Thai nhi phát triển móng tay và lông mịn trên cơ thể.',
      'Advice': 'Đi bộ nhẹ nhàng để cải thiện sức khỏe.',
      'Image' : 'assets/images/pregnancy/week11.jpg'
    },
    12: {
      'Size': '5.4 cm',
      'Weight': '14 g',
      'Milestone': 'Thai nhi bắt đầu cử động nhẹ, cơ quan sinh dục hình thành.',
      'Advice': 'Khám thai để kiểm tra dị tật bẩm sinh.',
      'Image' : 'assets/images/pregnancy/week12.jpg'
    },
    13: {
      'Size': '7 cm',
      'Weight': '23 g',
      'Milestone': 'Xương bắt đầu cứng lại, thai nhi có phản xạ đầu tiên.',
      'Advice': 'Bổ sung canxi qua sữa hoặc thực phẩm chức năng.',
      'Image' : 'assets/images/pregnancy/week13.jpg'
    },
    14: {
      'Size': '8.7 cm',
      'Weight': '43 g',
      'Milestone': 'Thai nhi phát triển lông mày và tóc mịn trên đầu.',
      'Advice': 'Ăn thực phẩm giàu protein để hỗ trợ tăng trưởng.',
      'Image' : 'assets/images/pregnancy/week14.jpg'
    },
    15: {
      'Size': '10 cm',
      'Weight': '70 g',
      'Milestone': 'Thai nhi có thể co duỗi tay chân, mí mắt hình thành.',
      'Advice': 'Nghỉ ngơi nhiều hơn nếu cảm thấy mệt mỏi.',
      'Image' : 'assets/images/pregnancy/week15.jpg'
    },
    16: {
      'Size': '11.6 cm',
      'Weight': '100 g',
      'Milestone': 'Thai nhi nghe được âm thanh từ bên ngoài.',
      'Advice': 'Bắt đầu nói chuyện với thai nhi để tạo kết nối.',
      'Image' : 'assets/images/pregnancy/week16.jpg'
    },
    17: {
      'Size': '13 cm',
      'Weight': '140 g',
      'Milestone': 'Lớp mỡ dưới da bắt đầu hình thành để giữ nhiệt.',
      'Advice': 'Bổ sung thực phẩm giàu omega-3 như cá hồi.',
      'Image' : 'assets/images/pregnancy/week17.jpg'
    },
    18: {
      'Size': '14.2 cm',
      'Weight': '190 g',
      'Milestone': 'Thai nhi phát triển giác mạc và có thể cảm nhận ánh sáng.',
      'Advice': 'Tránh đứng hoặc ngồi quá lâu để giảm áp lực.',
      'Image' : 'assets/images/pregnancy/week18.jpg'
    },
    19: {
      'Size': '15.3 cm',
      'Weight': '240 g',
      'Milestone': 'Hệ tiêu hóa bắt đầu hoạt động, thai nhi nuốt nước ối.',
      'Advice': 'Ăn nhiều chất xơ để tránh táo bón.',
      'Image' : 'assets/images/pregnancy/week19.jpg'
    },
    20: {
      'Size': '16.4 cm',
      'Weight': '300 g',
      'Milestone': 'Thai nhi phát triển lớp lông tơ và lớp sáp bảo vệ da.',
      'Advice': 'Tập yoga bầu để cải thiện sự linh hoạt.',
      'Image' : 'assets/images/pregnancy/week20.jpg'
    },
    21: {
      'Size': '18 cm',
      'Weight': '360 g',
      'Milestone': 'Thai nhi có phản xạ nuốt và tiêu hóa đầu tiên.',
      'Advice': 'Uống nhiều nước để hỗ trợ hệ tiêu hóa của mẹ.',
      'Image' : 'assets/images/pregnancy/week21.jpg'
    },
    22: {
      'Size': '19 cm',
      'Weight': '430 g',
      'Milestone': 'Hệ miễn dịch của thai nhi bắt đầu phát triển.',
      'Advice': 'Bổ sung vitamin C qua trái cây như cam, chanh.',
      'Image' : 'assets/images/pregnancy/week22.jpg'
    },
    23: {
      'Size': '20 cm',
      'Weight': '500 g',
      'Milestone': 'Thai nhi có thể nghe giọng nói của mẹ và người thân.',
      'Advice': 'Hát hoặc kể chuyện cho thai nhi nghe.',
      'Image' : 'assets/images/pregnancy/week23.jpg'
    },
    24: {
      'Size': '30 cm',
      'Weight': '600 g',
      'Milestone': 'Phổi bắt đầu phát triển, thai nhi tập thở nước ối.',
      'Advice': 'Kiểm tra đường huyết để phát hiện tiểu đường thai kỳ.',
      'Image' : 'assets/images/pregnancy/week24.jpg'
    },
    25: {
      'Size': '31 cm',
      'Weight': '700 g',
      'Milestone': 'Thai nhi tích lũy mỡ để điều chỉnh nhiệt độ cơ thể.',
      'Advice': 'Ăn thực phẩm giàu năng lượng như hạt óc chó.',
      'Image' : 'assets/images/pregnancy/week25.jpg'
    },
    26: {
      'Size': '32 cm',
      'Weight': '800 g',
      'Milestone': 'Mí mắt mở ra, thai nhi phản ứng với ánh sáng.',
      'Advice': 'Theo dõi cân nặng của mẹ để đảm bảo tăng cân hợp lý.',
      'Image' : 'assets/images/pregnancy/week26.jpg'
    },
    27: {
      'Size': '34 cm',
      'Weight': '900 g',
      'Milestone': 'Hệ thần kinh trung ương phát triển mạnh mẽ.',
      'Advice': 'Tránh căng thẳng, dành thời gian thư giãn.',
      'Image' : 'assets/images/pregnancy/week27.jpg'
    },
    28: {
      'Size': '37.6 cm',
      'Weight': '1 kg',
      'Milestone': 'Thai nhi có thể nhận biết ánh sáng qua bụng mẹ.',
      'Advice': 'Tham gia lớp học tiền sản để chuẩn bị sinh.',
      'Image' : 'assets/images/pregnancy/week28.jpg'
    },
    29: {
      'Size': '38 cm',
      'Weight': '1.2 kg',
      'Milestone': 'Phổi phát triển nhanh, chuẩn bị cho việc thở.',
      'Advice': 'Theo dõi chuyển động thai nhi, ít nhất 10 lần/ngày.',
      'Image' : 'assets/images/pregnancy/week29.jpg'
    },
    30: {
      'Size': '39 cm',
      'Weight': '1.4 kg',
      'Milestone': 'Thai nhi tăng cân nhanh để chuẩn bị sinh.',
      'Advice': 'Chuẩn bị tâm lý và kế hoạch sinh nở.',
      'Image' : 'assets/images/pregnancy/week30.jpg'
    },
    31: {
      'Size': '41 cm',
      'Weight': '1.6 kg',
      'Milestone': 'Hệ tiêu hóa hoàn thiện, sẵn sàng tiêu hóa sữa.',
      'Advice': 'Ăn các bữa nhỏ để tránh khó tiêu.',
      'Image' : 'assets/images/pregnancy/week31.jpg'
    },
    32: {
      'Size': '43.7 cm',
      'Weight': '1.8 kg',
      'Milestone': 'Xương thai nhi cứng cáp, trừ xương sọ để dễ sinh.',
      'Advice': 'Theo dõi dấu hiệu co bóp tử cung.',
      'Image' : 'assets/images/pregnancy/week32.jpg'
    },
    33: {
      'Size': '44 cm',
      'Weight': '2 kg',
      'Milestone': 'Thai nhi tích lũy mỡ để giữ ấm sau khi sinh.',
      'Advice': 'Nghỉ ngơi nhiều hơn, tránh làm việc nặng.',
      'Image' : 'assets/images/pregnancy/week33.jpg'
    },
    34: {
      'Size': '45 cm',
      'Weight': '2.2 kg',
      'Milestone': 'Lớp sáp bảo vệ da (vernix) dày lên để bảo vệ.',
      'Advice': 'Kiểm tra sức khỏe định kỳ trước sinh.',
      'Image' : 'assets/images/pregnancy/week34.jpg'
    },
    35: {
      'Size': '46 cm',
      'Weight': '2.4 kg',
      'Milestone': 'Thai nhi quay đầu xuống dưới để chuẩn bị sinh.',
      'Advice': 'Chuẩn bị túi đồ đi sinh với đầy đủ vật dụng.',
      'Image' : 'assets/images/pregnancy/week35.jpg'
    },
    36: {
      'Size': '47.4 cm',
      'Weight': '2.6 kg',
      'Milestone': 'Hệ miễn dịch của thai nhi hoàn thiện hơn.',
      'Advice': 'Nghỉ ngơi và tránh đi xa trong giai đoạn này.',
      'Image' : 'assets/images/pregnancy/week36.jpg'
    },
    37: {
      'Size': '48 cm',
      'Weight': '2.8 kg',
      'Milestone': 'Thai nhi tiếp tục tăng cân, phổi gần hoàn thiện.',
      'Advice': 'Theo dõi dấu hiệu chuyển dạ như đau bụng, ra nước ối.',
      'Image' : 'assets/images/pregnancy/week37.jpg'
    },
    38: {
      'Size': '49 cm',
      'Weight': '3 kg',
      'Milestone': 'Thai nhi phát triển hoàn thiện, sẵn sàng chào đời.',
      'Advice': 'Thư giãn, tập thở để chuẩn bị sinh.',
      'Image' : 'assets/images/pregnancy/week38.jpg'
    },
    39: {
      'Size': '50 cm',
      'Weight': '3.2 kg',
      'Milestone': 'Thai nhi có thể nặng hơn tùy theo di truyền.',
      'Advice': 'Giữ tinh thần thoải mái, chờ ngày sinh.',
      'Image' : 'assets/images/pregnancy/week39.jpg'
    },
    40: {
      'Size': '51.2 cm',
      'Weight': '3.5 kg',
      'Milestone': 'Thai nhi sẵn sàng chào đời, đầy đủ chức năng.',
      'Advice': 'Liên hệ bác sĩ ngay nếu có dấu hiệu chuyển dạ.',
      'Image' : 'assets/images/pregnancy/week40.jpg'
    },
  };

  void _showInfo() {
    setState(() {
      error = null;
      final int? enteredWeek = int.tryParse(_weekController.text);
      if (enteredWeek == null || enteredWeek < 1 || enteredWeek > 40) {
        error = 'Vui lòng nhập tuần thai hợp lệ (1–40).';
        info = null;
      } else {
        week = enteredWeek;
        info = pregnancyData[week] ??
            pregnancyData.entries
                .where((e) => e.key < week!)
                .last
                .value; // fallback theo tuần gần nhất
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theo dõi thai kỳ 🤰"),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Theo dõi sự phát triển của thai nhi theo từng tuần, nhận thông tin và lời khuyên phù hợp.",
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 20),

            if (error != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(error!, style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 15),

            TextField(
              controller: _weekController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tuần thai kỳ",
                hintText: "Nhập tuần thai kỳ (1–40)",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            Center(
              child: ElevatedButton(
                onPressed: _showInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Xem thông tin"),
              ),
            ),
            const SizedBox(height: 20),

            if (info != null && week != null)
              Card(
                color: Colors.pink[50],
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📅 Tuần: $week",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("📏 Kích thước: ${info!['Size']}"),
                      Text("⚖️ Cân nặng: ${info!['Weight']}"),
                      const SizedBox(height: 10),
                      Text("🌼 Cột mốc phát triển:",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(info!['Milestone'] ?? ''),
                      const SizedBox(height: 10),
                      Text("💡 Lời khuyên:",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(info!['Advice'] ?? ''),
                      if (weekImages[week] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              weekImages[week]!,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 25),

            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.home),
                    label: const Text('🏠 Quay về Trang chủ'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.pinkAccent),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  if (week != null && week! > 0)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.restaurant_menu),
                      label: const Text('🥗 Xem chế độ dinh dưỡng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NutritionPage(week: week!),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================== TRANG DINH DƯỠNG ==========================
class NutritionPage extends StatelessWidget {
  final int week;
  const NutritionPage({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    // ---- MỖI TUẦN 1 THỰC ĐƠN 7 NGÀY ----
    final Map<int, Map<String, Map<String, String>>> weeklyMenus = {
      1: {
        "Thứ 2": {
          "Meal": "Ăn nhiều rau xanh (cải bó xôi), bổ sung axit folic 400 mcg.",
          "Image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800"
        },
        "Thứ 3": {
          "Meal": "Tránh thức ăn chiên, ăn thịt bò nạc để bổ sung sắt.",
          "Image": "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=800"
        },
        "Thứ 4": {
          "Meal": "Ăn cam, kiwi để bổ sung vitamin C, tăng sức đề kháng.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?auto=format&fit=crop&w=800"
        },
        "Thứ 5": {
          "Meal": "Ăn cá hồi nướng giàu omega-3, tránh cá sống.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=800"
        },
        "Thứ 6": {
          "Meal": "Uống 2-2.5L nước, ngủ đủ 8 tiếng để giảm mệt mỏi.",
          "Image": "https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800"
        },
        "Thứ 7": {
          "Meal": "Nghỉ ngơi, thiền 10 phút, tránh vận động mạnh.",
          "Image": "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?auto=format&fit=crop&w=800"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa ít béo hoặc hạt chia.",
          "Image": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800"
        }
      },
      2: {
        "Thứ 2": {
          "Meal": "Ăn sáng đúng giờ với ngũ cốc nguyên hạt và sữa.",
          "Image": "https://cdn.tgdd.vn/Files/2019/12/24/1228238/cach-an-ngu-coc-voi-sua-tuoi-cho-bua-sang-day-nang-luong-201912241458385545.jpg"
        },
        "Thứ 3": {
          "Meal": "Ăn cơm gạo lứt, rau cải xanh để bổ sung chất xơ.",
          "Image": "https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38?auto=format&fit=crop&w=800"
        },
        "Thứ 4": {
          "Meal": "Bổ sung thịt gà luộc, cá mòi, tránh đồ tái sống.",
          "Image": "https://cdn.nhathuoclongchau.com.vn/v1/static/8_thuc_pham_khong_nen_ket_hop_voi_thit_ga_nhat_dinh_phai_nho_4_35bfade781.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh nước ngọt, cà phê, uống trà thảo mộc nhẹ.",
          "Image": "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=800"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép cam, ăn sữa chua không đường.",
          "Image": "https://cdn.tgdd.vn/Files/2020/02/20/1237565/nuoc-cam-va-sua-deu-rat-tot-nhung-co-nen-ket-hop-voi-nhau-202002201026221636.jpg"
        },
        "Thứ 7": {
          "Meal": "Đi bộ nhẹ 15 phút, hít thở sâu để thư giãn.",
          "Image": "https://images.unsplash.com/photo-1506126279646-a697353d3166?auto=format&fit=crop&w=800"
        },
        "Chủ Nhật": {
          "Meal": "Ngủ trưa 30 phút, tránh căng thẳng tinh thần.",
          "Image": "https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800"
        },
      },
      3: {
        "Thứ 2": {
          "Meal": "Ăn trứng luộc, đậu lăng để bổ sung protein và axit folic.",
          "Image": "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?auto=format&fit=crop&w=800"
          // Trứng luộc + đậu lăng, protein & folic
        },
        "Thứ 3": {
          "Meal": "Bổ sung chất xơ qua bông cải xanh, tránh táo bón.",
          "Image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800"
          // Bông cải xanh tươi, xanh mướt
        },
        "Thứ 4": {
          "Meal": "Uống nước ép táo, ăn hạt óc chó giàu omega-3",
          "Image": "https://bizweb.dktcdn.net/100/011/344/files/omega-3-co-trong-thuc-pham-nao-gymstore-1.jpg?v=1665137048234"
          // Nước ép táo + hạt óc chó
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, bổ sung kẽm qua hạt bí, thịt nạc.",
          "Image": "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800"
          // Thịt nạc + hạt bí (zinc)
        },
        "Thứ 6": {
          "Meal": "Ăn rau củ hấp, nghỉ ngơi nhiều để giảm mệt.",
          "Image": "https://cdn.tiemchunglongchau.com.vn/an_gi_giam_stress_goi_y_thuc_pham_giup_tinh_than_nhe_nhang_hon_1_7465ca4ba6.jpg"
          // Rau củ hấp, nhẹ nhàng, thư giãn
        },
        "Thứ 7": {
          "Meal": "Thực hành bài tập thở 5-10 phút cho bà bầu.",
          "Image": "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?auto=format&fit=crop&w=800"
          // Thở sâu, thiền cho bà bầu
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua ánh nắng sáng hoặc cá béo.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=800"
          // Cá hồi – giàu vitamin D & omega-3
        },
      },
      4: {
        "Thứ 2": {
          "Meal": "Ăn bơ nghiền với bánh mì nguyên cám – giàu axit folic & protein thực vật.",
          "Image": "https://saigonesebaguette.vn/wp-content/uploads/2025/09/banh-mi-nguyen-cam-cho-bua-an-giam-can.jpg"
          // Bơ + bánh mì nguyên cám – axit folic, protein
        },
        "Thứ 3": {
          "Meal": "Uống trà gừng ấm (loại nhẹ) để giảm buồn nôn, tránh đồ chiên rán.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/thumb_w/640/324455921873985536/2023/5/5/buon-non-2-1683278998099984485145.jpg"
          // Trà gừng ấm – chống ốm nghén
        },
        "Thứ 4": {
          "Meal": "Ăn dâu tây tươi hoặc ổi – bổ sung vitamin C, tăng sức đề kháng.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/3/17/dau-tay-2-1710669683602683344326.jpg"
          // Dâu tây + ổi – vitamin C
        },
        "Thứ 5": {
          "Meal": "Bổ sung sắt từ gan bò nấu chín (ít), rau cải bó xôi hấp.",
          "Image": "https://cdn.tgdd.vn/2020/10/CookProduct/a-1200x676.jpg"
          // Gan bò + cải bó xôi – nguồn sắt tự nhiên
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ: bánh quy yến mạch + trà hoa cúc – giảm ốm nghén, dễ tiêu.",
          "Image": "https://maisonbox.vn/wp-content/uploads/2025/10/oat-cookies-tet.webp"
          // Bánh quy + trà hoa cúc – nhẹ bụng
        },
        "Thứ 7": {
          "Meal": "Đi bộ nhẹ nhàng 10–15 phút trong công viên, hít thở không khí trong lành.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/Images/nguyenkhanh/2020/08/18/Phan_1_tam_quan_trong_cua_viec_hit_tho.jpg"
          // Đi bộ bầu – tuần hoàn, thư giãn
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi: phô mai cottage + hạnh nhân rang – tốt cho xương mẹ & bé.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/7/16/photo-1721144162288-1721144162906288879350.jpeg"
          // Phô mai + hạnh nhân – canxi, magie
        }
      },
      5: {
        "Thứ 2": {
          "Meal": "Ăn sáng với yến mạch và sữa ít béo, bổ sung chất xơ.",
          "Image": "https://th.bing.com/th/id/OIP.nQsQn-Als1xbAnZlA3m4YwHaE8?w=242&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt lanh, tránh cá sống.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn chuối, khoai lang để bổ sung kali, tránh chuột rút.",
          "Image": "https://icdn.dantri.com.vn/thumb_w/960/2018/8/2/chuoi-1533144266397451177901.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ mặn, ăn rau củ hấp như bí đỏ.",
          "Image": "https://cdn.tgdd.vn/2022/09/CookDish/2-cach-lam-banh-bi-do-vua-don-gian-vua-thom-ngon-la-mieng-avt-1200x676.jpg"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với bánh quy và trà chanh, giảm ốm nghén.",
          "Image": "https://th.bing.com/th/id/OIP.Y6Lpa0wLbJFP60AdmrsRBwHaGI?w=209&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu nhẹ nhàng 10 phút, thư giãn cơ thể.",
          "Image": "https://th.bing.com/th/id/OIP.soJZPJ3aTLWCZss3eYARsgHaFN?w=280&h=197&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ nhật": {
          "Meal": "Bổ sung vitamin A qua cà rốt, bí đỏ, hỗ trợ mắt thai nhi.",
          "Image": "https://san43nguyenkhang.vn/uploads/plugin/news/14314/1712825418-367112473-vitamin-a-va-nguy-c-d-t-t-thai-nhi.jpg"
        },
      },
      6: {
        "Thứ 2": {
          "Meal": "Ăn táo tươi với đậu đen luộc – bổ sung chất xơ & protein thực vật.",
          "Image": "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=800"
        },
        "Thứ 3": {
          "Meal": "Uống nước chanh gừng ấm để giảm ốm nghén, tránh đồ nặng mùi.",
          "Image": "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=800"
        },
        "Thứ 4": {
          "Meal": "Ăn xoài chín & dứa tươi – giàu vitamin C, hỗ trợ tiêu hóa.",
          "Image": "https://cdn.eva.vn/upload/3-2022/images/2022-07-06/qua-xoai-giup-lam-dep-ngua-ung-thu-nhung-tuyet-doi-khong-ket-hop-voi-nhung-thuc-pham-nay-co-the-hong-8a3_result-1657120854-735-width640height278.jpg"
        },
        "Thứ 5": {
          "Meal": "Bổ sung sắt: thịt bò nạc nướng + rau bina (cải bó xôi) hấp.",
          "Image": "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=800"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ: bánh quy yến mạch + trà hoa cúc – dễ tiêu, thư giãn.",
          "Image": "https://bizweb.dktcdn.net/100/503/764/articles/1b61c1ec-78e5-4e16-b3da-41b495bf27a2.jpg?v=1759803892880"
        },
        "Thứ 7": {
          "Meal": "Đi bộ nhẹ 15 phút trong công viên, thực hành thiền để giảm stress.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSr9NEsIu1QicH31JxLfYa0XqR40srR1JB3Kw&s"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi: sữa chua Hy Lạp + hạt mè rang – tốt cho xương.",
          "Image": "https://media-cdn-v2.laodong.vn/storage/newsportal/2024/10/15/1408148/Canxi1.jpg?w=800&h=496&crop=auto&scale=both"
        }
      },
      7: {
        "Thứ 2": {
          "Meal": "Ăn cháo yến mạch với quả mọng, bổ sung chất xơ.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2023/3/30/cong-thuc-dau-tay-yen-mach-16801470226541947862275.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua hạt lanh, cá thu, tránh đồ chiên.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=800"
        },
        "Thứ 4": {
          "Meal": "Ăn lê, nho để bổ sung vitamin K và chất xơ.",
          "Image": "https://cdn.tgdd.vn//News/0//an-le-co-tac-dung-gi-22-cong-dung-cua-qua-le-va-21-800x450.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ăn mặn, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://shop.annam-gourmet.com/pub/media/magefan_blog/pumpkin-soup-recipe-annam-gourmet-thumbnails.jpg"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép cà rốt, ăn sữa chua tự nhiên.",
          "Image": "https://img.websosanh.vn/v10/users/review/images/wps1qfgju7tro/156221655355_5031992.jpg?compress=85"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel nhẹ để tăng cường cơ sàn chậu.",
          "Image": "https://feelex.vn/wp-content/uploads/2025/03/Bai-Tap-Kegel-Cho-Nu-La-Gi.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi hoặc ánh nắng nhẹ.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqkZQpu4mhjnzSU4v2Qr3mD4n8Zkx-6PMnsA&s"
        }
      },
      8: {
        "Thứ 2": {
          "Meal": "Ăn trứng luộc, bơ để bổ sung protein và chất béo lành mạnh.",
          "Image": "https://images.unsplash.com/photo-1525351484163-7529414344d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 3": {
          "Meal": "Uống trà hoa cúc nhẹ, tránh đồ ăn cay để giảm ốm nghén.",
          "Image": "https://th.bing.com/th/id/OIP.rYvNVXT4p5q2XjEcCe4_aAHaEo?w=283&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 4": {
          "Meal": "Ăn mận, táo để bổ sung chất xơ, tránh táo bón.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2023/3/20/bo-sung-chat-xo-1679289111473985273555.jpg"
        },
        "Thứ 5": {
          "Meal": "Bổ sung sắt qua gan heo (nấu chín), rau cải bó xôi.",
          "Image": "https://cdn.eva.vn/upload/1-2023/images/2023-03-25/canh-gan-lon-6f1978c65bc3418988261163deb868a3-1679753531-251-width780height520.jpg"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với bánh quy gừng, sữa chua không đường.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8Z4VrsPgIeFHeQ997k5dzfBi9mQi3BQ2JPw&s"
        },
        "Thứ 7": {
          "Meal": "Đi bộ 20 phút, nghe nhạc thư giãn cho thai nhi.",
          "Image": "https://th.bing.com/th/id/OIP.j1QJVKB52vXFx93AQiwwAAHaE8?w=265&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa, hạt hạnh nhân, khám thai nghe tim thai.",
          "Image": "https://th.bing.com/th/id/OIP.SW9cBg4vetGgyP9QXgkfAQHaEo?w=275&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      9: {
        "Thứ 2": {
          "Meal": "Ăn cháo gà với gừng, bổ sung protein và giảm ốm nghén.",
          "Image": "https://th.bing.com/th/id/OIP.mgFDKyeGuvMq51HlIc2DjQHaE8?w=241&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi, hạt óc chó, tránh đồ sống.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn kiwi, cam để bổ sung vitamin C, tăng đề kháng.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, ăn súp đậu lăng để bổ sung sắt.",
          "Image": "https://th.bing.com/th/id/OIP.p6GVZ0nA4puLrkAuIB5YbAHaFC?w=235&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua Hy Lạp.",
          "Image": "https://th.bing.com/th/id/OIP.N8arsu0HLZLYKcNwYmBcLwHaEo?w=268&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 15 phút, chuẩn bị tâm lý cho tam cá nguyệt 2.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSALHqOER299hY0W-i_ycbf88TyfTEgROc1lA&s"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin A qua bí đỏ, khoai lang.",
          "Image": "https://th.bing.com/th/id/OIP.tKPK7Rb4sMSwsfNT2YIndwHaFj?w=226&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      10: {
        "Thứ 2": {
          "Meal": "Ăn đậu hũ nướng, thịt nạc để bổ sung protein dồi dào.",
          "Image": "https://th.bing.com/th/id/OIP.H2mV9Xd2X-_y73U_p4o68AHaEL?w=308&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung canxi qua sữa chua, phô mai ít béo.",
          "Image": "https://th.bing.com/th/id/OIP.p_BYAepEb8B_1VO1Vrih2wHaFj?w=239&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 4": {
          "Meal": "Ăn táo, lê để bổ sung chất xơ và vitamin C.",
          "Image": "https://th.bing.com/th/id/OIP.0UvcgVa5AWrIvuzhU3opzQHaHa?w=171&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 5": {
          "Meal": "Tránh thức ăn nhanh, ăn rau cải xanh để bổ sung sắt.",
          "Image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép cà rốt, ăn nhẹ với hạt óc chó.",
          "Image": "https://th.bing.com/th/id/OIP.PRIL6jpBeTkXeJGPz8_hBgHaEy?w=245&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Đi bộ 20 phút, tránh nâng vật nặng.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/12/16/photo-1734332646209-17343326466851217133498.jpeg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin tổng hợp, chuẩn bị khám dị tật thai nhi.",
          "Image": "https://th.bing.com/th/id/OIP.rsVrZAJh7hLmpbUkp7GLxgHaE8?w=265&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      11: {
        "Thứ 2": {
          "Meal": "Ăn cháo yến mạch với chuối, bổ sung năng lượng và kali.",
          "Image": "https://prod-cdn.pharmacity.io/blog-2025/3f12941d8ad38d2de4be1c2b379a48211736644563.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt chia, tránh đồ chiên.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn nho, dâu tây để bổ sung vitamin K và chất xơ.",
          "Image": "https://th.bing.com/th/id/OIP.3WVPGHKPZFE9j3SopDnByQHaEK?w=284&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ mặn, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://th.bing.com/th/id/OIP.OB2OXsZNl_FGjkEWxKztzgHaEo?w=272&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://th.bing.com/th/id/OIP.c2qHYRgYJS502UhxTjeo_wHaEK?w=273&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel để tăng cường cơ sàn chậu.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/5/4/bai-tap-kegel-co-san-chau-1714831191418506171759.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi hoặc ánh nắng nhẹ.",
          "Image": "https://media.baoquangninh.vn/upload/image/202109/medium/1888225_f0b4685c6a3c68401a56cf3ae2475ce4.jpg"
        }
      },
      12: {"Thứ 2": {
        "Meal": "Ăn trứng luộc, bơ để bổ sung protein và chất béo lành mạnh.",
        "Image": "https://images.unsplash.com/photo-1525351484163-7529414344d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
      },
        "Thứ 3": {
          "Meal": "Uống trà hoa cúc nhẹ, tránh đồ ăn cay để dễ tiêu hóa.",
          "Image": "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn mận, táo để bổ sung chất xơ, tránh táo bón.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpgNYMcP72cskH5k-MSZ9maZ4kj_c3VzIO5Q&s"
        },
        "Thứ 5": {
          "Meal": "Bổ sung sắt qua gan heo (nấu chín), rau cải bó xôi.",
          "Image": "https://storage.googleapis.com/onelife-public/blog.onelife.vn/2021/11/cach-lam-chao-gan-heo-cai-bo-xoi-mon-an-cho-tre-260251216368.jpeg"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với bánh quy gừng, sữa chua không đường.",
          "Image": "https://th.bing.com/th/id/OIP.2jh1RWJHa5_h96SW7iUDcAHaHa?w=200&h=200&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Đi bộ 20 phút, nghe nhạc thư giãn cho thai nhi.",
          "Image": "https://th.bing.com/th/id/OIP.wCyd16G0wX9Y8L8mohyONgHaEK?w=315&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa, hạt hạnh nhân, khám dị tật thai nhi.",
          "Image": "https://th.bing.com/th/id/OIP.SW9cBg4vetGgyP9QXgkfAQHaEo?w=275&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      13: {"Thứ 2": {
        "Meal": "Ăn cháo gà với gừng, bổ sung protein và dễ tiêu hóa.",
        "Image": "https://th.bing.com/th/id/OIP.49UmiLFwO86_sL0H5ftvQwHaHa?w=160&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
      },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi, hạt óc chó, tránh đồ sống.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn kiwi, cam để bổ sung vitamin C, tăng đề kháng.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, ăn súp đậu lăng để bổ sung sắt.",
          "Image": "https://th.bing.com/th/id/OIP.FecKx-7PwO6hBQLguedKTQHaEK?w=303&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua Hy Lạp.",
          "Image": "https://th.bing.com/th/id/OIP.N8arsu0HLZLYKcNwYmBcLwHaEo?w=262&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 15 phút, chuẩn bị tâm lý cho tam cá nguyệt 2.",
          "Image": "https://th.bing.com/th/id/OIP.050EwGVrrXSbiMrd996DOwHaE8?w=274&h=183&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin A qua bí đỏ, khoai lang.",
          "Image": "https://th.bing.com/th/id/OIP.Rh87DxbrY_mbp4Ej1j-_pAHaE8?w=264&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      14: {
        "Thứ 2": {
          "Meal": "Ăn đậu hũ nướng, thịt nạc để bổ sung protein dồi dào.",
          "Image": "https://th.bing.com/th/id/OIP.S0msem8qvAit7Dy-q4oC1AHaE8?w=261&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung canxi qua sữa chua, phô mai ít béo.",
          "Image": "https://th.bing.com/th/id/OIP.eO_LCxdEqVYw-9dMhKLWVgHaFj?w=233&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 4": {
          "Meal": "Ăn táo, lê để bổ sung chất xơ và vitamin C.",
          "Image": "https://cdn.tgdd.vn/Files/2022/04/08/1424817/cach-trong-cay-la-cam-tim-tai-nha-don-gian-de-cham-soc-202204090616430511.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh thức ăn nhanh, ăn rau cải xanh để bổ sung sắt.",
          "Image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép cà rốt, ăn nhẹ với hạt óc chó.",
          "Image": "https://th.bing.com/th/id/OIP.PRIL6jpBeTkXeJGPz8_hBgHaEy?w=295&h=191&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Đi bộ 20 phút, tránh nâng vật nặng.",
          "Image": "https://th.bing.com/th/id/OIP.fHNQtEz7vsdfK7cMxNhTqwHaGK?w=203&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin tổng hợp, nghỉ ngơi đầy đủ.",
          "Image": "https://th.bing.com/th/id/OIP.EHTsVnIMNzmgkHzM6qwlQQHaE8?w=278&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      15: {
        "Thứ 2": {
          "Meal": "Ăn cháo yến mạch với chuối, bổ sung năng lượng và kali.",
          "Image": "https://th.bing.com/th/id/OIP.Nj8nJq-ENF5t17KR-WH0KQHaEu?w=290&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt chia, tránh đồ chiên.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn nho, dâu tây để bổ sung vitamin K và chất xơ.",
          "Image": "https://cdn.nhathuoclongchau.com.vn/unsafe/800x0/gia_tri_dinh_duong_cua_dau_tay_va_loi_ich_doi_voi_suc_khoe_1_a56f332781.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ mặn, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://th.bing.com/th/id/OIP.SNqbXP4G28IfrCyecCBDKQHaEL?w=290&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://th.bing.com/th/id/OIP._e_UCo1hCgVOZPk5xZ3r_gHaEo?w=233&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel để tăng cường cơ sàn chậu.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/Images/duylinh/2017/03/24/co_th_tp_Kegel_tren_mt_san_resize.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi hoặc ánh nắng nhẹ.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2023/12/23/vitamin-d-1-1703316321811316288333.jpg"
        }
      },
      16: {
        "Thứ 2": {
          "Meal": "Ăn cháo yến mạch với chuối, bổ sung năng lượng và kali.",
          "Image": "https://th.bing.com/th/id/OIP.Nj8nJq-ENF5t17KR-WH0KQHaEu?w=290&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt chia, tránh đồ chiên.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn nho, dâu tây để bổ sung vitamin K và chất xơ.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSy4drKiIMvef0rJMjXZG2-j9Q1rOcDJGpLsA&s"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ mặn, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://th.bing.com/th/id/OIP.SNqbXP4G28IfrCyecCBDKQHaEL?w=290&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://th.bing.com/th/id/OIP._e_UCo1hCgVOZPk5xZ3r_gHaEo?w=233&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel để tăng cường cơ sàn chậu.",
          "Image": "https://trungtamthuoc.com/images/news/bai-tap-kegel-cho-nu-7216.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi hoặc ánh nắng nhẹ.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOaFxb7fF04pfJrjwk5slSo2igXhS2cD2fcQ&s"
        }
      },
      17: {
        "Thứ 2": {
          "Meal": "Ăn cháo gà với gừng, bổ sung protein và dễ tiêu hóa.",
          "Image": "https://th.bing.com/th/id/OIP.mgFDKyeGuvMq51HlIc2DjQHaE8?w=257&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi, hạt óc chó, tránh đồ sống.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn kiwi, cam để bổ sung vitamin C, tăng đề kháng.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, ăn súp đậu lăng để bổ sung sắt.",
          "Image": "https://th.bing.com/th/id/OIP.FfK8K_VjyXIeC2ZG3fFBngHaE5?w=275&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua Hy Lạp.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSztI-NI4ZPTU1iH8bzzT_AZR9Sc0IZwLSU4A&s"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 15 phút, chuẩn bị tâm lý cho tam cá nguyệt 2.",
          "Image": "https://th.bing.com/th/id/OIP.050EwGVrrXSbiMrd996DOwHaE8?w=274&h=183&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin A qua bí đỏ, khoai lang.",
          "Image": "https://th.bing.com/th/id/OIP.IDfW8QdlvsXGhjd1Vl5hPQHaE9?w=232&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      18: {
        "Thứ 2": {
          "Meal": "Ăn trứng luộc, bơ để bổ sung protein và chất béo lành mạnh.",
          "Image": "https://images.unsplash.com/photo-1525351484163-7529414344d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 3": {
          "Meal": "Uống trà hoa cúc nhẹ, tránh đồ ăn cay để dễ tiêu hóa.",
          "Image": "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn mận, táo để bổ sung chất xơ, tránh táo bón.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2022/8/21/bi-tao-bon-nen-an-chat-xo1-16610876130201117841582.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh thức ăn nhanh, ăn rau cải xanh để bổ sung sắt.",
          "Image": "https://th.bing.com/th/id/OIP.7m44sGX2DB1XpFepdg1lYgHaFX?w=222&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép cà rốt, ăn nhẹ với hạt óc chó.",
          "Image": "https://th.bing.com/th/id/OIP.ekTYaPORmeJuPtL3PeKydQHaE8?w=258&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Đi bộ 20 phút, tránh nâng vật nặng.",
          "Image": "https://cdnphoto.dantri.com.vn/APT2cJhP3E-rsG6YV5n-FtthON4=/thumb_w/1020/2025/02/10/dibonhanh1-1739173979888.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin tổng hợp, nghỉ ngơi đầy đủ.",
          "Image": "https://media.bachhoathai.vn/product-images/62468ab3c032002478a0a46f/6242d7ae49115b348b123f83/5c1347dcebcd0351141acc80/thumnaillarge/vien-uong-bo-sung-vitamin-tong-hop-va-khoang-chat-multi-vitamin-and-multi-mineralsbachhoathaivn638195589053426870-428-408.webp"
        }
      },
      19: {
        "Thứ2": {
          "Meal": "Ăn trứng luộc, bơ để bổ sung protein và chất béo lành mạnh.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2025/6/7/photo-1749280022090-1749280022201396682294.jpeg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung canxi qua sữa chua, phô mai ít béo.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRG9S9aT1IDnFhJi-kMxuMEvKLBvzPzWA9UOA&s"
        },
        "Thứ 4": {
          "Meal": "Ăn táo, lê để bổ sung chất xơ và vitamin C.",
          "Image": "https://sagogifts.vn/wp-content/uploads/trai-cay-nhieu-chat-xo-it-duong-SagoGifts.jpg"
        },
        "Thứ 5": {
          "Meal": "Bổ sung sắt qua gan heo (nấu chín), rau cải bó xôi.",
          "Image": "https://cafefcdn.com/zoom/600_315/203337114487263232/2024/3/6/avatar1709692342259-17096923426541938811243.jpg"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với bánh quy gừng, sữa chua không đường.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnmeL3Rsq4u4jl_7tzQ-QcsNAQgFQsOaC6zA&s"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 15 phút, chuẩn bị tâm lý cho tam cá nguyệt 2.",
          "Image": "https://th.bing.com/th/id/OIP.050EwGVrrXSbiMrd996DOwHaE8?w=274&h=183&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin A qua bí đỏ, khoai lang.",
          "Image": "https://th.bing.com/th/id/OIP.IDfW8QdlvsXGhjd1Vl5hPQHaE9?w=232&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      20: {
        "Thứ 2": {
          "Meal": "Ăn súp bí đỏ với đậu lăng, bổ sung protein và chất xơ.",
          "Image": "https://thucduongfucoidan.com/storage/photos/shares/Album/m%C3%B3n%20ngon%20t%E1%BB%AB%20%C4%91%E1%BA%ADu%20l%C4%83ng.png"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi nướng, hạt chia.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn ổi, cam để bổ sung vitamin C, tránh táo bón.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ chiên, ăn yến mạch để hỗ trợ tiêu hóa.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpZ6sJbmSo_dnFdNHZYkiwu0DpEYGz1HHa0g&s"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép cà rốt, ăn sữa chua tự nhiên.",
          "Image": "https://bizweb.dktcdn.net/100/421/036/files/cach-pha-che-nuoc-ep-carot-dung-chuan.jpg?v=1617093097886"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 20 phút, massage chân để giảm chuột rút.",
          "Image": "https://th.bing.com/th/id/OIP.2FMGtHI4JmdfvkQ91j24bwHaEK?w=287&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi và vitamin D qua sữa, cá béo.",
          "Image": "https://th.bing.com/th/id/OIP.cweqChJO93Ej_LwPaL_TqAHaEo?w=290&h=181&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      21: {
        "Thứ 2": {
          "Meal": "Ăn cháo yến mạch với chuối, bổ sung năng lượng và kali.",
          "Image": "https://file.hstatic.net/200000668991/file/ch-nau-chao-dinh-duong-yen-mach-chuoi_f8c068be1bd5432f9db8122ece510b93_grande.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt chia, tránh đồ chiên.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn nho, dâu tây để bổ sung vitamin K và chất xơ.",
          "Image": "https://th.bing.com/th/id/OIP.hRXE3M5hG9YFLIDiS01Q3gHaLH?w=115&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ mặn, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://th.bing.com/th/id/OIP.XJ8_zgh7w97Y7UYGv1FxvAHaEV?w=320&h=187&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/11/5/nuoc-ep-tao-1-17307923826842105806077.jpg"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel để tăng cường cơ sàn chậu.",
          "Image": "https://th.bing.com/th/id/OIP.v38LCAEPb1KhLFLi87VGGgHaEi?w=275&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi hoặc ánh nắng nhẹ.",
          "Image": "https://benh.vn/wp-content/uploads/2018/04/bo-sung-vitamin-d-360x240.jpg"
        }
      },
      22: {
        "Thứ 2": {
          "Meal": "Ăn trứng luộc, bơ để bổ sung protein và chất béo lành mạnh.",
          "Image": "https://images.unsplash.com/photo-1525351484163-7529414344d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 3": {
          "Meal": "Uống trà hoa cúc nhẹ, tránh đồ ăn cay để dễ tiêu hóa.",
          "Image": "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn mận, táo để bổ sung chất xơ, tránh táo bón.",
          "Image": "https://th.bing.com/th/id/OIP.BqBlsIfV7TFi9o4yHQAUjQHaEL?w=325&h=183&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 5": {
          "Meal": "Bổ sung sắt qua gan heo (nấu chín), rau cải bó xôi.",
          "Image": "https://storage.googleapis.com/onelife-public/blog.onelife.vn/2021/11/cach-lam-chao-gan-heo-cai-bo-xoi-mon-an-cho-tre-652867034308.jpeg"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với bánh quy gừng, sữa chua không đường.",
          "Image": "https://th.bing.com/th/id/OIP.w_S017J1MdVkbde8H6gTSgHaE8?w=274&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Đi bộ 20 phút, nghe nhạc thư giãn cho thai nhi.",
          "Image": "https://home.cdn.papaya.services/nhac_phat_trien_tri_tue_cho_thai_nhi_2_7360dc5355.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa, hạt hạnh nhân.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/Images/haiyen/2017/03/13/hanh_nhan.jpg"
        }
      },
      23: {
        "Thứ 2": {
          "Meal": "Ăn cháo gà với gừng, bổ sung protein và dễ tiêu hóa.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/10/11/chao-ga-gung-1728658329150999421509.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi, hạt óc chó, tránh đồ sống.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn kiwi, cam để bổ sung vitamin C, tăng đề kháng.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, ăn súp đậu lăng để bổ sung sắt.",
          "Image": "https://www.thanhcongclinic.com/images/tintucphongkham/thieu-mau-nen-an-gi-de-bo-sung-sat.jpg"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua Hy Lạp.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-VN6ps8vuAkYw3bOprnVECGNhFQMGbpHebQ&s"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 15 phút, chuẩn bị tâm lý cho tam cá nguyệt 2.",
          "Image": "https://www.vinmec.com/static/uploads/small_20210204_085554_551012_tap_yoga_khi_mang_t_max_1800x1800_jpg_7331e7f01a.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin A qua bí đỏ, khoai lang.",
          "Image": "https://global-blog.cpcdn.com/vn/2024/06/nguye-n-lie--u-bo---sung-vitamin-A.png"
        }
      },
      24: {
        "Thứ 2": {
          "Meal": "Ăn yến mạch với quả mọng, chọn thực phẩm GI thấp.",
          "Image": "https://th.bing.com/th/id/OIP.ggCwzQKuxgFx5hfXZVvTvAHaFj?w=179&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt chia, tránh đồ chiên.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn táo, lê để bổ sung chất xơ, tránh đường tinh luyện.",
          "Image": "https://th.bing.com/th/id/OIP.Nz7MrW0ZnEjXc5F3fN5VsgHaD4?w=294&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://shop.annam-gourmet.com/pub/media/wysiwyg/pumpkin-soup-recipe-annam-gourmet-ingredients.jpg"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://cdn2.fptshop.com.vn/unsafe/Uploads/images/tin-tuc/165097/Originals/nuoc-ep-tao-6.jpg"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel để tăng cường cơ sàn chậu.",
          "Image": "https://feelex.vn/wp-content/uploads/2025/03/Huong-Dan-Bai-Tap-Kegel-Cho-Nu-Chuan-Nhat.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi, kiểm tra đường huyết.",
          "Image": "https://cdn.nhathuoclongchau.com.vn/v1/static/tac_dong_cua_vitamin_d_den_nguoi_co_duong_huyet_cao_73b7ee168c.png"
        }
      },
      25: {
        "Thứ 2": {
          "Meal": "Ăn cháo yến mạch với chuối, bổ sung năng lượng và kali.",
          "Image": "https://file.hstatic.net/1000217254/file/lam_oatmeal_bo_dau_phong_chuoi_hat_chia_12a02e0ccdab4d57b7b65eec3f1b4a32.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt chia, tránh đồ chiên.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn nho, dâu tây để bổ sung vitamin K và chất xơ.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNnv9KtlIx5fyWKxFG5oZfffaYrljpr91BQQ&s"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ mặn, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/8/13/sup-bi-do-17235392580081579722692.jpg"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://cdn.tgdd.vn/Files/2021/09/25/1385573/huong-dan-cach-lam-sinh-to-tao-sieu-ngon-va-giau-dinh-duong-202201151445049556.jpg"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel để tăng cường cơ sàn chậu.",
          "Image": "https://victoriavn.com/images/healthlibrary/kegel-la-gi-1-1.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi hoặc ánh nắng nhẹ.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2025/6/13/vitamin-d-17497838446131375025043.jpeg"
        }
      },
      26: {
        "Thứ 2": {"Meal": "Ăn trứng luộc, bơ để bổ sung protein và chất béo lành mạnh.",
          "Image": "https://images.unsplash.com/photo-1525351484163-7529414344d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 3": {
          "Meal": "Uống trà hoa cúc nhẹ, tránh đồ ăn cay để dễ tiêu hóa.",
          "Image": "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn mận, táo để bổ sung chất xơ, tránh táo bón.",
          "Image": "https://cdn.nhathuoclongchau.com.vn/unsafe/800x0/man_den_tri_tao_bon_va_nhung_dieu_can_luu_y_khi_su_dung_2_0faeac2d27.jpg"
        },
        "Thứ 5": {
          "Meal": "Bổ sung sắt qua gan heo (nấu chín), rau cải bó xôi.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2025/8/2/photo-1754111181028-1754111181194635232274.jpeg"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với bánh quy gừng, sữa chua không đường.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4QeKeWbmR11p-6Thk0qEaErLynKo4Yc6kSQ&s"
        },
        "Thứ 7": {
          "Meal": "Đi bộ 20 phút, nghe nhạc thư giãn cho thai nhi.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQi1YgG1eNjTqwAOWyqSKyKoCK8AtXswZ2lPw&s"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa, hạt hạnh nhân.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsbJ1bk--XnfQ3AJ4CtGkxCj_T7WHYnGu8uQ&s"
        }
      },
      27: {
        "Thứ 2": {
          "Meal": "Ăn cháo gà với gừng, bổ sung protein và dễ tiêu hóa.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIo0za72nhB2A2F-QbnCR-uAplqdLTmeF1Sg&s"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi, hạt óc chó, tránh đồ sống.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn kiwi, cam để bổ sung vitamin C, tăng đề kháng.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, ăn súp đậu lăng để bổ sung sắt.",
          "Image": "https://cdn.hstatic.net/files/1000312435/file/sup-dau-lang-do.jpg"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua Hy Lạp.",
          "Image": "https://th.bing.com/th/id/OIP.xDS4OoEBWYVDaoaH6N6flgHaEu?w=245&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 15 phút, chuẩn bị tâm lý cho tam cá nguyệt 3.",
          "Image": "https://th.bing.com/th/id/OIP.09J_MzsDpm1_GJgf-vGwTQHaD3?w=287&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin A qua bí đỏ, khoai lang.",
          "Image": "https://th.bing.com/th/id/OIP.XAEuAKqUBReOHcL054-AlAHaE_?w=237&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      28: {
        "Thứ 2": {
          "Meal": "Ăn yến mạch với quả mọng, bổ sung năng lượng.",
          "Image": "https://kim.com.vn/wp-content/uploads/2025/02/yen-mach-bot-protein-vani-qua-dem-voi-hon-hop-qua-mong.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt chia, tránh đồ chiên.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn táo, lê để bổ sung chất xơ, tránh táo bón.",
          "Image": "https://th.bing.com/th/id/OIP.jELoq3dqbtKlhCL8rIr3rgHaHa?w=157&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://th.bing.com/th/id/OIP.EllHuFeveP7mxFEJGzLIkgAAAA?w=226&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://th.bing.com/th/id/OIP.RR6knhWF0VM_K3qcrzrPYQHaF7?w=209&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tham gia lớp học tiền sản, tập bài tập thở.",
          "Image": "https://th.bing.com/th/id/OIP.8Ak8xeSRFutCuomJGy8uXQHaGA?w=238&h=193&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi, chuẩn bị tâm lý sinh.",
          "Image": "https://th.bing.com/th/id/OIP.eoc1IXiqPpqIH_dFk5BrQgHaE8?w=232&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      29: {
        "Thứ 2": {
          "Meal": "Ăn cháo yến mạch với chuối, bổ sung năng lượng và kali.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8xS6luP2jYzThD--g2wSXUsY7ssMa0A4LwQ&s"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi, hạt óc chó, tránh đồ sống.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn nho, dâu tây để bổ sung vitamin K và chất xơ.",
          "Image": "https://th.bing.com/th/id/OIP.xX5arBu7xRC4CEVLisC5rgHaE7?w=199&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ mặn, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQL7-mt3RUE8mODuyvB9h_h9xeykz8gooV9Bw&s"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://th.bing.com/th/id/OIP.RR6knhWF0VM_K3qcrzrPYQHaF7?w=209&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Theo dõi chuyển động thai (10 lần/ngày), tập thở.",
          "Image": "https://th.bing.com/th/id/OIP.VUBunBU8E3ay66LGsiNYYAHaE8?w=242&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi hoặc ánh nắng nhẹ.",
          "Image": "https://th.bing.com/th/id/OIP.VmFTaeMqiej1H3qoMg4NKgAAAA?w=200&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      30: {
        "Thứ 2": {
          "Meal": "Ăn cháo gà với khoai lang, bổ sung năng lượng và chất xơ.",
          "Image": "https://th.bing.com/th/id/OIP.2zqKkd-rm942EcCs2vKnSwHaFj?w=223&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung sắt qua thịt bò nạc, rau cải xanh đậm.",
          "Image": "https://th.bing.com/th/id/OIP.v33I0xOiQ76B4Lndtj1c3QHaE8?w=237&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 4": {
          "Meal": "Ăn xoài, táo để bổ sung vitamin A và chất xơ.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhNvKXq3wJRx8pwKlJHf2ygBdDla66t6W_ig&s"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, uống nước dừa để bổ sung điện giải.",
          "Image": "https://th.bing.com/th/id/OIP.1szyDOMgGx9F-RfhWQ5k9AHaD2?w=322&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với hạt hạnh nhân, sữa chua không đường.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/6/9/an-chay-nen-an-gi-1-17179526905211074954605.jpg"
        },
        "Thứ 7": {
          "Meal": "Nghỉ ngơi nhiều, thực hành bài tập thở sâu.",
          "Image": "https://th.bing.com/th/id/OIP.KvkUylUUOFHIl-IzGiIsQQHaF7?w=223&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa, phô mai, chuẩn bị kế hoạch sinh.",
          "Image": "https://procarevn.vn/wp-content/uploads/2017/08/bo-sung-canxi-khi-cho-con-bu-medonthan-net-2.jpg"
        }
      },
      31: {
        "Thứ 2": {
          "Meal": "Ăn súp bí đỏ với đậu lăng, bổ sung protein và chất xơ.",
          "Image": "https://thucduongfucoidan.com/storage/photos/shares/Album/m%C3%B3n%20ngon%20t%E1%BB%AB%20%C4%91%E1%BA%ADu%20l%C4%83ng.png"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi nướng, hạt chia.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn ổi, cam để bổ sung vitamin C, tránh táo bón.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ chiên, ăn yến mạch để hỗ trợ tiêu hóa.",
          "Image": "https://th.bing.com/th/id/OIP.S69raac6Ku9Uh1jWzOyQGwHaEK?w=292&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với bánh quy gừng, sữa chua không đường.",
          "Image": "https://cdn.tgdd.vn/2021/03/CookProduct/thumb1-1200x676-25.jpg"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 20 phút, massage chân để giảm chuột rút.",
          "Image": "https://th.bing.com/th/id/OIP.2FMGtHI4JmdfvkQ91j24bwHaEK?w=287&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi và vitamin D qua sữa, cá béo.",
          "Image": "https://th.bing.com/th/id/OIP.daDqmgicV24BmEo2F9CugAHaFE?w=292&h=199&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      32: {
        "Thứ 2": {
          "Meal": "Ăn cháo gà với khoai lang, bổ sung năng lượng và chất xơ.",
          "Image": "https://th.bing.com/th/id/OIP.PhYOfDVOMnkuxiYiZsMl2AHaEK?w=302&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung sắt qua thịt bò nạc, rau cải xanh đậm.",
          "Image": "https://th.bing.com/th/id/OIP.pupb7ErbDwjI7nk3ScPhYAHaE8?w=268&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 4": {
          "Meal": "Ăn xoài, táo để bổ sung vitamin A và chất xơ.",
          "Image": "https://suppro.com.vn/wp-content/uploads/2024/07/loi-ich-khi-an-xoai-giam-can-jpg.webp"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, uống nước dừa để bổ sung điện giải.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnf6C5l5SyUf0NkPyq0YU5R_UmnIJbF2kYlg&s"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với hạt hạnh nhân, sữa chua không đường.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSimwJqm-HY0WdkqQm8lHeJIuBKodVJtSc47w&s"
        },
        "Thứ 7": {
          "Meal": "Nghỉ ngơi nhiều, thực hành bài tập thở sâu.",
          "Image": "https://th.bing.com/th/id/OIP.fReqdvSsG9mliqwAT7QD3gHaE8?w=295&h=197&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa, phô mai, chuẩn bị kế hoạch sinh.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/6/26/1-1719395742896131205700.jpg"
        }
      },
      33: {
        "Thứ 2": {
          "Meal": "Ăn súp bí đỏ với đậu lăng, bổ sung protein và chất xơ.",
          "Image": "https://media-cdn-v2.laodong.vn/storage/newsportal/2024/10/18/1409504/Giam-Can-42-01.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt lanh.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn dâu tây, kiwi để bổ sung vitamin C.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqahleLi5rsq9PEQ9Jc-hEj1Sbdss0g9ruqQ&s"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ chiên, ăn rau củ hấp để dễ tiêu hóa.",
          "Image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSE6gkjocXQkuQF6JxRT4-1PKs43_87-CcJ3w&s"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel 10 phút, chuẩn bị tâm lý sinh.",
          "Image": "https://goldenchoice.com.vn/wp-content/uploads/2021/10/Kelgel.png"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá béo, ánh nắng nhẹ.",
          "Image": "https://nld.mediacdn.vn/QDgVqccccccccccccp8ccccccccccc/Image/2012/03/NewFolder-3/ca_2b6da.jpg"
        }
      },
      34: {
        "Thứ 2": {
          "Meal": "Ăn cháo yến mạch với quả mọng, bổ sung chất xơ.",
          "Image": "https://th.bing.com/th/id/OIP.uHelBwWq0MkOqoJ22erq9wHaDt?w=320&h=175&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung sắt qua thịt bò nướng, rau cải bó xôi.",
          "Image": "https://cdnphoto.dantri.com.vn/Yq1bQe5gglQrb4zdLPWtKEDQ0tk=/thumb_w/1020/2023/01/02/chatsat-1672628968083.jpg"
        },
        "Thứ 4": {
          "Meal": "Ăn táo, lê để bổ sung chất xơ, tránh táo bón.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2022/1/26/tao-bon-nen-an-gi0-16432095473321516816756.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, uống nước dừa để bổ sung điện giải.",
          "Image": "https://cdn2.tuoitre.vn/thumb_w/480/471584752817336320/2023/10/20/anh-chup-man-hinh-2023-10-20-064011-1697758836881660076380.png"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với hạt hạnh nhân, sữa chua không đường.",
          "Image": "https://th.bing.com/th/id/OIP.wHgN8_OHAL9Zv0vw6XOIfwHaFa?w=336&h=197&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Nghỉ ngơi nhiều, thực hành bài tập thở sâu.",
          "Image": "https://th.bing.com/th/id/OIP.vjtFI9A1KvJIiVhgG7jkAQHaE8?w=251&h=184&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa, phô mai, kiểm tra huyết áp.",
          "Image": "https://th.bing.com/th/id/OIP.ggAzMz4OjoEYWIlBFgreRwHaEg?w=272&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      35: {
        "Thứ 2": {
          "Meal": "Ăn súp bí đỏ với đậu lăng, bổ sung protein và chất xơ.",
          "Image": "https://mammy.vn/wp-content/uploads/2023/12/Dau-lang-do-dinh-duong-Mammy.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung sắt qua thịt bò nướng, rau cải bó xôi.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCyLPPymf5X_pYdJDRsbOVMKYwAU6C_ZqknA&s"
        },
        "Thứ 4": {
          "Meal": "Ăn xoài, táo để bổ sung vitamin A và chất xơ.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2024/5/9/xoai-17152151293211394711671.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, uống nước dừa để bổ sung điện giải.",
          "Image": "https://media.vov.vn/sites/default/files/styles/large/public/2023-09/tac_dung_phu_cua_viec_uong_nuoc_dua_ban_co_biet_1.jpg"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép cà rốt, ăn sữa chua tự nhiên.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcqtRuMpUN0wkolPjF-AaanxbjZDrdMqyHUQ&s"
        },
        "Thứ 7": {
          "Meal": "Tập yoga bầu 20 phút, massage chân để giảm chuột rút.",
          "Image": "https://th.bing.com/th/id/OIP.p4YYBklaTI4Qs7X2yVvQKwHaEK?w=322&h=181&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi và vitamin D qua sữa, cá béo.",
          "Image": "https://images2.thanhnien.vn/528068263637045248/2025/3/1/canxi-vitamind-17408415545341783215813.jpg"
        }
      },
      36: {
        "Thứ 2": {
          "Meal": "Ăn cháo gà với khoai lang, bổ sung năng lượng và chất xơ.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiyvvxQu10dh54lh4HjRnTb3zMf0E2aFYy1Q&s"
        },
        "Thứ 3": {
          "Meal": "Bổ sung sắt qua thịt bò nạc, rau cải xanh đậm.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwn5u5OZ_cjvkV_HaScZ2d6btBb0G_dFhn_g&s"
        },
        "Thứ 4": {
          "Meal": "Ăn xoài, táo để bổ sung vitamin A và chất xơ.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-1xJp54CsgrVToNhIoVaXwIj59QIKS9DlYA&s"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, uống nước dừa để bổ sung điện giải.",
          "Image": "https://vcdn1-suckhoe.vnecdn.net/2025/12/11/bansaonuocdua-1765439615-17654-5903-7518-1765439633.png?w=1200&h=0&q=100&dpr=1&fit=crop&s=c_6V4N7rY2h7rSqVLK53Rg"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với hạt hạnh nhân, sữa chua không đường.",
          "Image": "https://media.loveitopcdn.com/22764/cach-an-ngu-coc-giam-can-voi-sua-chua01.jpg"
        },
        "Thứ 7": {
          "Meal": "Nghỉ ngơi nhiều, thực hành bài tập thở sâu.",
          "Image": "https://th.bing.com/th/id/OIP.aisxY5mdH4hmi61xbMSxXAHaEj?w=259&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa, phô mai, chuẩn bị kế hoạch sinh.",
          "Image": "https://kamidi.vn/wp-content/uploads/2024/12/Thumb-3-7.jpg"
        }
      },
      37: {
        "Thứ 2": {
          "Meal": "Ăn súp bí đỏ với đậu lăng, bổ sung protein và chất xơ.",
          "Image": "https://th.bing.com/th/id/OIP.PMPKMCICRbVG-FTSva5vngHaE-?w=232&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá mòi, hạt lanh.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn dâu tây, kiwi để bổ sung vitamin C.",
          "Image": "https://cdnv2.tgdd.vn/mwg-static/common/News/1495651/thuc-pham-giau-vitamin-c-nhat-1.jpg"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ chiên, ăn rau củ hấp để dễ tiêu hóa.",
          "Image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://cdn.nhathuoclongchau.com.vn/unsafe/800x0/nuoc_ep_tao_co_tac_dung_gi_nuoc_ep_tao_mix_voi_gi_cho_giau_dinh_duong_1_9ad02a8c5f.jpg"
        },
        "Thứ 7": {
          "Meal": "Tập bài tập kegel 10 phút, chuẩn bị tâm lý sinh.",
          "Image": "https://th.bing.com/th/id/OIP.kZ77_A84kBHJNgXXdCNUMAHaE9?w=294&h=196&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá béo, ánh nắng nhẹ.",
          "Image": "https://cdn.nhathuoclongchau.com.vn/unsafe/800x0/7_cach_de_bo_sung_vitamin_d_hieu_qua_cho_co_the_cua_ban_3_7590c9e64b.jpg"
        }
      },
      38: {
        "Thứ 2": {
          "Meal": "Ăn cháo gà, bổ sung năng lượng, dễ tiêu hóa.",
          "Image": "https://www.btaskee.com/wp-content/uploads/2024/01/chao-ga-tot-cho-he-tieu-hoa.jpg"
        },
        "Thứ 3": {
          "Meal": "Bổ sung sắt qua thịt bò, cải bó xôi, chuẩn bị sinh.",
          "Image": "https://cdn.tgdd.vn/2020/10/CookProduct/a-1200x676.jpg"
        },
        "Thứ 4": {
          "Meal": "Ăn chà là, dứa để hỗ trợ chuyển dạ tự nhiên.",
          "Image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqqmLxBZ5hwSPcUMDEhJ5E_Wh7m89myF8XTw&s"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ cay nóng, ăn rau củ luộc, giữ đủ nước.",
          "Image": "https://th.bing.com/th/id/OIP.S69raac6Ku9Uh1jWzOyQGwHaEK?w=292&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Ăn nhẹ với sữa chua, trái cây, giữ tinh thần thoải mái.",
          "Image": "https://physalisvn.com/uploads/blog/2023_03/image-171.jpeg"
        },
        "Thứ 7": {
          "Meal": "Nghỉ ngơi nhiều, đi bộ nhẹ nhàng, sẵn sàng nhập viện.",
          "Image": "https://th.bing.com/th/id/OIP.vjtFI9A1KvJIiVhgG7jkAQHaE8?w=251&h=184&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung canxi qua sữa chua, phô mai, theo dõi dấu hiệu sinh.",
          "Image": "https://th.bing.com/th/id/OIP.l0aM-2A-F0GF4JtiTrPzJQHaE8?w=218&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      39: {
        "Thứ 2": {
          "Meal": "Ăn súp bí đỏ với đậu lăng, bổ sung protein và chất xơ.",
          "Image": "https://bepsangtao.com/wp-content/uploads/2024/09/sup-bi-do-dau-lang-768x432.webp"
        },
        "Thứ 3": {
          "Meal": "Bổ sung omega-3 qua cá hồi nướng, hạt chia.",
          "Image": "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 4": {
          "Meal": "Ăn ổi, cam để bổ sung vitamin C, tránh táo bón.",
          "Image": "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80"
        },
        "Thứ 5": {
          "Meal": "Tránh đồ ngọt, ăn súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://th.bing.com/th/id/OIP.EllHuFeveP7mxFEJGzLIkgAAAA?w=226&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 6": {
          "Meal": "Uống nước ép táo, ăn sữa chua tự nhiên.",
          "Image": "https://th.bing.com/th/id/OIP.RR6knhWF0VM_K3qcrzrPYQHaF7?w=209&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Tham gia lớp học tiền sản, tập bài tập thở.",
          "Image": "https://th.bing.com/th/id/OIP.8Ak8xeSRFutCuomJGy8uXQHaGA?w=238&h=193&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Chủ Nhật": {
          "Meal": "Bổ sung vitamin D qua cá mòi, chuẩn bị tâm lý sinh.",
          "Image": "https://th.bing.com/th/id/OIP.eoc1IXiqPpqIH_dFk5BrQgHaE8?w=232&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
      40: {
        "Thứ 2": {
          "Meal": "Ăn súp gà với khoai lang, bổ sung năng lượng dễ tiêu.",
          "Image": "https://mammy.vn/wp-content/uploads/2024/11/Cach-nau-sup-ga-cho-be-bieng-an.jpg"
        },
        "Thứ 3": {
          "Meal": "Uống nhiều nước, ăn nhẹ với trái cây tươi (táo, lê).",
          "Image": "https://image.plo.vn/w1000/Uploaded/2025/tmuihk/2023_05_09/trai-cay-6111.jpg.webp"
        },
        "Thứ 4": {
          "Meal": "Ăn cháo yến mạch, tránh đồ ăn nặng khó tiêu.",
          "Image": "https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2023/4/26/hoi-chung-ruot-kich-thich2-16825213253181567241458.jpg"
        },
        "Thứ 5": {
          "Meal": "Ăn rau củ hấp, súp bí đỏ để dễ tiêu hóa.",
          "Image": "https://lh7-us.googleusercontent.com/2CHH7glQYoAkZ2I6zDsb6Hjg6GbdoTWX3fOmVvn2qIUebIMESFbHojJIm-kJ-PbVDzlyMuydH1d9aLVTuNENNmMsPPDn536fH3lnVuNZdQv6dJmbncPeu3sh39QZb2kMzmTVYce2Qfyve_L6EmZcneI"
        },
        "Thứ 6": {
          "Meal": "Theo dõi dấu hiệu chuyển dạ, nghỉ ngơi tối đa.",
          "Image": "https://th.bing.com/th/id/OIP.Ezb7snKF-QnbRkZvi95V0AAAAA?w=258&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        },
        "Thứ 7": {
          "Meal": "Ăn nhẹ với sữa chua, trái cây, giữ tinh thần thoải mái.",
          "Image": "https://cdn.nhathuoclongchau.com.vn/unsafe/800x0/co_nen_an_sua_chua_voi_trai_cay_khong_va_nhung_mon_an_nao_khong_nen_ket_hop_voi_sua_chua_1_001897eda1.jpg"
        },
        "Chủ Nhật": {
          "Meal": "Liên hệ bác sĩ nếu có dấu hiệu sinh, ăn nhẹ.",
          "Image": "https://th.bing.com/th/id/OIP.yF6pDgfWgxZWE3dol7R3twHaEo?w=276&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
        }
      },
    };

    final currentWeekMenu = weeklyMenus[week] ?? weeklyMenus[1]!;

    return Scaffold(
      appBar: AppBar(
        title: Text("🥗 Thực đơn tuần $week"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("🍽️ Thực đơn gợi ý - Tuần $week",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 16),
          ...currentWeekMenu.entries.map((entry) {
            final day = entry.key;
            final meal = entry.value['Meal']!;
            final img = entry.value['Image']!;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              child: ListTile(
                title: Text(day,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(meal),
                trailing: img.isNotEmpty
                    ? Image.network(img, width: 80, fit: BoxFit.cover)
                    : const Icon(Icons.restaurant_menu, color: Colors.green),
              ),
            );
          })
        ],
      ),
    );
  }
}
