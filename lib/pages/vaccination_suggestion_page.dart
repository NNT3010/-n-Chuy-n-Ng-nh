import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/child_model.dart';

class VaccinationSuggestionPage extends StatelessWidget {
  const VaccinationSuggestionPage({super.key});

  /// 🔥 Gợi ý theo số tuần tuổi
  List<String> suggestVaccines(int ageWeeks) {
    if (ageWeeks < 6) return ["BCG", "Viêm gan B"];
    if (ageWeeks < 10) return ["DPT", "Polio", "Hib"];
    if (ageWeeks < 14) return ["DPT mũi 2", "Polio mũi 2", "Hib mũi 2"];
    if (ageWeeks < 52) return ["Sởi", "Viêm gan A"];
    return ["Nhắc DPT", "Nhắc lại Polio"];
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("💡 Đề Xuất Tiêm Chủng")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("children")
            .where("family_id", isEqualTo: uid)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("❗ Chưa có bé nào."));
          }

          final children = snap.data!.docs
              .map((d) => ChildModel.fromMap(d.data() as Map<String, dynamic>, d.id))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: children.map((child) {
              final dob = child.date_of_birth;

              if (dob == null) {
                return Card(
                  child: ListTile(
                    title: Text("👶 ${child.name}"),
                    subtitle: const Text("⚠ Chưa có ngày sinh — không thể đề xuất."),
                  ),
                );
              }

              final ageWeeks = (DateTime.now().difference(dob).inDays / 7).floor();
              final vaccines = suggestVaccines(ageWeeks);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "👶 ${child.name}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("Tuổi: $ageWeeks tuần"),
                      const SizedBox(height: 8),

                      const Text("📌 Đề xuất tiêm:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      ...vaccines.map(
                            (v) => ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                          title: Text(v),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
