import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_user_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usersRef = FirebaseFirestore.instance.collection('Users'); // CHỈNH ĐÚNG CHỮ HOA

    return Scaffold(
      appBar: AppBar(title: const Text("🧑‍💻 Quản lý Người dùng")),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("⚠ Chưa có người dùng nào trong hệ thống!"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final id = docs[index].id;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text("${data['first_name']} ${data['last_name']}"),
                  subtitle: Text("📧 ${data['email']}\nVai trò: ${data['role']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// EDIT
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditUserPage(userId: id, userData: data),
                          ),
                        ),
                      ),

                      /// DELETE
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, id),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Confirm delete
  /// Confirm delete
  void _confirmDelete(BuildContext context, String id) {showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("⚠ Xác nhận xoá"), // Có thể đổi thành "Xác nhận khóa"
      content: const Text("Bạn có chắc muốn xoá người dùng này không? Hành động này sẽ khóa quyền truy cập của họ."),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Huỷ")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            // 👇 SỬA Ở ĐÂY: Thay vì delete(), dùng update()
            await FirebaseFirestore.instance.collection("Users").doc(id).update({
              'isActive': false, // Đánh dấu là đã bị khóa/xóa
              // 'isDeleted': true, // Bạn có thể dùng tên trường tùy ý
            });

            if (context.mounted) {
              Navigator.pop(context); // Đóng hộp thoại
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã khóa người dùng thành công!")),
              );
            }
          },
          child: const Text("Xoá"),
        ),
      ],
    ),
  );
  }
}
