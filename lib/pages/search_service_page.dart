import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Cần gói url_launcher trong pubspec.yaml
import '../models/medical_service_model.dart';
import '../services/medical_service_service.dart';

class SearchServicePage extends StatefulWidget {
  const SearchServicePage({super.key});

  @override
  State<SearchServicePage> createState() => _SearchServicePageState();
}

class _SearchServicePageState extends State<SearchServicePage> {
  final TextEditingController searchCtrl = TextEditingController();
  String typeFilter = "All";
  List<MedicalServiceModel> services = [];
  bool loading = false;

  // Gọi Service lấy dữ liệu
  final medicalServiceService = MedicalServiceService();

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  // Hàm tải dữ liệu từ Firebase
  Future<void> loadServices() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      services = await medicalServiceService.searchServices(
        search: searchCtrl.text.trim(),
        typeFilter: typeFilter,
      );
    } catch (e) {
      debugPrint("Lỗi tải dịch vụ: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // 📞 Hàm gọi điện
  void _callPhone(String phone) async {
    // Loại bỏ khoảng trắng nếu có
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');    final Uri uri = Uri(scheme: 'tel', path: cleanPhone);

    // Thử dùng mode: LaunchMode.externalApplication
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không thể thực hiện cuộc gọi")),
        );
      }
    }
  }


  // 🗺️ Hàm mở bản đồ (Google Maps)
  void _openMap(String address) async {
    final Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không thể mở bản đồ")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🏥 Tìm kiếm Dịch vụ Y tế"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: loadServices, // Kéo xuống để reload
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 1️⃣ THANH TÌM KIẾM
              TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.pinkAccent),
                  hintText: "Nhập tên, địa chỉ...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none
                  ),
                  suffixIcon: searchCtrl.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchCtrl.clear();
                      loadServices();
                    },
                  )
                      : null,
                ),
                onChanged: (_) => loadServices(),
              ),
              const SizedBox(height: 16),

              // 2️⃣ FILTER LOẠI DỊCH VỤ (Chip)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["All", "Hospital", "Clinic", "Pharmacy", "Other"].map((type) {
                    bool isSelected = typeFilter == type;

                    // Map tên hiển thị tiếng Việt
                    String label = type;
                    switch(type) {
                      case "All": label = "Tất cả"; break;
                      case "Hospital": label = "Bệnh viện"; break;
                      case "Clinic": label = "Phòng khám"; break;
                      case "Pharmacy": label = "Nhà thuốc"; break;
                      case "Other": label = "Khác"; break;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => typeFilter = type);
                            loadServices();
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Colors.pinkAccent.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.pink : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        checkmarkColor: Colors.pink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide.none,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // 3️⃣ DANH SÁCH KẾT QUẢ
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : services.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("Không tìm thấy kết quả nào",
                          style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: services.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final s = services[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Tên + Loại
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    s.name ?? "Không có tên",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(s.type),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                      s.type ?? "Khác",
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Thông tin chi tiết
                            if (s.description != null && s.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(s.description!, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              ),

                            // Địa chỉ (Click để mở map)
                            GestureDetector(
                              onTap: () => s.address != null ? _openMap(s.address!) : null,
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                        s.address ?? "Chưa cập nhật địa chỉ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue[700],
                                            decoration: TextDecoration.underline
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Giá tiền
                            if (s.price != null && s.price! > 0)
                              Row(
                                children: [
                                  const Icon(Icons.attach_money, size: 16, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                      "${s.price!.toStringAsFixed(0)} VNĐ",
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15)
                                  ),
                                ],
                              ),

                            const Divider(height: 20),

                            // Footer: Rating + Nút Gọi
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                        s.rating?.toStringAsFixed(1) ?? "0.0",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                    ),
                                    const SizedBox(width: 4),
                                    Text("(${s.rating != null ? 'Đánh giá' : 'Chưa có'})", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                                if (s.phone != null && s.phone!.isNotEmpty)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                      elevation: 2,
                                    ),
                                    onPressed: () => _callPhone(s.phone!),
                                    icon: const Icon(Icons.phone, size: 18),
                                    label: const Text("Liên hệ"),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Màu sắc theo loại dịch vụ
  Color _getTypeColor(String? type) {
    switch (type) {
      case 'Hospital': return Colors.blue;
      case 'Clinic': return Colors.teal;
      case 'Pharmacy': return Colors.orange;
      default: return Colors.grey;
    }
  }
}
