import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/child_model.dart';
import '../services/child_service.dart';

class ChildCreatePage extends StatefulWidget {
  const ChildCreatePage({super.key});

  @override
  _ChildCreatePageState createState() => _ChildCreatePageState();
}

class _ChildCreatePageState extends State<ChildCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;

  /// Chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  /// Lưu bé vào Firestore
  void _saveChild() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final data = {
      "name": _nameCtrl.text.trim(),
      "gender": _selectedGender,
      "date_of_birth": _selectedDate,
      "family_id": uid,   // << 🔥 SỬA LẠI ĐÚNG
      "created_at": DateTime.now(),
      "updated_at": DateTime.now(),
    };


    try {
      await ChildService().addChild(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("👶 Thêm bé thành công!")));
        Navigator.pop(context,true);
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❗ Lỗi: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("👶 Thêm Bé Mới")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Tên bé"),
                validator: (value) =>
                (value == null || value.isEmpty) ? "Vui lòng nhập tên bé" : null,
              ),

              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _selectedDate == null
                      ? "Ngày sinh: Chưa chọn"
                      : "Ngày sinh: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Giới tính"),
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Nam")),
                  DropdownMenuItem(value: "Female", child: Text("Nữ")),
                ],
                validator: (value) =>
                value == null ? "Vui lòng chọn giới tính" : null,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _saveChild,
                child: const Text("Lưu bé"),
              ),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
