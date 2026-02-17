import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditGrowthRecordPage extends StatefulWidget {
  final String id;
  final Map data;

  const EditGrowthRecordPage(this.id, this.data, {super.key});

  @override
  State<EditGrowthRecordPage> createState() => _EditGrowthRecordPageState();
}

class _EditGrowthRecordPageState extends State<EditGrowthRecordPage> {
  late TextEditingController weight;
  late TextEditingController height;
  late TextEditingController head;
  late TextEditingController notes;
  late DateTime date;

  @override
  void initState() {
    super.initState();

    weight = TextEditingController(text: widget.data["weight"].toString());
    height = TextEditingController(text: widget.data["height"].toString());
    head   = TextEditingController(text: widget.data["head_circumference"].toString());
    notes  = TextEditingController(text: widget.data["notes"] ?? "");

    /// 🔥 record_date chuẩn
    var d = widget.data["record_date"];
    date = (d is Timestamp) ? d.toDate() : DateTime.now();
  }

  Future updateData() async {
    await FirebaseFirestore.instance.collection("growth_records").doc(widget.id).update({
      "weight": double.tryParse(weight.text) ?? 0,
      "height": double.tryParse(height.text) ?? 0,
      "head_circumference": double.tryParse(head.text) ?? 0,
      "notes": notes.text.trim(),
      "record_date": date,
      "updated_at": DateTime.now(),  // optional
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✨ Cập nhật thành công")));
  }

  Future pickDate() async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => date = d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✏ Sửa chỉ số phát triển")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            /// Chọn ngày
            ListTile(
              tileColor: Colors.blue.shade50,
              title: Text("📅 ${DateFormat('dd/MM/yyyy').format(date)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.calendar_month),
              onTap: pickDate,
            ),

            const SizedBox(height: 12),
            TextField(controller: weight, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "⚖ Cân nặng (kg)")),
            const SizedBox(height: 10),
            TextField(controller: height, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "📏 Chiều cao (cm)")),
            const SizedBox(height: 10),
            TextField(controller: head, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "🧠 Vòng đầu (cm)")),
            const SizedBox(height: 10),
            TextField(controller: notes, maxLines: 3, decoration: const InputDecoration(labelText: "📝 Ghi chú")),
            const SizedBox(height: 20),

            ElevatedButton(onPressed: updateData, child: const Text("💾 Lưu thay đổi")),
          ],
        ),
      ),
    );
  }
}
