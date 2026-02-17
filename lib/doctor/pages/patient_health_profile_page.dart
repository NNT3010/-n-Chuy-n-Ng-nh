// lib/pages/doctor/patient_health_profile_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PatientHealthProfilePage extends StatelessWidget {
  final String userId;
  final String userName;

  const PatientHealthProfilePage({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hồ sơ: $userName"),
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            isScrollable: true, // Cho phép cuộn nếu tab dài
            tabs: [
              Tab(text: "📏 Chỉ số phát triển", icon: Icon(Icons.show_chart)),
              Tab(text: "💉 Lịch tiêm chủng", icon: Icon(Icons.vaccines)),
              Tab(text: "📄 Hồ sơ sức khỏe", icon: Icon(Icons.history_edu)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGrowthRecords(),
            _buildVaccinationRecords(),
            _buildHealthRecords(),
          ],
        ),
      ),
    );
  }

  // 1. Tab Chỉ số phát triển (Growth)
  Widget _buildGrowthRecords() {
    return StreamBuilder<QuerySnapshot>(
      // ⚠️ Sửa tên collection cho đúng DB của bạn
      stream: FirebaseFirestore.instance
          .collection('growth_records')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text("Chưa có dữ liệu phát triển"));

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.height, color: Colors.green),
              title: Text("Ngày: ${_formatDate(data['date'])}"),
              subtitle: Text("Cao: ${data['height']}cm - Nặng: ${data['weight']}kg"),
            );
          },
        );
      },
    );
  }

  // 2. Tab Lịch tiêm chủng (Vaccination)
  Widget _buildVaccinationRecords() {
    return StreamBuilder<QuerySnapshot>(
      // ⚠️ Sửa tên collection cho đúng DB của bạn
      stream: FirebaseFirestore.instance
          .collection('vaccination_records')
          .where('userId', isEqualTo: userId)
          .orderBy('vaccination_date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text("Chưa có lịch tiêm chủng"));

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            bool isCompleted = data['is_completed'] ?? false;

            return ListTile(
              leading: Icon(
                isCompleted ? Icons.check_circle : Icons.pending,
                color: isCompleted ? Colors.green : Colors.orange,
              ),
              title: Text(data['vaccine_name'] ?? "Vắc xin"),
              subtitle: Text("Ngày tiêm: ${_formatDate(data['vaccination_date'])}"),
              trailing: isCompleted
                  ? const Text("Đã tiêm", style: TextStyle(color: Colors.green))
                  : const Text("Chưa tiêm", style: TextStyle(color: Colors.orange)),
            );
          },
        );
      },
    );
  }

  // 3. Tab Hồ sơ sức khỏe chung (Health Records)
  Widget _buildHealthRecords() {
    return StreamBuilder<QuerySnapshot>(
      // ⚠️ Sửa tên collection cho đúng DB của bạn
      stream: FirebaseFirestore.instance
          .collection('health_records')
          .where('userId', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text("Chưa có hồ sơ bệnh án"));

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(8),
              child: ExpansionTile(
                title: Text(data['title'] ?? "Bệnh án"),
                subtitle: Text("Ngày khám: ${_formatDate(data['created_at'])}"),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(data['details'] ?? "Không có chi tiết"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return "N/A";
    if (timestamp is Timestamp) {
      return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
    }
    return timestamp.toString();
  }
}
