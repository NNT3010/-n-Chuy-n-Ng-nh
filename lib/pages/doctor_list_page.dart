import 'package:flutter/material.dart';
import '../services/doctor_service.dart';
import '../models/doctor_model.dart';

class DoctorListPage extends StatelessWidget {
  final doctorService = DoctorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kết nối bác sĩ")),

      body: StreamBuilder<List<DoctorModel>>(
        stream: doctorService.getDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có bác sĩ nào"));
          }

          final doctors = snapshot.data!;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doc = doctors[index];

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.person, size: 40),
                  title: Text("👨‍⚕️ ${doc.full_name}"),
                  subtitle: Text(
                    "Chuyên môn: ${doc.specialization}\n"
                        "Bệnh viện: ${doc.hospital}",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),

                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/doctorDetail',
                      arguments: doc,   // Truyền nguyên object DoctorModel
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
