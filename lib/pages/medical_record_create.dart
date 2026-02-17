import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/child_model.dart';
import '../models/medical_record_model.dart';

import '../services/child_service.dart';
import '../services/medical_record_service.dart';
import 'child_create_page.dart';

class MedicalRecordCreate extends StatefulWidget {
  const MedicalRecordCreate({super.key});

  @override
  State<MedicalRecordCreate> createState() => _MedicalRecordCreateState();
}

class _MedicalRecordCreateState extends State<MedicalRecordCreate> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _treatmentCtrl = TextEditingController();

  String? _selectedSubjectId; // null = chọn MẸ
  String _selectedDiagnosis = "Allergy";

  // 🔥 Lấy userId thật từ Firebase Auth
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  // 🔥 Giả sử mỗi user có 1 family_id = userId
  String get familyId => userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("➕ Thêm hồ sơ sức khỏe")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chọn đối tượng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // 🔥 Nút thêm bé
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Thêm bé mới"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100],
                  foregroundColor: Colors.pink,
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ChildCreatePage()),
                  );

                  if (result == true) setState(() {});
                },
              ),

              const SizedBox(height: 20),

              // 🔥 Dropdown load danh sách bé từ Firestore
              StreamBuilder<List<ChildModel>>(
                stream: ChildService().getChildrenByFamily(familyId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final children = snapshot.data ?? [];

                  List<DropdownMenuItem<String>> dropdownItems = [
                    const DropdownMenuItem(
                      value: "MOTHER",
                      child: Text("🤱 Mẹ"),
                    ),
                  ];

                  dropdownItems.addAll(
                    children.map(
                          (child) => DropdownMenuItem(
                        value: child.id,
                        child: Text("👶 ${child.name}"),
                      ),
                    ),
                  );

                  return DropdownButtonFormField<String>(
                    value: _selectedSubjectId,
                    decoration:
                    const InputDecoration(labelText: "Đối tượng"),
                    items: dropdownItems,
                    onChanged: (val) {
                      setState(() {
                        _selectedSubjectId = val;
                      });
                    },
                    validator: (value) =>
                    value == null ? "Vui lòng chọn đối tượng" : null,
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🔥 Loại hồ sơ
              DropdownButtonFormField<String>(
                value: _selectedDiagnosis,
                decoration: const InputDecoration(labelText: "Loại hồ sơ"),
                items: [
                  "Allergy",
                  "Condition",
                  "Medication",
                  "Vaccination",
                  "Growth",
                  "Other"
                ]
                    .map((t) =>
                    DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedDiagnosis = val!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // 🔥 Mô tả chi tiết
              TextFormField(
                controller: _treatmentCtrl,
                decoration: const InputDecoration(labelText: "Mô tả"),
                maxLines: 3,
                validator: (value) =>
                value == null || value.isEmpty ? "Vui lòng nhập mô tả" : null,
              ),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _saveRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Lưu hồ sơ"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Lưu hồ sơ vào Firestore
  void _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    final record = MedicalRecordModel(
      user_id: userId, // quan trọng: phân quyền theo user
      child_id: _selectedSubjectId == "MOTHER" ? null : _selectedSubjectId,
      diagnosis: _selectedDiagnosis,
      treatment: _treatmentCtrl.text,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
    );

    await MedicalRecordService().addRecord(record);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã thêm hồ sơ!")),
    );

    Navigator.pop(context);
  }
}
