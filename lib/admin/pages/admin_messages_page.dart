import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mebecare/pages/chat_screen.dart';

class AdminMessagesPage extends StatelessWidget {
  const AdminMessagesPage({Key? key}) : super(key: key);

  // 🔥 Hàm xử lý xóa đoạn chat
  Future<void> _deleteChat(BuildContext context, String userId) async {
    try {
      // 1. Xác nhận trước khi xóa
      bool confirm = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Xóa đoạn chat?"),
          content: const Text("Hành động này không thể hoàn tác. Tất cả tin nhắn với người dùng này sẽ bị xóa."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Xóa", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ?? false;

      if (!confirm) return;

      // 2. Xóa Sub-collection 'messages' trước (Firestore không tự xóa sub-collection khi xóa cha)
      // Lưu ý: Client SDK không hỗ trợ xóa cả sub-collection 1 lúc, ta phải loop xóa từng cái
      // Hoặc nếu ít tin nhắn thì xóa document cha 'chats/{userId}' là đủ để ẩn khỏi list,
      // nhưng để sạch data thì nên xóa như sau:

      final messagesRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(userId)
          .collection('messages');

      var snapshots = await messagesRef.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      // 3. Xóa Document cha trong 'chats'
      await FirebaseFirestore.instance.collection('chats').doc(userId).delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã xóa đoạn chat thành công")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi xóa: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📬 Tin nhắn liên hệ"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('lastTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Chưa có tin nhắn nào từ người dùng.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final userId = docs[index].id;
              final userName = data['userName'] ?? 'Người dùng';
              final lastMessage = data['lastMessage'] ?? '';
              final lastTime = data['lastTime'] as Timestamp?;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink[100],
                    child: Text(
                      (userName.isNotEmpty ? userName[0] : '?').toUpperCase(),
                      style: const TextStyle(color: Colors.pink),
                    ),
                  ),
                  title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.normal),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Hiển thị thời gian
                      Text(
                        lastTime != null
                            ? DateFormat('dd/MM HH:mm').format(lastTime.toDate())
                            : '',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      // 🔥 Nút xóa
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteChat(context, userId),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          userId: userId,
                          userName: userName,
                          isAdminView: true,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
