import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/expert_model.dart';
import 'expert_add_page.dart';
import 'expert_edit_page.dart';

class ExpertsPage extends StatelessWidget {
  final expertsRef = FirebaseFirestore.instance.collection("experts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("👨‍⚕️ Quản lý Chuyên gia")),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddExpertPage())
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
          stream: expertsRef.orderBy('created_at', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return const Center(child: Text("⚠ Chưa có chuyên gia nào."));

            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  // Convert data sang Model
                  var data = docs[i].data() as Map<String, dynamic>;
                  var expert = ExpertModel.fromMap(data, docs[i].id);

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: (expert.avatar_url != null && expert.avatar_url!.isNotEmpty)
                            ? NetworkImage(expert.avatar_url!)
                            : const AssetImage("assets/user.png") as ImageProvider,
                      ),
                      title: Text(expert.full_name ?? "Chưa có tên", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("💼 ${expert.specialization}"),
                          Text("🎓 ${expert.degree} • ${expert.experience_years} năm KN"),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => EditExpertPage(expert: expert)))
                          ),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, expert.id!)
                          )
                        ],
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc chắn muốn xóa chuyên gia này?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await expertsRef.doc(id).delete();
                Navigator.pop(context);
              },
              child: const Text("Xóa")
          )
        ],
      ),
    );
  }
}
