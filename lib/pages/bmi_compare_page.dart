import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/child_service.dart';
import '../services/growth_service.dart';
import '../models/child_model.dart';
import '../models/growth_record_model.dart';

import '../utils/bmi_vn_table.dart';
import 'dart:math';
import '../utils/who_lms_sample.dart';


class BmiComparePage extends StatelessWidget {
  final String childId;

  const BmiComparePage({super.key, required this.childId});

  double? _calcBMI(double? w, double? h) {
    if (w == null || h == null || h == 0) return null;
    final m = h / 100;
    return double.tryParse((w / (m * m)).toStringAsFixed(2));
  }

  int _months(DateTime dob) {
    final now = DateTime.now();
    int months = (now.year - dob.year) * 12 + (now.month - dob.month);
    if (now.day < dob.day) months--;
    if (months < 0) months = 0;
    return months;
  }

  String classify(double real, double vnStd, double whoStd) {
    if (real < vnStd * 0.9) return "⚠️ Bé có dấu hiệu gầy";
    if (real > vnStd * 1.15) return "⚠️ Bé có dấu hiệu thừa cân";
    return "✅ Bé có BMI bình thường theo chuẩn";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("⚖️ So sánh BMI")),
      body: FutureBuilder<ChildModel?>(
        future: ChildService().getChildById(childId),
        builder: (context, snapChild) {
          if (!snapChild.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final child = snapChild.data!;
          final dob = child.date_of_birth;

          if (dob == null) {
            return const Center(child: Text("Bé chưa có ngày sinh → không thể tính BMI"));
          }

          final months = _months(dob);

          return FutureBuilder<List<GrowthRecordModel>>(
            future: GrowthService().getLatestRecord(childId),
            builder: (context, snapRec) {
              if (!snapRec.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapRec.data!.isEmpty) {
                return const Center(child: Text("Bé chưa có chỉ số để tính BMI."));
              }

              final r = snapRec.data!.first;

              final bmi = _calcBMI(r.weight, r.height);

              if (bmi == null) {
                return const Center(child: Text("Không tính được BMI."));
              }

              // CHUẨN VIỆT NAM
              double vnStd = 0;
              int nearest = 0;
              for (final m in bmiVietnamStandard.keys) {
                if (m <= months) nearest = m;
              }
              vnStd = bmiVietnamStandard[nearest] ?? 15.0;

              // CHUẨN WHO
              final sex = (child.gender ?? 'M').toUpperCase();
              final lms = whoLmsLookup(sex, months);
              double whoStd = 0;
              if (lms != null) {
                whoStd = lms['M']!;
              }

              final note = classify(bmi, vnStd, whoStd);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text("👶 Bé: ${child.name}"),
                        subtitle: Text("Tuổi: $months tháng"),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      child: ListTile(
                        title: const Text("📌 BMI của bé"),
                        subtitle: Text(
                          "Cân nặng: ${r.weight} kg\n"
                              "Chiều cao: ${r.height} cm\n"
                              "➡️ BMI: $bmi",
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      child: ListTile(
                        title: const Text("🇻🇳 BMI chuẩn Việt Nam"),
                        subtitle: Text("Chuẩn tháng $nearest: $vnStd"),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      child: ListTile(
                        title: const Text("🌍 BMI chuẩn WHO"),
                        subtitle: Text("Chuẩn WHO (LMS M-value): $whoStd"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: note.contains("⚠️") ? Colors.red.shade100 : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        note,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
