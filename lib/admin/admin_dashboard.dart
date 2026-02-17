import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Nhớ thêm thư viện này
import '../admin/pages/edit_user_page.dart';
import 'package:flutter/material.dart';
import '../admin/pages/admin_messages_page.dart';



class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Hàm xử lý đăng xuất
  void _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn thoát phiên làm việc?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // Đăng xuất khỏi Firebase
              await FirebaseAuth.instance.signOut();

              // Đóng dialog
              Navigator.pop(context);

              // Chuyển hướng về màn hình đăng nhập (giả sử route là '/login' hoặc '/')
              // Xóa hết lịch sử back để không quay lại được admin
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F6),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text("Admin Dashboard - MeBeCare"),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.pinkAccent),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "MENU ADMIN",
                  style: TextStyle(fontSize: 22, color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),

            menuTile("🧑‍💻 Quản lý Người dùng", "/admin"),
            menuTile("💉 Lịch tiêm chủng", "/admin/vaccinations"),
            menuTile("📈 Chỉ số phát triển", "/admin/growth"),
            menuTile("🩺 Danh sách Bác sĩ", "/admin/doctors"),
            menuTile("🏥 Dịch vụ y tế", "/admin/services"),
            menuTile("👨‍⚕️ Chuyên gia", "/admin/experts"),
            menuTile("📝 Bài viết", "/admin/articles"),
            // 👇 SỬA PHẦN GỌI MENU TIN NHẮN
            ListTile(
              title: const Text("📬 Tin nhắn liên hệ", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context); // Đóng drawer
                // Chuyển sang trang danh sách tin nhắn
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminMessagesPage())
                );
              },
            ),

            // =========================================
            // 👇 THÊM NÚT ĐĂNG XUẤT Ở ĐÂY
            // =========================================
            const Divider(), // Đường kẻ ngăn cách cho đẹp
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Đăng xuất",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Đóng menu trước
                Navigator.pop(context);
                // Gọi hàm đăng xuất
                _handleLogout();
              },
            ),
            const SizedBox(height: 20), // Khoảng trống dưới cùng
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("🛠️ Quản lý Người dùng", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Xin chào, Admin 👋", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db.collection("Users").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  var users = snapshot.data!.docs;

                  if (users.isEmpty) {
                    return const Center(child: Text("⚠ Chưa có người dùng nào!"));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("👤 Họ tên")),
                        DataColumn(label: Text("📧 Email")),
                        DataColumn(label: Text("🔐 Vai trò")),
                        DataColumn(label: Text("⚙ Hành động")),
                      ],
                      rows: users.map((user) {
                        var data = user.data() as Map<String, dynamic>;

                        return DataRow(cells: [

                          DataCell(Text("${data['first_name']} ${data['last_name']}")),
                          DataCell(Text(data['email'] ?? "—")),
                          DataCell(Text(data['role'] ?? "Không xác định")),

                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditUserPage(
                                      userId: user.id,
                                      userData: data,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => confirmDelete(user.id)
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuTile(String title, String route) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("⚠ Xóa người dùng?"),
        content: const Text("Hành động này không thể hoàn tác."),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance.collection("Users").doc(id).delete();
              Navigator.pop(context);
            },
            child: const Text("Xóa"),
          )
        ],
      ),
    );
  }
}
