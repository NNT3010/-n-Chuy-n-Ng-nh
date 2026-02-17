import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/doctor_model.dart';

class DoctorDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DoctorModel doctor =
    ModalRoute.of(context)!.settings.arguments as DoctorModel;

    return Scaffold(
      appBar: AppBar(title: Text("Thông tin bác sĩ")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên bác sĩ
                Text(
                  "👨‍⚕️ ${doctor.full_name ?? "Không rõ"}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                // Chuyên môn
                Text("Chuyên môn: ${doctor.specialization ?? "Không rõ"}"),
                Text("Bệnh viện: ${doctor.hospital ?? "Không rõ"}"),

                SizedBox(height: 15),

                // Mô tả
                Text(
                  "Tiểu sử:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(doctor.description ?? "Chưa có mô tả"),

                SizedBox(height: 30),

                // 🔵 Button gửi email liên hệ
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    final String email = doctor.email.trim();

                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("❌ Bác sĩ chưa có email")));
                      return;
                    }

                    // 🔥 1. Thử mở trực tiếp Gmail App (hoạt động tốt nhất trên Xiaomi)
                    final Uri gmailUri = Uri.parse(
                        "googlegmail:///co?to=$email&subject=" +
                            Uri.encodeComponent("Liên hệ tư vấn bác sĩ") +
                            "&body=" +
                            Uri.encodeComponent("Chào bác sĩ,")
                    );

                    if (await canLaunchUrl(gmailUri)) {
                      await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
                      return;
                    }

                    // 🔥 2. Nếu Gmail không mở được → fallback dùng mailto:
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: email,
                      query: Uri.encodeFull(
                        'subject=Liên hệ tư vấn bác sĩ&body=Chào bác sĩ,',
                      ),
                    );

                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Không thể mở ứng dụng Email trên thiết bị")),
                    );
                  },
                  child: Text("📧 Gửi email liên hệ"),
                ),

                SizedBox(height: 12),
                // 🟣 Button đặt lịch hẹn
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/bookAppointment',
                      arguments: doctor,
                    );
                  },
                  child: Text("📅 Đặt lịch hẹn"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
