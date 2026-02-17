import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';import 'register_page.dart';
import 'home_page.dart';
// Import trang Dashboard
import '../expert/pages/expert_dashboard_page.dart';
import '../doctor/pages/doctor_main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final authService = AuthService();
  bool loading = false;

  // --- HỘP THOẠI QUÊN MẬT KHẨU ---
  void _showForgotPasswordDialog() {
    final resetEmailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đặt lại mật khẩu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nhập email để nhận liên kết đặt lại mật khẩu:'),
            const SizedBox(height: 10),
            TextField(
              controller: resetEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.pink),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6F91),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final email = resetEmailCtrl.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập email!')),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đang gửi yêu cầu...')),
              );
              final error = await authService.sendPasswordResetEmail(email);
              if (mounted) {
                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã gửi email! Kiểm tra hộp thư của bạn.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $error'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  // --- HÀM PHỤ TRỢ: XỬ LÝ KHI TÀI KHOẢN BỊ KHÓA/XÓA ---
  Future<void> _handleLockedUser() async {
    await authService.logout(); // Đăng xuất ngay lập tức
    setState(() => loading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚫 Tài khoản của bạn đã bị khóa hoặc không tồn tại!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  // --- LOGIC ĐĂNG NHẬP CHÍNH ---
  void login() async {
    setState(() => loading = true);

    // 1. Đăng nhập vào Firebase Authentication
    final error = await authService.login(emailCtrl.text.trim(), passwordCtrl.text.trim());

    if (error == null) {
      // 2. Lấy User ID hiện tại
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        try {
          // Đọc dữ liệu từ Firestore để kiểm tra trạng thái
          final userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.uid)
              .get();

          // TH1: Document tồn tại (Người dùng bình thường hoặc bị khóa mềm)
          if (userDoc.exists) {
            final data = userDoc.data() as Map<String, dynamic>;

            // Kiểm tra cờ isActive (Mặc định là true nếu không tìm thấy)
            bool isActive = data.containsKey('isActive') ? data['isActive'] : true;

            if (!isActive) {
              await _handleLockedUser(); // Bị khóa (isActive = false)
              return; // Dừng, không cho đăng nhập
            }
          }
          // TH2: Document KHÔNG tồn tại (Đã bị Admin xóa cứng bằng lệnh delete)
          else {
            await _handleLockedUser();
            return; // Dừng, không cho đăng nhập
          }

        } catch (e) {
          print("Lỗi đọc dữ liệu user: $e");
          // Nếu lỗi mạng hoặc lỗi lạ, có thể chọn cho qua hoặc chặn tùy ý.
          // Ở đây mình cho qua để tránh lỗi app nếu mạng yếu.
        }
      }

      // 3. Nếu tài khoản OK (Active), tiếp tục phân quyền
      final role = await authService.getUserRole();
      final String? userRole = role?.toLowerCase().trim();

      setState(() => loading = false);

      if (!mounted) return;

      // Phân quyền và chuyển trang
      if (userRole == "admin") {
        Navigator.pushReplacementNamed(context, "/admin");
      } else if (userRole == "doctor" || userRole == "bác sĩ") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorMainPage()),
        );
      } else if (userRole == "expert" || userRole == "chuyên gia") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ExpertDashboardPage())
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      // Đăng nhập thất bại (Sai pass, sai email...)
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const Icon(
                Icons.favorite_rounded,
                size: 80,
                color: Color(0xFFFF6F91),
              ),
              const SizedBox(height: 16),
              const Text(
                "MeBeCare",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6F91),
                ),
              ),
              const SizedBox(height: 32),

              // Khung Login
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_rounded, color: Colors.pink),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock_rounded, color: Colors.pink),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    // Nút Quên mật khẩu
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Nút Đăng nhập
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color(0xFFFF6F91),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: loading ? null : login,
                        child: loading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Chưa có tài khoản? Đăng ký ngay',
                        style: TextStyle(color: Colors.pink),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
