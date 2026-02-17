import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/expert_model.dart';

class EditExpertPage extends StatefulWidget {
  final ExpertModel expert;

  const EditExpertPage({Key? key, required this.expert}) : super(key: key);

  @override
  _EditExpertPageState createState() => _EditExpertPageState();
}

class _EditExpertPageState extends State<EditExpertPage> {
  File? newImage;
  final picker = ImagePicker();
  bool isLoading = false;

  late TextEditingController nameCtrl;
  late TextEditingController specCtrl;
  late TextEditingController degreeCtrl;
  late TextEditingController expCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.expert.full_name);
    specCtrl = TextEditingController(text: widget.expert.specialization);
    degreeCtrl = TextEditingController(text: widget.expert.degree);
    expCtrl = TextEditingController(text: widget.expert.experience_years.toString());
    bioCtrl = TextEditingController(text: widget.expert.biography);
    emailCtrl = TextEditingController(text: widget.expert.email);
    phoneCtrl = TextEditingController(text: widget.expert.phone);
  }

  Future pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => newImage = File(file.path));
  }

  Future updateExpert() async {
    setState(() => isLoading = true);

    String imgUrl = widget.expert.avatar_url ?? "";

    if (newImage != null) {
      try {
        var ref = FirebaseStorage.instance.ref("experts/${widget.expert.id}.jpg");
        await ref.putFile(newImage!);
        imgUrl = await ref.getDownloadURL();
      } catch (e) {
        debugPrint("Lỗi upload ảnh: $e");
      }
    }

    final updatedData = ExpertModel(
      id: widget.expert.id,
      full_name: nameCtrl.text,
      specialization: specCtrl.text,
      degree: degreeCtrl.text,
      experience_years: int.tryParse(expCtrl.text) ?? 0,
      biography: bioCtrl.text,
      email: emailCtrl.text,
      phone: phoneCtrl.text,
      avatar_url: imgUrl,
      created_at: widget.expert.created_at,
    ).toMap();

    await FirebaseFirestore.instance.collection("experts").doc(widget.expert.id).update(updatedData);

    setState(() => isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✏ Sửa Chuyên Gia")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          Center(
            child: GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: newImage != null
                    ? FileImage(newImage!)
                    : (widget.expert.avatar_url != null && widget.expert.avatar_url!.isNotEmpty)
                    ? NetworkImage(widget.expert.avatar_url!) as ImageProvider
                    : null,
                child: (newImage == null && (widget.expert.avatar_url == null || widget.expert.avatar_url!.isEmpty))
                    ? const Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Họ tên", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: specCtrl, decoration: const InputDecoration(labelText: "Chuyên môn", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: degreeCtrl, decoration: const InputDecoration(labelText: "Bằng cấp", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: expCtrl, decoration: const InputDecoration(labelText: "Kinh nghiệm (năm)", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: bioCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Tiểu sử", border: OutlineInputBorder())),

          const SizedBox(height: 20),
          ElevatedButton(onPressed: updateExpert, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), child: const Text("💾 Cập nhật", style: TextStyle(color: Colors.white)))
        ]),
      ),
    );
  }
}
