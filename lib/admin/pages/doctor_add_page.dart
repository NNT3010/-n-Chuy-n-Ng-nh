import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDoctorPage extends StatefulWidget {
  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  String? selectedUser;
  Map<String, dynamic>? selectedUserData;

  TextEditingController specialty = TextEditingController();
  TextEditingController hospital = TextEditingController();
  TextEditingController bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("➕ Thêm bác sĩ")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 LẤY USER ROLE = DOCTOR TỪ COLLECTION "Users"
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .where("role", isEqualTo: "Doctor")
                  .snapshots(),

              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Text("⚠ Không tìm thấy tài khoản Doctor");
                }

                final docs = snap.data!.docs;

                return DropdownButtonFormField<String>(
                  hint: const Text("👤 Chọn tài khoản bác sĩ"),
                  value: selectedUser,
                  items: docs.map((u) {
                    final data = u.data() as Map<String, dynamic>;

                    final fullName =
                    "${data['first_name'] ?? ''} ${data['last_name'] ?? ''}".trim();

                    return DropdownMenuItem(
                      value: u.id,
                      child: Text(fullName.isEmpty ? "Không tên" : fullName),
                      onTap: () => selectedUserData = data, // Lưu thông tin user
                    );
                  }).toList(),

                  onChanged: (v) => setState(() => selectedUser = v),
                );
              },
            ),

            const SizedBox(height: 12),
            TextField(
              controller: specialty,
              decoration: const InputDecoration(labelText: "🧬 Chuyên khoa"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hospital,
              decoration: const InputDecoration(labelText: "🏥 Bệnh viện"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bio,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "📃 Tiểu sử"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("💾 Lưu"),
              onPressed: () async {
                if (selectedUser == null || selectedUserData == null) return;

                /// 🔥 LẤY DỮ LIỆU USER ĐÃ CHỌN
                final String firstName = selectedUserData!["first_name"] ?? "";
                final String lastName  = selectedUserData!["last_name"] ?? "";
                final String email     = selectedUserData!["email"] ?? "";

                final String fullName = "$firstName $lastName".trim();

                /// 🔥 LƯU ĐẦY ĐỦ VÀ CHUẨN DỮ LIỆU VÀO "Doctors"
                await FirebaseFirestore.instance.collection("Doctors").add({
                  "userId": selectedUser,
                  "full_name": fullName,
                  "email": email,
                  "specialization": specialty.text,
                  "hospital": hospital.text,
                  "description": bio.text,
                  "is_active": true,
                  "created_at": DateTime.now(),
                });

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
