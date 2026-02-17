import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/medical_service_model.dart'; // Import model

class EditMedicalServicePage extends StatefulWidget {
  final String id;
  // Dùng Map để linh hoạt với dữ liệu cũ/mới từ Firestore
  final Map<String, dynamic> data;

  const EditMedicalServicePage(this.id, this.data, {super.key});

  @override
  State<EditMedicalServicePage> createState() => _EditMedicalServicePageState();
}

class _EditMedicalServicePageState extends State<EditMedicalServicePage> {
  // Khai báo các Controller
  late TextEditingController nameCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController descCtrl;
  late TextEditingController priceCtrl;
  late double rating;
  late String type;

  @override
  void initState() {
    super.initState();
    var d = widget.data; // Lấy dữ liệu từ widget

    // Khởi tạo giá trị ban đầu cho các Controller, có xử lý null
    nameCtrl = TextEditingController(text: d['name'] ?? '');
    addressCtrl = TextEditingController(text: d['address'] ?? '');
    phoneCtrl = TextEditingController(text: d['phone'] ?? '');
    descCtrl = TextEditingController(text: d['description'] ?? '');
    priceCtrl = TextEditingController(text: d['price']?.toString() ?? '0');

    // Xử lý null cho rating và type
    rating = (d['rating'] as num?)?.toDouble() ?? 5.0;
    type = d['type'] ?? 'Hospital';
  }

  // Hàm cập nhật
  Future<void> updateService() async {
    // Tạo object mới từ Model
    final updatedService = MedicalServiceModel(
      id: widget.id, // Giữ lại ID cũ
      name: nameCtrl.text,
      type: type,
      address: addressCtrl.text,
      phone: phoneCtrl.text,
      description: descCtrl.text,
      rating: rating,
      price: double.tryParse(priceCtrl.text) ?? 0.0,
      is_active: true, // Mặc định là active khi cập nhật
    );

    // Dùng .update() và toMap() để cập nhật
    await FirebaseFirestore.instance
        .collection("medical_services")
        .doc(widget.id)
        .update(updatedService.toMap());

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // Nhớ dispose các controller
    nameCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✏️ Sửa Dịch vụ Y tế")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Tên dịch vụ")),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: type,
            items: ["Hospital", "Clinic", "Pharmacy", "Other"]
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
            onChanged: (v) => setState(() => type = v!),
            decoration: const InputDecoration(labelText: "Loại"),
          ),
          const SizedBox(height: 12),
          TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: "Địa chỉ")),
          const SizedBox(height: 12),
          TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Số điện thoại")),
          const SizedBox(height: 12),
          TextField(
            controller: priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Giá tham khảo (VNĐ)"),
          ),
          const SizedBox(height: 12),
          TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Mô tả")),
          const SizedBox(height: 12),
          Text("Đánh giá: ${rating.toStringAsFixed(1)} ⭐"),
          Slider(
            value: rating,
            min: 1,
            max: 5,
            divisions: 4, // 1, 2, 3, 4, 5
            onChanged: (v) => setState(() => rating = v),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: updateService, child: const Text("💾 Cập nhật"))
        ]),
      ),
    );
  }
}
