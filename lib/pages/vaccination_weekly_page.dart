import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/vaccination_service.dart';
import '../models/vaccination_record_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VaccinationWeeklyPage extends StatefulWidget {
  const VaccinationWeeklyPage({super.key});

  @override
  State<VaccinationWeeklyPage> createState() => _VaccinationWeeklyPageState();
}

class _VaccinationWeeklyPageState extends State<VaccinationWeeklyPage> {
  // Map lưu tên của các bé để hiển thị cho đẹp (Key: childId, Value: Name)
  Map<String, String> _childNames = {};

  @override
  void initState() {
    super.initState();
    _loadChildrenNames();
  }

  // Lấy tên các bé để hiển thị (thay vì hiện ID)
  Future<void> _loadChildrenNames() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final snap = await FirebaseFirestore.instance
          .collection('children')
          .where('family_id', isEqualTo: uid)
          .get();

      if (mounted) {
        setState(() {
          _childNames = {
            for (var doc in snap.docs) doc.id: doc.data()['name'] ?? 'Bé không tên'
          };
        });
      }
    } catch (e) {
      debugPrint("Lỗi lấy tên bé: $e");
    }
  }

  // Hàm tính số tuần trong năm
  int _weekOfYear(DateTime date) {
    final firstThursday = DateTime(date.year, 1, 1)
        .add(Duration(days: (4 - DateTime(date.year, 1, 1).weekday) % 7));
    final diff = date.difference(firstThursday).inDays;
    return 1 + (diff / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📅 Lịch Tiêm Theo Tuần"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<VaccinationRecordModel>>(
        // ✅ QUAN TRỌNG: Dùng lại đúng hàm mà trang VaccinationPage đang chạy ngon
        stream: VaccinationService().getByUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final allRecords = snapshot.data ?? [];

          if (allRecords.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Chưa có lịch tiêm nào."),
                ],
              ),
            );
          }

          // --- XỬ LÝ DỮ LIỆU TRÊN CLIENT (An toàn & Nhanh) ---

          // 1. Lọc bỏ các bản ghi không có ngày tháng
          final validRecords = allRecords.where((r) => r.vaccination_date != null).toList();

          // 2. Sắp xếp theo ngày tăng dần
          validRecords.sort((a, b) => a.vaccination_date!.compareTo(b.vaccination_date!));

          // 3. Gom nhóm theo tuần
          final Map<String, List<VaccinationRecordModel>> groupedByWeek = {};

          for (var record in validRecords) {
            final date = record.vaccination_date!;
            final weekNum = _weekOfYear(date);
            final key = "Tuần $weekNum - Năm ${date.year}"; // Key duy nhất cho mỗi tuần

            if (!groupedByWeek.containsKey(key)) {
              groupedByWeek[key] = [];
            }
            groupedByWeek[key]!.add(record);
          }

          // 4. Hiển thị ra danh sách
          final weekKeys = groupedByWeek.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: weekKeys.length,
            itemBuilder: (context, index) {
              final weekTitle = weekKeys[index];
              final recordsInWeek = groupedByWeek[weekTitle]!;

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Tuần
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Text(
                        weekTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ),

                    // Danh sách mũi tiêm trong tuần đó
                    ListView.separated(
                      shrinkWrap: true, // Quan trọng để lồng trong ListView cha
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recordsInWeek.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final record = recordsInWeek[i];
                        final dateStr = DateFormat('dd/MM/yyyy').format(record.vaccination_date!);

                        // Lấy tên bé từ Map đã load, nếu không có thì hiện "Bé chưa đặt tên"
                        final babyName = _childNames[record.childId] ??
                            _childNames[record.childId] ??
                            "Bé yêu";

                        return ListTile(
                          leading: Icon(
                            record.is_completed == true ? Icons.check_circle : Icons.circle_outlined,
                            color: record.is_completed == true ? Colors.green : Colors.orange,
                            size: 28,
                          ),
                          title: Text(
                            record.vaccine_name ?? "Vắc-xin",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.child_care, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(babyName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(dateStr),
                                ],
                              ),
                              if (record.notes != null && record.notes!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    "📝 ${record.notes}",
                                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
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
