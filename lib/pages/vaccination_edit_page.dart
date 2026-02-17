import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // 🔥 Nhớ import thư viện này để format giờ đẹp
import '../models/vaccination_record_model.dart';
import '../services/vaccination_service.dart';

class VaccinationEditPage extends StatefulWidget {
  final VaccinationRecordModel record;

  const VaccinationEditPage({super.key, required this.record});

  @override
  State<VaccinationEditPage> createState() => _VaccinationEditPageState();
}

class _VaccinationEditPageState extends State<VaccinationEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController vaccineCtrl;
  late TextEditingController notesCtrl;
  late DateTime selectedDate;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    // Lấy ngày giờ cũ, nếu null thì lấy hiện tại
    selectedDate = widget.record.vaccination_date ?? DateTime.now();
    vaccineCtrl = TextEditingController(text: widget.record.vaccine_name);
    notesCtrl = TextEditingController(text: widget.record.notes);
    isCompleted = widget.record.is_completed ?? false;
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;

    await VaccinationService().update(widget.record.id!, {
      "vaccine_name": vaccineCtrl.text.trim(),
      "notes": notesCtrl.text.trim(),
      "is_completed": isCompleted,
      "vaccination_date": selectedDate, // Đã bao gồm cả giờ phút
    });

    Navigator.pop(context, true);
  }

  // 🔥 Hàm chọn Ngày & Giờ mới
  Future<void> _pickDateTime() async {
    // 1. Chọn Ngày
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return; // Hủy chọn ngày

    if (!mounted) return;

    // 2. Chọn Giờ (Lấy giờ hiện tại của selectedDate làm mặc định)
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    if (pickedTime == null) return; // Hủy chọn giờ

    // 3. Ghép lại
    setState(() {
      selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format hiển thị: 14:30 - 06/12/2025
    String dateDisplay = DateFormat('HH:mm - dd/MM/yyyy').format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text("✏️ Chỉnh sửa Lịch Tiêm Chủng")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: vaccineCtrl,
                decoration: const InputDecoration(
                  labelText: "💉 Tên vắc-xin",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v!.isEmpty ? "Tên vắc-xin không được để trống" : null,
              ),

              const SizedBox(height: 16),

              /// 🔥 CHỌN NGÀY & GIỜ (Đã cập nhật)
              ListTile(
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.grey)
                ),
                // Hiển thị ngày giờ đã format
                title: Text(
                  "📅 $dateDisplay",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.calendar_month, color: Colors.blue),
                onTap: _pickDateTime, // Gọi hàm chọn cả ngày và giờ
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text("Đã tiêm xong (Hoàn thành)"),
                value: isCompleted,
                onChanged: (v) => setState(() => isCompleted = v),
                activeColor: Colors.green,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "📝 Ghi chú",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 26),

              ElevatedButton.icon(
                onPressed: _update,
                icon: const Icon(Icons.save),
                label: const Text("Cập nhật"),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
