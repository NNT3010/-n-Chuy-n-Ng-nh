import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/article_model.dart'; // Import model

class EditArticlePage extends StatefulWidget {
  final ArticleModel article;
  const EditArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _categoryController;

  File? _newImageFile;
  bool _isLoading = false;
  bool _isPublished = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Điền dữ liệu cũ vào form
    _titleController = TextEditingController(text: widget.article.title);
    _contentController = TextEditingController(text: widget.article.content);
    _categoryController = TextEditingController(text: widget.article.category);
    _isPublished = widget.article.is_published ?? false;
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _newImageFile = File(picked.path));
    }
  }

  Future<void> _updatePost() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String? imageUrl = widget.article.image_url;

      // Upload ảnh mới nếu có
      if (_newImageFile != null) {
        String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
        Reference ref = FirebaseStorage.instance.ref().child('articles/$fileName');
        await ref.putFile(_newImageFile!);
        imageUrl = await ref.getDownloadURL();
      }

      // Cập nhật vào Firestore
      // Lưu ý: Cập nhật cả trường updated_at
      await FirebaseFirestore.instance.collection('articles').doc(widget.article.id).update({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'category': _categoryController.text.trim(),
        'image_url': imageUrl,
        'is_published': _isPublished,
        'updated_at': DateTime.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("💾 Cập nhật thành công!")));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✏️ Chỉnh sửa bài viết"), backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Tiêu đề", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Không để trống tiêu đề" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Danh mục", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: const InputDecoration(labelText: "Nội dung", alignLabelWithHint: true, border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? "Không để trống nội dung" : null,
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _newImageFile != null
                      ? Image.file(_newImageFile!, fit: BoxFit.cover)
                      : (widget.article.image_url != null && widget.article.image_url!.isNotEmpty
                      ? Image.network(widget.article.image_url!, fit: BoxFit.cover)
                      : const Center(child: Text("Chưa có ảnh (Nhấn để thêm)"))),
                ),
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text("Trạng thái: Công khai"),
                value: _isPublished,
                activeColor: Colors.pinkAccent,
                onChanged: (val) => setState(() => _isPublished = val),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updatePost,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50)
                ),
                child: const Text("LƯU THAY ĐỔI"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
