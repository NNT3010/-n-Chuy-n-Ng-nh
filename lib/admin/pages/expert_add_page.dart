import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/expert_model.dart';

class AddExpertPage extends StatefulWidget {
  @override
  _AddExpertPageState createState() => _AddExpertPageState();
}

class _AddExpertPageState extends State<AddExpertPage> {
  File? imageFile;
  final picker = ImagePicker();
  bool isLoading = false;

  // Biến lưu User ID được chọn từ dropdown
  String? selectedUserId;

  // Controllers
  final nameCtrl = TextEditingController();
  final specCtrl = TextEditingController();
  final degreeCtrl = TextEditingController();
  final expCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  Future saveExpert() async {
    // Kiểm tra dữ liệu đầu vào
    if (nameCtrl.text.isEmpty || specCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng nhập tên và chuyên môn")));
      return;
    }

    setState(() => isLoading = true);

    String imgUrl = "";
    // Xử lý upload ảnh
    if (imageFile != null) {
      try {
        var ref = FirebaseStorage.instance.ref("experts/${DateTime.now().millisecondsSinceEpoch}.jpg");
        await ref.putFile(imageFile!);
        imgUrl = await ref.getDownloadURL();
      } catch (e) {
        debugPrint("Lỗi upload ảnh: $e");
      }
    }

    // Tạo model
    final newExpert = ExpertModel(
      // Nếu muốn lưu ID của user gốc vào expert, bạn có thể thêm trường userId vào ExpertModel
      // ở đây tôi tạm dùng các trường text đã có.
      full_name: nameCtrl.text,
      specialization: specCtrl.text,
      degree: degreeCtrl.text,
      experience_years: int.tryParse(expCtrl.text) ?? 0,
      biography: bioCtrl.text,
      email: emailCtrl.text,
      phone: phoneCtrl.text,
      avatar_url: imgUrl,
      created_at: DateTime.now(),
    );

    // Lưu vào Firestore
    await FirebaseFirestore.instance.collection("experts").add(newExpert.toMap());

    setState(() => isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("➕ Thêm Chuyên Gia")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          // 1. ẢNH ĐẠI DIỆN
          Center(
            child: GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. DROPDOWN CHỌN USER (THAY VÌ NHẬP TÊN THỦ CÔNG)
          const Text("Chọn tài khoản từ hệ thống:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            // ⚠️ LƯU Ý: Kiểm tra chữ hoa/thường của collection 'Users' và field 'role'
            // trong database của bạn cho khớp. Ở đây tôi để 'Users' và 'expert'.
            stream: FirebaseFirestore.instance
                .collection('Users')
                .where('role', whereIn: ['expert', 'Expert']) // Chấp nhận cả 'expert' và 'Expert'
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var userDocs = snapshot.data!.docs;

              if (userDocs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Text("⚠ Không tìm thấy tài khoản nào có quyền 'Expert'"),
                );
              }

              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  labelText: "Chọn Chuyên gia",
                ),
                value: selectedUserId,
                items: userDocs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  String fullName = "${data['first_name'] ?? ''} ${data['last_name'] ?? ''}".trim();
                  if (fullName.isEmpty) fullName = data['email'] ?? "Không tên";

                  return DropdownMenuItem<String>(
                    value: doc.id,
                    child: Text(
                      fullName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedUserId = val;

                    // Tìm data của user vừa chọn để tự điền vào các ô
                    var selectedDoc = userDocs.firstWhere((d) => d.id == val);
                    var data = selectedDoc.data() as Map<String, dynamic>;

                    // Tự động điền tên
                    nameCtrl.text = "${data['first_name'] ?? ''} ${data['last_name'] ?? ''}".trim();
                    // Tự động điền email
                    emailCtrl.text = data['email'] ?? '';
                    // Tự động điền SĐT (nếu có trong User collection)
                    if (data.containsKey('phone')) {
                      phoneCtrl.text = data['phone'];
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(height: 20),

          // 3. CÁC TRƯỜNG NHẬP LIỆU CHI TIẾT
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
                labelText: "Họ và tên (*)",
                border: OutlineInputBorder(),
                helperText: "Có thể chỉnh sửa sau khi chọn từ danh sách"
            ),
          ),
          const SizedBox(height: 12),

          TextField(
              controller: specCtrl,
              decoration: const InputDecoration(labelText: "Chuyên môn (*)", border: OutlineInputBorder())
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                  child: TextField(
                      controller: degreeCtrl,
                      decoration: const InputDecoration(labelText: "Bằng cấp", border: OutlineInputBorder()))),
              const SizedBox(width: 10),
              Expanded(
                  child: TextField(
                      controller: expCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Số năm KN", border: OutlineInputBorder()))),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email liên hệ", border: OutlineInputBorder())
          ),
          const SizedBox(height: 12),

          TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "SĐT liên hệ", border: OutlineInputBorder())
          ),
          const SizedBox(height: 12),

          TextField(
              controller: bioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Tiểu sử", border: OutlineInputBorder())
          ),

          const SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.pinkAccent),
              onPressed: saveExpert,
              child: const Text("💾 LƯU CHUYÊN GIA",
                  style: TextStyle(color: Colors.white, fontSize: 16)))
        ]),
      ),
    );
  }
}
