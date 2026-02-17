// lib/doctor/pages/doctor_main_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../pages/login_page.dart'; // 👈 Import trang Login để điều hướng về
import 'doctor_appointment_list_page.dart';

class DoctorMainPage extends StatefulWidget {
  const DoctorMainPage({Key? key}) : super(key: key);

  @override
  State<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  int _currentIndex = 0;

  // Danh sách các màn hình chính của Bác sĩ
  final List<Widget> _pages = [
    const DoctorAppointmentListPage(), // Trang quản lý lịch hẹn
    const Center(child: Text("Danh sách bệnh nhân (Đang phát triển)")),
    const Center(child: Text("Cài đặt tài khoản (Đang phát triển)")),
  ];

  // 🔥 Thêm danh sách tiêu đề cho AppBar
  final List<String> _pageTitles = [
    "Quản lý Lịch hẹn",
    "Danh sách Bệnh nhân",
    "Cài đặt",
  ];

  // 🔥 Hàm xử lý đăng xuất
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // Quay về trang Login và xóa hết các trang cũ
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 Thêm AppBar
      appBar: AppBar(
        title: Text(_pageTitles[_currentIndex]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Ẩn nút back
        actions: [
          // 🔥 Nút đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              // Hiển thị hộp thoại xác nhận trước khi đăng xuất
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('Xác nhận Đăng xuất'),
                    content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(), // Đóng dialog
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(); // Đóng dialog
                          _logout(); // Gọi hàm đăng xuất
                        },
                        child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Lịch hẹn",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Bệnh nhân",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Cài đặt",
          ),
        ],
      ),
    );
  }
}
