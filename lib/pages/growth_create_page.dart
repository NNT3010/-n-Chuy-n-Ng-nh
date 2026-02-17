import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/growth_record_model.dart';
import '../services/growth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class GrowthCreatePage extends StatefulWidget {
  final String childId;

  const GrowthCreatePage({super.key, required this.childId});

  @override
  State<GrowthCreatePage> createState() => _GrowthCreatePageState();
}

class _GrowthCreatePageState extends State<GrowthCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final headCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String? childName; // 🔥 Tên bé sẽ lưu vào đây
  bool loadingChild = true;

  /// 🔥 Lấy tên bé từ Firestore
  Future<void> _loadChildName() async {
    final snap = await FirebaseFirestore.instance
        .collection("children")
        .doc(widget.childId)
        .get();

    setState(() {
      childName = snap.data()?["name"] ?? "Không rõ tên";
      loadingChild = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadChildName();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    // 🔥 CHÚ Ý: Tên collection trong Rules của bạn là "growth_records" (chữ thường)
    await FirebaseFirestore.instance.collection("growth_records").add({

      // 👇 SỬA LẠI THÀNH "userId" ĐỂ KHỚP VỚI RULES
      "userId": uid,

      // 👇 Kiểm tra Rules của bạn dùng "userId", nhưng code này dùng "child_id"
      // Nếu bạn muốn đồng bộ kiểu đặt tên, hãy xem xét sửa Rules hoặc Code.
      // Nhưng hiện tại để chạy được, hãy giữ nguyên hoặc đổi thành "childId" tùy database của bạn.
      "childId": widget.childId, // Nên dùng childId nếu database đang dùng camelCase

      "weight": double.parse(weightCtrl.text),
      "height": double.parse(heightCtrl.text),
      "head_circumference": double.tryParse(headCtrl.text) ?? 0,
      "notes": noteCtrl.text.trim(),
      "record_date": selectedDate,
      "created_at": DateTime.now(),
      "updated_at": DateTime.now(),
    });

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("➕ Thêm chỉ số phát triển"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loadingChild
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              /// 🔥 HIỂN THỊ TÊN BÉ THAY VÌ ID
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "👶 Bé: $childName",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Cân nặng
              TextFormField(
                controller: weightCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Cân nặng (kg)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Nhập cân nặng" : null,
              ),

              const SizedBox(height: 16),

              /// Chiều cao
              TextFormField(
                controller: heightCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Chiều cao (cm)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Nhập chiều cao" : null,
              ),

              const SizedBox(height: 16),

              /// Vòng đầu
              TextFormField(
                controller: headCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Vòng đầu (cm)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// Ngày ghi
              ListTile(
                tileColor: Colors.grey.shade200,
                title: Text(
                  "📅 Ngày ghi: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final pick = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2010),
                    lastDate: DateTime.now(),
                  );
                  if (pick != null) {
                    setState(() => selectedDate = pick);
                  }
                },
              ),

              const SizedBox(height: 16),

              /// Ghi chú
              TextFormField(
                controller: noteCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Ghi chú",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              /// Nút lưu
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Lưu chỉ số"),
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
