import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDoctorPage extends StatefulWidget {
  final String id;
  final Map data;

  const EditDoctorPage({super.key, required this.id, required this.data});

  @override
  State<EditDoctorPage> createState() => _EditDoctorPageState();
}

class _EditDoctorPageState extends State<EditDoctorPage> {
  late TextEditingController specialtyCtrl;
  late TextEditingController hospitalCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();

    // 🔥 SỬA LỖI 1: Dùng ?? "" để tránh lỗi Null (Màn hình đỏ)
    // 🔥 SỬA LỖI 2: Kiểm tra đúng key (specialization, description)

    String initialSpecialty = widget.data['specialization'] ?? widget.data['specialty'] ?? "";
    String initialHospital = widget.data['hospital'] ?? "";
    String initialDesc = widget.data['description'] ?? widget.data['bio'] ?? "";

    specialtyCtrl = TextEditingController(text: initialSpecialty);
    hospitalCtrl = TextEditingController(text: initialHospital);
    descCtrl = TextEditingController(text: initialDesc);
  }

  @override
  void dispose() {
    specialtyCtrl.dispose();
    hospitalCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("✏ Sửa bác sĩ")),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView( // Thêm cuộn trang để không bị che phím
            child: Column(
              children: [
                TextField(
                    controller: specialtyCtrl,
                    decoration: const InputDecoration(
                        labelText: "🧬 Chuyên khoa",
                        border: OutlineInputBorder()
                    )
                ),
                const SizedBox(height: 16),

                TextField(
                    controller: hospitalCtrl,
                    decoration: const InputDecoration(
                        labelText: "🏥 Bệnh viện",
                        border: OutlineInputBorder()
                    )
                ),
                const SizedBox(height: 16),

                TextField(
                    controller: descCtrl,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        labelText: "📃 Mô tả / Tiểu sử",
                        border: OutlineInputBorder()
                    )
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // 🔥 SỬA LỖI 3: Lưu vào collection "Doctors" (Viết Hoa)
                      // và dùng đúng key (specialization, description)
                      await FirebaseFirestore.instance
                          .collection("Doctors")
                          .doc(widget.id)
                          .update({
                        "specialization": specialtyCtrl.text.trim(),
                        "hospital": hospitalCtrl.text.trim(),
                        "description": descCtrl.text.trim(),
                        // "bio": FieldValue.delete(), // (Tùy chọn) Xóa field cũ sai tên nếu muốn
                        // "specialty": FieldValue.delete(),
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("💾 Lưu Thay Đổi"),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
