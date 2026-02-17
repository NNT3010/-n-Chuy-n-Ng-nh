import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // 🔥 Cần thêm thư viện này để format ngày giờ đẹp
import '../services/vaccination_service.dart';

class VaccinationCreatePage extends StatefulWidget {
  @override
  State<VaccinationCreatePage> createState() => _VaccinationCreatePageState();
}

class _VaccinationCreatePageState extends State<VaccinationCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final VaccinationService service = VaccinationService();

  String? selectedChildId;
  final vaccineCtrl = TextEditingController();
  DateTime? selectedDate; // ✅ Biến lưu cả ngày và giờ
  bool isCompleted = false;
  final notesCtrl = TextEditingController();

  Stream<List<Map<String, dynamic>>> _getChildren() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("children")
        .where("family_id", isEqualTo: uid)
        .snapshots()
        .map((snap)=> snap.docs.map((e)=>{...e.data(),"id":e.id}).toList());
  }

  /// LƯU LỊCH TIÊM
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Vui lòng chọn ngày và giờ tiêm")));
      return;
    }

    await service.create(
      childId: selectedChildId!,
      vaccineName: vaccineCtrl.text.trim(),
      date: selectedDate!, // Lưu DateTime có cả giờ phút
      isCompleted: isCompleted,
      notes: notesCtrl.text.trim(),
    );

    Navigator.pop(context, true);
  }

  // 🔥 HÀM CHỌN NGÀY VÀ GIỜ ĐÃ SỬA LỖI
  Future<void> _pickDateTime() async {
    // 1. Chọn Ngày
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return; // Người dùng huỷ chọn ngày

    if (!mounted) return;

    // 2. Chọn Giờ
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
    );

    if (pickedTime == null) return; // Người dùng huỷ chọn giờ

    // 3. Ghép Ngày + Giờ lại với nhau và lưu vào biến selectedDate
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
    // Format hiển thị ngày giờ
    String dateDisplay = "📅 Chọn ngày và giờ tiêm";
    if (selectedDate != null) {
      dateDisplay = "📅 ${DateFormat('HH:mm - dd/MM/yyyy').format(selectedDate!)}";
    }

    return Scaffold(
      appBar: AppBar(title: const Text("➕ Thêm Lịch Tiêm Chủng")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _getChildren(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final children = snap.data!;

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "👶 Chọn bé"),
                    items: children
                        .map((c) => DropdownMenuItem<String>(
                      value: c["id"],
                      child: Text(c["name"] ?? "Bé không tên"),
                    ))
                        .toList(),
                    onChanged: (v) => selectedChildId = v,
                    validator: (v) => v == null ? "Hãy chọn bé" : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: vaccineCtrl,
                    decoration: const InputDecoration(labelText: "💉 Tên vắc-xin"),
                    validator: (v) => v!.isEmpty ? "Không được để trống" : null,
                  ),

                  const SizedBox(height: 16),

                  // 🔥 GỌI HÀM CHỌN NGÀY GIỜ MỚI
                  ListTile(
                    title: Text(
                        dateDisplay,
                        style: TextStyle(
                            color: selectedDate == null ? Colors.black54 : Colors.black,
                            fontWeight: selectedDate == null ? FontWeight.normal : FontWeight.bold
                        )
                    ),
                    trailing: const Icon(Icons.calendar_month, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4)
                    ),
                    onTap: _pickDateTime, // Gọi hàm chọn ngày giờ ở đây
                  ),

                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text("Đã hoàn thành mũi tiêm này"),
                    value: isCompleted,
                    onChanged: (v) => setState(() => isCompleted = v),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: notesCtrl,
                    decoration: const InputDecoration(labelText: "📝 Ghi chú"),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text("Lưu Lịch Tiêm"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
