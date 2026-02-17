import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/medical_record_model.dart';
import '../services/medical_record_service.dart';

import 'medical_record_create.dart';
import 'medical_record_edit.dart';
import 'growth_Index_With_Bmi.dart';
import 'vaccination_page.dart';

class MedicalRecordPage extends StatefulWidget {
  const MedicalRecordPage({super.key});

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {

  /// 🔥 Lấy tên bé theo child_id
  Future<String> _getChildName(String childId) async {
    final snap = await FirebaseFirestore.instance
        .collection("children")
        .doc(childId)
        .get();

    return snap.data()?["name"] ?? "Không rõ tên";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Bạn chưa đăng nhập")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🩺 Hồ sơ Sức Khỏe Mẹ và Bé",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // ============================
          // 🔥 BUTTON ACTION TRÊN ĐẦU
          // ============================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.local_hospital, color: Colors.pink),
                  label: const Text("Lịch tiêm chủng"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.pink),
                    foregroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const VaccinationPage()));
                  },
                ),

                OutlinedButton.icon(
                  icon: const Icon(Icons.straighten, color: Colors.pink),
                  label: const Text("Chỉ số phát triển"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.pink),
                    foregroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const GrowthIndexPage()));
                  },
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Thêm hồ sơ", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MedicalRecordCreate()),
                    );
                    setState(() {});
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ============================
          // 🔥 DANH SÁCH HỒ SƠ
          // ============================
          Expanded(
            child: StreamBuilder<List<MedicalRecordModel>>(
              stream: MedicalRecordService().getUserRecords(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Chưa có hồ sơ nào"));
                }

                final records = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];

                    String icon = switch (record.diagnosis) {
                      "Allergy" => "🤧",
                      "Condition" => "🩺",
                      "Medication" => "💊",
                      "Vaccination" => "💉",
                      "Growth" => "📈",
                      _ => "📁"
                    };

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          "$icon  ${record.diagnosis ?? 'Không rõ'}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        /// 🔥 SUBTITLE HIỂN THỊ TÊN BÉ
                        subtitle: record.child_id == null
                            ? Text("🤱 Mẹ\n${record.treatment ?? ''}")
                            : FutureBuilder<String>(
                          future: _getChildName(record.child_id!),
                          builder: (context, childSnap) {
                            if (!childSnap.hasData) {
                              return const Text("👶 Bé: đang tải...");
                            }

                            return Text(
                              "👶 Bé: ${childSnap.data}\n${record.treatment ?? ''}",
                            );
                          },
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MedicalRecordEdit(record: record),
                              ),
                            );
                            setState(() {});
                          },
                        ),

                        onLongPress: () async {
                          if (record.id == null) return;
                          await MedicalRecordService().deleteRecord(record.id!);
                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
