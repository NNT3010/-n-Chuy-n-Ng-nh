import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/growth_service.dart';
import '../models/growth_record_model.dart';
import '../services/child_service.dart';
import '../models/child_model.dart';
import 'growth_create_page.dart';
import 'growth_edit_page.dart';
import 'growth_stats_page.dart';
import 'nutrition_suggestion_page.dart';
import 'bmi_compare_page.dart';


class GrowthIndexPage extends StatefulWidget {
  const GrowthIndexPage({super.key});

  @override
  State<GrowthIndexPage> createState() => _GrowthIndexPageState();
}

class _GrowthIndexPageState extends State<GrowthIndexPage> {
  String? selectedChildId;

  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String familyId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("📈 Chỉ Số Phát Triển")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // ----- MENU BUTTON -----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.bar_chart),
                  label: const Text("Thống kê"),
                  onPressed: () {
                    if (selectedChildId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng chọn một bé để xem thống kê.')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrowthStatsPage(childId: selectedChildId!),
                      ),
                    );
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text("Đề xuất dinh dưỡng"),
                  onPressed: () {
                    if (selectedChildId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Vui lòng chọn một bé.")),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NutritionSuggestionPage(childId: selectedChildId!),
                      ),
                    );
                  },
                ),

                OutlinedButton.icon(
                  icon: const Icon(Icons.monitor_weight),
                  label: const Text("So sánh BMI"),
                  onPressed: () {
                    if (selectedChildId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng chọn một bé để xem BMI.')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BmiComparePage(childId: selectedChildId!),
                      ),
                    );
                  },
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Thêm chỉ số"),
                  onPressed: () async {
                    if (selectedChildId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng chọn một bé để thêm chỉ số.')),
                      );
                      return;
                    }
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrowthCreatePage(childId: selectedChildId!),
                      ),
                    );
                    if (result == true) {
                      _refreshData();
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ----- CHILD DROPDOWN -----
          StreamBuilder<List<ChildModel>>(
            stream: ChildService().getChildrenByFamily(familyId),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snap.hasData || snap.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text("Bạn chưa thêm bé nào. Hãy thêm bé trong mục Hồ sơ."),
                  ),
                );
              }

              final children = snap.data!;
              selectedChildId ??= children.first.id;

              return DropdownButton<String>(
                value: selectedChildId,
                items: children
                    .map((c) => DropdownMenuItem(
                  value: c.id,
                  child: Text("👶 ${c.name ?? 'Bé không tên'}"),
                ))
                    .toList(),
                onChanged: (v) => setState(() => selectedChildId = v),
              );
            },
          ),

          const Divider(),

          // ----- GROWTH RECORDS -----
          Expanded(
            child: StreamBuilder<List<GrowthRecordModel>>(
              stream: selectedChildId == null
                  ? const Stream.empty()
                  : GrowthService().getRecordsByChild(selectedChildId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Bé chưa có chỉ số nào."));
                }

                final records = snapshot.data!;

                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, i) {
                    final r = records[i];
                    final d = r.record_date;
                    final dateText =
                    d != null ? "${d.day}/${d.month}/${d.year}" : "Không rõ";

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: ListTile(
                        title: Text("📅 Ngày: $dateText"),
                        subtitle: Text(
                          "⚖️ Cân nặng: ${r.weight ?? 'N/A'} kg\n"
                              "📏 Chiều cao: ${r.height ?? 'N/A'} cm\n"
                              "🧠 Vòng đầu: ${r.head_circumference ?? 'N/A'} cm\n"
                              "${r.notes ?? ''}",
                          style: const TextStyle(height: 1.5),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GrowthEditPage(record: r),
                              ),
                            );
                            if (result == true) {
                              _refreshData();
                            }
                          },
                        ),
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
