import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/vaccination_service.dart';
import '../models/vaccination_record_model.dart';
import 'vaccination_create_page.dart';
import 'vaccination_edit_page.dart';
import 'vaccination_weekly_page.dart';
import 'vaccination_suggestion_page.dart';


class VaccinationPage extends StatefulWidget {
  const VaccinationPage({super.key});

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  final VaccinationService _service = VaccinationService();

  void _refreshData() => setState(() {});

  Future<void> _confirmDelete(BuildContext context, String recordId) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa lịch tiêm này không?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          TextButton(
            child: const Text('Xóa'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.delete(recordId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Bạn chưa đăng nhập")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("💉 Lịch Tiêm Chủng")),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Thêm lịch tiêm"),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VaccinationCreatePage(),
                      ),
                    );
                    if (result == true) _refreshData();
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: const Text("Theo tuần"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VaccinationWeeklyPage()),
                    );
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.lightbulb),
                  label: const Text("Đề xuất"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VaccinationSuggestionPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<List<VaccinationRecordModel>>(
              stream: VaccinationService().getByUser(),   // 🔥 load danh sách
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());

                final list = snap.data!;

                if (list.isEmpty) return const Center(child: Text("Chưa có lịch tiêm nào"));

                list.sort((a,b){
                  if(a.is_completed==b.is_completed) return 0;
                  return a.is_completed! ? 1:-1;   // mục chưa hoàn thành nằm trên
                });

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final v = list[i];

                    // 1. Format ngày giờ
                    String dateDisplay = "Chưa đặt lịch";
                    if (v.vaccination_date != null) {
                      // Nếu vaccination_date trong model là DateTime
                      dateDisplay = DateFormat("HH:mm - dd/MM/yyyy").format(v.vaccination_date!);
                    }

                    // 2. Kiểm tra trạng thái hoàn thành
                    bool isDone = v.is_completed == true;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDone ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          child: Icon(
                            isDone ? Icons.check : Icons.access_time,
                            color: isDone ? Colors.green : Colors.orange,
                          ),
                        ),
                        title: Text(
                          v.vaccine_name ?? "Không tên",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(dateDisplay, style: const TextStyle(color: Colors.black87)),
                              ],
                            ),
                            if (v.notes != null && v.notes!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "📝 ${v.notes}",
                                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDone ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isDone ? "Đã tiêm" : "Chưa tiêm",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDone ? Colors.green[800] : Colors.red[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => VaccinationEditPage(record: v)),
                              );
                              if (res == true) setState(() {}); // reload UI
                            } else if (value == 'delete') {
                              if (v.id != null) {
                                _confirmDelete(context, v.id!);
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue, size: 20),
                                  SizedBox(width: 8),
                                  Text('Chỉnh sửa'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Text('Xóa'),
                                ],
                              ),
                            ),
                          ],
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
