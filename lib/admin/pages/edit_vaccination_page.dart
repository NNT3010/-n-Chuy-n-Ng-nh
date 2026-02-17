import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditVaccinationPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditVaccinationPage({super.key, required this.docId, required this.data});

  @override
  _EditVaccinationPageState createState() => _EditVaccinationPageState();
}

class _EditVaccinationPageState extends State<EditVaccinationPage> {
  late TextEditingController vaccineCtrl;
  late TextEditingController notesCtrl;
  late DateTime selectedDate;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();

    vaccineCtrl  = TextEditingController(text: widget.data["vaccine_name"] ?? "");
    notesCtrl    = TextEditingController(text: widget.data["notes"] ?? "");

    // Lấy timestamp từ data và chuyển thành DateTime
    selectedDate = (widget.data["vaccination_date"] as Timestamp?)?.toDate() ?? DateTime.now();

    isCompleted = widget.data["is_completed"] ?? false;
  }

  Future<void> updateVaccination() async {
    // Không cần form validation vì đây là trang của Admin, có thể linh hoạt hơn
    await FirebaseFirestore.instance
        .collection("vaccination_records")
        .doc(widget.docId)
        .update({
      "vaccine_name": vaccineCtrl.text.trim(),
      "notes": notesCtrl.text.trim(),
      "is_completed": isCompleted,
      "vaccination_date": selectedDate, // Biến này giờ đã có cả giờ và phút
      "updated_at": FieldValue.serverTimestamp(), // Dùng server time cho chính xác
    });

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✨ Cập nhật thành công")),
      );
    }
  }

  // 🔥 HÀM MỚI: Chọn cả ngày và giờ
  Future<void> pickDateTime() async {
    // 1. Chọn ngày
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return; // Người dùng hủy

    if (!mounted) return;

    // 2. Chọn giờ
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    if (pickedTime == null) return; // Người dùng hủy

    // 3. Ghép ngày và giờ lại
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
    return Scaffold(
      appBar: AppBar(title: const Text("✏ Sửa lịch tiêm chủng")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // -------
            // 🔥 Ngày giờ tiêm (ĐÃ CẬP NHẬT)
            // -------
            ListTile(
              tileColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              // Hiển thị cả giờ và ngày
              title: Text("📅 ${DateFormat('HH:mm - dd/MM/yyyy').format(selectedDate)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              trailing: const Icon(Icons.calendar_month, color: Colors.blue),
              onTap: pickDateTime, // Gọi hàm mới
            ),

            const SizedBox(height: 18),

            // Tên vắc xin
            TextField(
              controller: vaccineCtrl,
              decoration: const InputDecoration(
                labelText: "💉 Tên vắc-xin",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            // Trạng thái tiêm
            SwitchListTile(
              activeColor: Colors.green,
              title: const Text("Đã tiêm hoàn thành"),
              value: isCompleted,
              onChanged: (v) => setState(() => isCompleted = v),
            ),

            const SizedBox(height: 18),

            // Ghi chú
            TextField(
              controller: notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "📝 Ghi chú",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: updateVaccination,
              icon: const Icon(Icons.save),
              label: const Text("Lưu thay đổi"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 17),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white, // Thêm màu chữ cho đẹp hơn
              ),
            )
          ],
        ),
      ),
    );
  }
}
