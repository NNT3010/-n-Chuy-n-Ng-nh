import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String userId; // ID của người dùng (Khách hàng)
  final String userName; // Tên người dùng
  final bool isAdminView; // True nếu người đang xem là Admin

  const ChatScreen({
    Key? key,
    required this.userId,
    required this.userName,
    this.isAdminView = false,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Gửi tin nhắn
  void _sendMessage() async {
    if (_msgController.text.trim().isEmpty) return;

    String msg = _msgController.text.trim();
    _msgController.clear();

    final timestamp = DateTime.now();

    // 1. Lưu tin nhắn vào sub-collection 'messages'
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.userId) // Luôn dùng userId làm ID của cuộc trò chuyện
        .collection('messages')
        .add({
      'text': msg,
      'senderId': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': timestamp,
      'isAdmin': widget.isAdminView, // Đánh dấu tin này do Admin hay User gửi
    });

    // 2. Cập nhật tin nhắn cuối cùng ở collection cha 'chats' (để hiện ra list Admin)
    await FirebaseFirestore.instance.collection('chats').doc(widget.userId).set({
      'lastMessage': msg,
      'lastTime': timestamp,
      'userName': widget.userName,
      'userId': widget.userId,
      'isRead': false, // Đánh dấu là chưa đọc
    }, SetOptions(merge: true));

    // Cuộn xuống cuối
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdminView ? "Chat với ${widget.userName}" : "Liên hệ Admin"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.userId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true, // Tin mới nhất ở dưới cùng
                  controller: _scrollController,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == FirebaseAuth.instance.currentUser?.uid;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.pinkAccent : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['text'] ?? '',
                              style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['timestamp'] != null
                                  ? DateFormat('HH:mm').format((data['timestamp'] as Timestamp).toDate())
                                  : '',
                              style: TextStyle(
                                fontSize: 10,
                                color: isMe ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Ô nhập tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.pinkAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
