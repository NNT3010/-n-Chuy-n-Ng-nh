import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mebecare/models/medical_service_model.dart';

class AddMedicalServicePage extends StatefulWidget {
  @override
  State<AddMedicalServicePage> createState() => _AddMedicalServicePageState();
}

class _AddMedicalServicePageState extends State<AddMedicalServicePage> {
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController(); // Thêm nhập giá

  double rating = 5.0;
  String type = "Hospital";

  Future saveService() async {
    // Tạo object từ Model
    final newService = MedicalServiceModel(
      name: nameCtrl.text,
      type: type,
      address: addressCtrl.text,
      phone: phoneCtrl.text,
      description: descCtrl.text,
      rating: rating,
      price: double.tryParse(priceCtrl.text) ?? 0.0,
      is_active: true,
      created_at: DateTime.now(),
    );

    // Lưu dùng toMap() của Model để đảm bảo đồng nhất
    await FirebaseFirestore.instance
        .collection("medical_services")
        .add(newService.toMap());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("➕ Thêm Dịch vụ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Tên dịch vụ")),
          SizedBox(height: 10),
          DropdownButtonFormField(
            value: type,
            items: ["Hospital","Clinic","Pharmacy","Other"].map((v) =>
                DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(()=> type=v!),
            decoration: InputDecoration(labelText: "Loại"),
          ),
          SizedBox(height: 10),
          TextField(controller: addressCtrl, decoration: InputDecoration(labelText: "Địa chỉ")),
          SizedBox(height: 10),
          TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: "Số điện thoại")),
          SizedBox(height: 10),
          TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Giá tham khảo (VNĐ)")),
          SizedBox(height: 10),
          TextField(controller: descCtrl, maxLines: 3, decoration: InputDecoration(labelText: "Mô tả")),
          SizedBox(height: 10),
          Text("Đánh giá: $rating ⭐"),
          Slider(value: rating, min: 1, max: 5, divisions: 4, onChanged: (v)=> setState(()=> rating=v)),
          SizedBox(height: 20),
          ElevatedButton(onPressed: saveService, child: Text("💾 Lưu Dịch Vụ"))
        ]),
      ),
    );
  }
}
