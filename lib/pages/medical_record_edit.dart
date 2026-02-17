import 'package:flutter/material.dart';
import '../models/medical_record_model.dart';
import '../services/medical_record_service.dart';

class MedicalRecordEdit extends StatefulWidget {
  final MedicalRecordModel record;

  const MedicalRecordEdit({super.key, required this.record});

  @override
  State<StatefulWidget> createState() => _MedicalRecordEditState();
}

class _MedicalRecordEditState extends State<MedicalRecordEdit> {
  late TextEditingController descCtrl;
  late String recordType;

  @override
  void initState() {
    super.initState();

    descCtrl = TextEditingController(text: widget.record.treatment ?? "");
    recordType = widget.record.diagnosis ?? "Other";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✏️ Sửa hồ sơ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.record.child_id != null
                  ? "Đối tượng: 👶 ${widget.record.child_id}"
                  : "Đối tượng: 🤱 Mẹ",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: recordType,
              decoration: const InputDecoration(labelText: "Loại hồ sơ"),
              items: ["Allergy", "Condition", "Medication", "Vaccination", "Growth", "Other"]
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => recordType = val!),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Mô tả"),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (widget.record.id == null) return;

                final updated = widget.record.copyWith(
                  diagnosis: recordType,
                  treatment: descCtrl.text,
                  updated_at: DateTime.now(),
                );

                await MedicalRecordService().updateRecord(widget.record.id!.toString(), updated);

                Navigator.pop(context);
              },
              child: const Text("Cập nhật"),
            ),
          ],
        ),
      ),
    );
  }
}
