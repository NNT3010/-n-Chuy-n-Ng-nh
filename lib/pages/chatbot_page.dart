import 'dart:convert';
import 'dart:io'; // 1. Import thư viện này để xử lý SSL
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 2. Class để bỏ qua lỗi chứng chỉ SSL (fix lỗi HandshakeException)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // Thêm ScrollController để tự cuộn
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _apiUrl = "https://johna-unpliant-punctually.ngrok-free.dev/api/GeminiProxy/generate";

  @override
  void initState() {
    super.initState();
    // 3. Kích hoạt override SSL ngay khi vào màn hình này (Nếu chưa làm ở main.dart)
    HttpOverrides.global = MyHttpOverrides();
  }

  // Hàm cuộn xuống cuối danh sách tin nhắn
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom(); // Cuộn xuống khi gửi tin

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '69420', // Header quan trọng
        },
        body: jsonEncode({
          'prompt': text,
          'model': 'gemini-1.5-flash'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['output'] ?? 'Xin lỗi, tôi chưa hiểu câu hỏi này.';

        setState(() {
          _messages.add({'role': 'bot', 'content': reply});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'bot',
            'content': '⚠️ Lỗi máy chủ: ${response.statusCode}'
          });
        });
      }
    } catch (e) {
      // In lỗi chi tiết ra console để debug
      debugPrint("Lỗi Chatbot: $e");
      setState(() {
        _messages.add({
          'role': 'bot',
          'content': '❌ Lỗi kết nối: $e' // Hiển thị lỗi cụ thể lên màn hình
        });
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom(); // Cuộn xuống khi nhận tin xong
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot AI - Hỗ trợ mẹ & bé'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Gắn controller vào đây
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.pink[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['content']!),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập câu hỏi...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => sendMessage(), // Gửi khi nhấn Enter
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: _isLoading ? null : sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
