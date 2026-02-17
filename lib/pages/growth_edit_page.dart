// lib/pages/growth_edit_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/growth_record_model.dart';
import '../services/growth_service.dart';

class GrowthEditPage extends StatefulWidget {
  final GrowthRecordModel record;
  const GrowthEditPage({super.key, required this.record});

  @override
  State<GrowthEditPage> createState() => _GrowthEditPageState();
}

class _GrowthEditPageState extends State<GrowthEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _headCtrl;
  late TextEditingController _noteCtrl;
  late DateTime _recordDate;

  String? childName;
  bool loadingChild = true;

  @override
  void initState() {
    super.initState();
    _weightCtrl = TextEditingController(text: widget.record.weight?.toString() ?? '');
    _heightCtrl = TextEditingController(text: widget.record.height?.toString() ?? '');
    _headCtrl = TextEditingController(text: widget.record.head_circumference?.toString() ?? '');
    _noteCtrl = TextEditingController(text: widget.record.notes ?? '');
    _recordDate = widget.record.record_date ?? DateTime.now();

    _loadChildName();
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _headCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadChildName() async {
    final childId = widget.record.child_id;
    if (childId == null) {
      setState(() {
        childName = "Không rõ";
        loadingChild = false;
      });
      return;
    }

    try {
      final snap = await FirebaseFirestore.instance.collection('children').doc(childId).get();
      setState(() {
        childName = (snap.exists ? (snap.data()?['name'] ?? "Không rõ tên") : "Không tìm thấy bé");
        loadingChild = false;
      });
    } catch (e) {
      setState(() {
        childName = "Lỗi tải tên bé";
        loadingChild = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Tạo model updated (không phụ thuộc vào copyWith)
    final updated = GrowthRecordModel(
      id: widget.record.id,
      child_id: widget.record.child_id,
      weight: double.tryParse(_weightCtrl.text),
      height: double.tryParse(_heightCtrl.text),
      head_circumference: double.tryParse(_headCtrl.text),
      notes: _noteCtrl.text.trim(),
      record_date: _recordDate,
      created_at: widget.record.created_at ?? DateTime.now(),
      updated_at: DateTime.now(),
    );

    await GrowthService().updateGrowthRecord(widget.record.id!, updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật chỉ số')));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('✏️ Sửa chỉ số phát triển')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loadingChild
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              // Hiển thị tên bé (thay vì id)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "👶 Bé: ${childName ?? 'Không rõ'}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _weightCtrl,
                decoration: const InputDecoration(labelText: 'Cân nặng (kg)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Nhập cân nặng' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _heightCtrl,
                decoration: const InputDecoration(labelText: 'Chiều cao (cm)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Nhập chiều cao' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _headCtrl,
                decoration: const InputDecoration(labelText: 'Vòng đầu (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              ListTile(
                title: Text('Ngày ghi: ${_recordDate.day}/${_recordDate.month}/${_recordDate.year}'),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _recordDate,
                    firstDate: DateTime(2010),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _recordDate = picked);
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              ElevatedButton(onPressed: _save, child: const Text('Lưu thay đổi')),
            ],
          ),
        ),
      ),
    );
  }
}
