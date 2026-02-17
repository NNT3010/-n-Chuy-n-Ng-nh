import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'patient_health_profile_page.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class DoctorAppointmentListPage extends StatefulWidget {
  const DoctorAppointmentListPage({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentListPage> createState() => _DoctorAppointmentListPageState();
}

class _DoctorAppointmentListPageState extends State<DoctorAppointmentListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? realDoctorId; // Biến để lưu ID thật của bác sĩ (Qts11...)
  bool isLoadingDoctorId = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getRealDoctorId(); // Gọi hàm lấy ID khi màn hình mở
  }

  // 🔥 HÀM QUAN TRỌNG: Tìm DoctorID dựa trên UserID đăng nhập
  Future<void> _getRealDoctorId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Tìm trong bảng Doctors xem bác sĩ nào có userId trùng với người đang đăng nhập
        final querySnapshot = await FirebaseFirestore.instance
            .collection('Doctors')
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            realDoctorId = querySnapshot.docs.first.id; // Lấy ID Qts11...
            isLoadingDoctorId = false;
          });
          print("✅ Đã tìm thấy Doctor ID thật: $realDoctorId");
        } else {
          print("❌ Không tìm thấy hồ sơ bác sĩ nào liên kết với tài khoản này.");
          setState(() => isLoadingDoctorId = false);
        }
      } catch (e) {
        print("❌ Lỗi khi tìm Doctor ID: $e");
        setState(() => isLoadingDoctorId = false);
      }
    }
  }

  Future<void> _updateStatus(String appointmentId, String newStatus, Map<String, dynamic> appointmentData) async {
    try {
      // 1. Cập nhật Firestore trước
      await FirebaseFirestore.instance.collection('Appointments').doc(appointmentId).update({
        'status': newStatus,
        'updatedAt': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã chuyển trạng thái: $newStatus")));

      // 2. Lấy thông tin User để gửi mail
      String userId = appointmentData['userId'];

      // Format ngày giờ để hiển thị trong mail
      String dateStr = "N/A";
      if (appointmentData['appointmentDate'] != null) {
        dateStr = DateFormat('HH:mm - dd/MM/yyyy').format((appointmentData['appointmentDate'] as Timestamp).toDate());
      }

      // Lấy Email từ bảng Users
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? email = userData['email'];
        String name = userData['full_name'] ?? "Quý khách";

        if (email != null && email.isNotEmpty) {
          // 🔥 Gửi mail
          _sendEmailNotification(email, name, newStatus, dateStr).then((_) {
            print("Gửi mail xong");
          }).catchError((err) {
            print("Lỗi gửi mail ngầm: $err");
          });
        } else {
          print("User này không có email để gửi.");
        }
      }

    } catch (e) {
      print("Lỗi cập nhật hoặc gửi mail: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    }
  }


  // 🔥 Hàm gửi Email thông báo
  Future<void> _sendEmailNotification(String userEmail, String userName, String status, String date) async {
    // ⚠️ Thay bằng Email và Mật khẩu ứng dụng của bạn
    String username = 'mebecare.notify@gmail.com';
    String password = 'dvvx rzuc ptqn rebw';

    final smtpServer = gmail(username, password);

    // Nội dung email
    String statusText = status == 'confirmed' ? "ĐÃ ĐƯỢC XÁC NHẬN ✅" : "ĐÃ BỊ HỦY ❌";
    String bodyText = '''
    Xin chào $userName,
    
    Lịch hẹn khám của bạn vào lúc $date đã được bác sĩ cập nhật trạng thái:
    
    👉 TRẠNG THÁI: $statusText
    
    Vui lòng kiểm tra ứng dụng MeBeCare để biết thêm chi tiết.
    
    Trân trọng,
    Đội ngũ MeBeCare.
    ''';

    final message = Message()
      ..from = Address(username, 'MeBeCare Notification')
      ..recipients.add(userEmail)
      ..subject = 'Thông báo Lịch hẹn MeBeCare: $statusText'
      ..text = bodyText;

    try {
      await send(message, smtpServer);
      print('📧 Email đã được gửi thành công tới $userEmail');
    } catch (e) {
      print('❌ Lỗi khi gửi email: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    // 1. Đang tải ID bác sĩ
    if (isLoadingDoctorId) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.blue)));
    }

    // 2. Nếu không tìm thấy hồ sơ bác sĩ
    if (realDoctorId == null) {
      return const Scaffold(
        body: Center(
          child: Text("Lỗi: Tài khoản này chưa có hồ sơ Bác sĩ (trong bảng Doctors)."),
        ),
      );
    }

    // 3. Có ID rồi thì hiển thị danh sách
    return Scaffold(
      appBar: AppBar(
        title: const Text("📅 Quản lý Lịch hẹn"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Chờ duyệt"),
            Tab(text: "Đã xác nhận"),
            Tab(text: "Đã hủy"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Truyền realDoctorId (Qts11...) vào thay vì user.uid
          _buildAppointmentList(realDoctorId!, 'pending'),
          _buildAppointmentList(realDoctorId!, 'confirmed'),
          _buildAppointmentList(realDoctorId!, 'cancelled'),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(String doctorId, String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Appointments')
          .where('doctorId', isEqualTo: doctorId) // Bây giờ ID này đã khớp với Database
          .where('status', isEqualTo: status)
          .orderBy('appointmentDate', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text("Lỗi: ${snapshot.error}"));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.calendar_today_outlined, size: 50, color: Colors.grey[300]),
            Text("Không có lịch hẹn ($status)", style: TextStyle(color: Colors.grey)),
          ]));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>; // Đây là biến data cần truyền
            final String docId = doc.id;
            final String userId = data['userId'] ?? '';

            // Format ngày giờ
            String dateDisplay = "Chưa có ngày";
            if (data['appointmentDate'] != null && data['appointmentDate'] is Timestamp) {
              dateDisplay = DateFormat('HH:mm - dd/MM/yyyy').format((data['appointmentDate'] as Timestamp).toDate());
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dateDisplay, style: const TextStyle(fontWeight: FontWeight.bold)),
                        _buildStatusChip(status)
                      ],
                    ),
                    const Divider(),
                    _UserFetcher(userId: userId),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[100],
                        width: double.infinity,
                        child: Text("📝 ${data['notes'] ?? 'Không ghi chú'}", style: const TextStyle(fontStyle: FontStyle.italic))
                    ),
                    if (status == 'pending') ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: OutlinedButton(
                            // 👇 ĐÃ SỬA: Truyền thêm biến 'data' vào cuối
                              onPressed: ()=> _confirmAction(docId, 'cancelled', data),
                              child: const Text("Từ chối", style: TextStyle(color: Colors.red))
                          )),
                          const SizedBox(width: 10),
                          Expanded(child: ElevatedButton(
                            // 👇 ĐÃ SỬA: Truyền thêm biến 'data' vào cuối
                              onPressed: ()=> _confirmAction(docId, 'confirmed', data),
                              child: const Text("Xác nhận")
                          )),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmAction(String docId, String action, Map<String, dynamic> data) { // 👈 Thêm tham số data
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("Xác nhận?"),
      content: Text(action == 'confirmed' ? "Duyệt lịch hẹn này?" : "Hủy lịch hẹn này?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
        TextButton(onPressed: () {
          Navigator.pop(ctx);
          _updateStatus(docId, action, data); // 👈 Truyền tiếp data vào đây
        }, child: const Text("Đồng ý")),
      ],
    ));
  }


  Widget _buildStatusChip(String status) {
    Color color = status == 'confirmed' ? Colors.green : (status == 'cancelled' ? Colors.red : Colors.orange);
    return Text(status == 'confirmed' ? "Đã xác nhận" : (status == 'cancelled' ? "Đã hủy" : "Chờ duyệt"),
        style: TextStyle(color: color, fontWeight: FontWeight.bold));
  }
}

class _UserFetcher extends StatelessWidget {
  final String userId;
  const _UserFetcher({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("...");
        var data = snapshot.data!.data() as Map<String, dynamic>?;
        return Text("Bệnh nhân: ${data?['full_name'] ?? 'Ẩn danh'}", style: const TextStyle(fontSize: 16));
      },
    );
  }
}
