import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/article_model.dart'; // Import model

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({Key? key}) : super(key: key);

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  bool _isPublished = true; // Mặc định là công khai
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Hàm chọn ảnh
  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  // Hàm xử lý đăng bài (Logic quan trọng nằm ở đây)
  // Hàm xử lý đăng bài (Đã nâng cấp để sửa lỗi)
  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    // 1. Kiểm tra đăng nhập
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi: Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.")),
      );
      return;
    }

    print("🔍 Đang kiểm tra user: ${user.email} (UID: ${user.uid})"); // Log kiểm tra

    setState(() => _isLoading = true);

    try {
      // ============================================================
      // 🟢 BƯỚC QUAN TRỌNG: TÌM DOCUMENT ID CỦA CHUYÊN GIA
      // ============================================================
      String expertIdToSave = user.uid; // Giá trị mặc định

      try {
        // CÁCH 1: Tìm theo trường 'e-mail' (như ảnh cũ của bạn)
        var expertQuery = await FirebaseFirestore.instance
            .collection('experts')
            .where('e-mail', isEqualTo: user.email)
            .limit(1)
            .get();

        // CÁCH 2: Nếu Cách 1 không thấy, tìm thử theo trường 'email' (chuẩn thông thường)
        if (expertQuery.docs.isEmpty) {
          print("⚠️ Không tìm thấy theo trường 'e-mail', thử tìm theo 'email'...");
          expertQuery = await FirebaseFirestore.instance
              .collection('experts')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();
        }

        if (expertQuery.docs.isNotEmpty) {
          expertIdToSave = expertQuery.docs.first.id;
          print("✅ Đã tìm thấy Expert ID khớp: $expertIdToSave");
        } else {
          print("❌ Vẫn không tìm thấy chuyên gia nào có email: ${user.email}");
          print("👉 Hãy vào Firestore > experts và kiểm tra xem đã có document nào chứa email này chưa.");
        }
      } catch (e) {
        print("⚠️ Lỗi khi truy vấn Expert ID: $e");
      }
      // ============================================================

      String? imageUrl;

      // 2. Upload ảnh lên Storage
      if (_imageFile != null) {
        String fileName = "articles/${DateTime.now().millisecondsSinceEpoch}.jpg";
        Reference ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(_imageFile!);
        imageUrl = await ref.getDownloadURL();
      }

      // 3. Tạo Object ArticleModel
      final newArticle = ArticleModel(
        expert_id: expertIdToSave,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _categoryController.text.trim(),
        image_url: imageUrl,
        is_published: _isPublished,
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
      );

      // 4. Lưu vào Firestore
      await FirebaseFirestore.instance.collection('articles').add(newArticle.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("📤 Đăng bài thành công!")));
        Navigator.pop(context);
      }
    } catch (e) {
      print("❌ Lỗi đăng bài: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📝 Viết bài mới"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nhập tiêu đề
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: "Tiêu đề bài viết (*)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                  hintText: "VD: Dinh dưỡng cho bé 6 tháng tuổi",
                ),
                validator: (val) => val == null || val.isEmpty ? "Vui lòng nhập tiêu đề" : null,
              ),
              const SizedBox(height: 16),

              // Nhập danh mục
              TextFormField(
                controller: _categoryController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: "Danh mục",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                  hintText: "VD: Dinh dưỡng, Bệnh lý, Tâm lý...",
                ),
              ),
              const SizedBox(height: 16),

              // Nội dung
              TextFormField(
                controller: _contentController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 12,
                decoration: const InputDecoration(
                  labelText: "Nội dung chi tiết (*)",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  hintText: "Nhập nội dung bài viết tại đây...",
                ),
                validator: (val) => val == null || val.isEmpty ? "Vui lòng nhập nội dung" : null,
              ),
              const SizedBox(height: 16),

              // Chọn ảnh
              const Text("Ảnh minh hoạ:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_imageFile!, fit: BoxFit.cover)
                  )
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, color: Colors.pinkAccent, size: 50),
                      SizedBox(height: 8),
                      Text("Nhấn để chọn ảnh từ thư viện", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Switch Published (Trạng thái đăng)
              Container(
                decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pink.shade100)
                ),
                child: SwitchListTile(
                  title: const Text("Công khai bài viết ngay?", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Nếu tắt, bài viết sẽ ở trạng thái Nháp."),
                  value: _isPublished,
                  activeColor: Colors.pinkAccent,
                  onChanged: (val) => setState(() => _isPublished = val),
                ),
              ),

              const SizedBox(height: 30),

              // Nút Đăng bài
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3
                  ),
                  onPressed: _submitPost,
                  icon: const Icon(Icons.send),
                  label: const Text("ĐĂNG BÀI VIẾT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
