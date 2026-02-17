import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/article_model.dart';
import 'create_article_page.dart';
import 'edit_article_page.dart';
import '../../pages/login_page.dart';

// Import thêm các model và service cho phần Tăng trưởng
import '../../models/growth_record_model.dart';
import '../../services/growth_service.dart';
import '../../services/child_service.dart';

class ExpertDashboardPage extends StatefulWidget {
  const ExpertDashboardPage({Key? key}) : super(key: key);

  @override
  State<ExpertDashboardPage> createState() => _ExpertDashboardPageState();
}

class _ExpertDashboardPageState extends State<ExpertDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Biến cho Tab 1 (Chỉ số phát triển)
  String? _selectedChildId; // ID bé đang được chuyên gia chọn xem
  final GrowthService _growthService = GrowthService();

  // Biến cho Tab 2 (Bài viết)
  String? _realExpertId;
  bool _isLoadingId = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _findRealExpertId();
  }

  // 🔥 HÀM TÌM ID CHUYÊN GIA
  Future<void> _findRealExpertId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1. Tìm theo email
      var query = await FirebaseFirestore.instance
          .collection('experts')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      // 2. Tìm theo e-mail (trường hợp dữ liệu cũ)
      if (query.docs.isEmpty) {
        query = await FirebaseFirestore.instance
            .collection('experts')
            .where('e-mail', isEqualTo: user.email)
            .limit(1)
            .get();
      }

      if (query.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            _realExpertId = query.docs.first.id;
            _isLoadingId = false;
          });
        }
      } else {
        // Không thấy thì dùng UID
        if (mounted) {
          setState(() {
            _realExpertId = user.uid;
            _isLoadingId = false;
          });
        }
      }
    } catch (e) {
      print("❌ Lỗi tìm ID chuyên gia: $e");
      if (mounted) setState(() => _isLoadingId = false);
    }
  }

  // --- HÀM ĐĂNG XUẤT ---
  void _logout() async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Huỷ")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Đăng xuất"),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("👨‍⚕️ Trang Chuyên Gia"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout), tooltip: "Đăng xuất"),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "📈 Theo dõi trẻ", icon: Icon(Icons.show_chart)),
            Tab(text: "📝 Bài viết", icon: Icon(Icons.article_outlined)),
          ],
        ),
      ),
      body: _isLoadingId
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildGrowthRecordsTab(), // Tab 1
          _buildArticlesTab(),      // Tab 2
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Viết bài", style: TextStyle(color: Colors.white)),
        onPressed: () {
          if (_tabController.index == 0) _tabController.animateTo(1);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateArticlePage()));
        },
      ),
    );
  }

  // ======================================================
  // TAB 1: THEO DÕI CHỈ SỐ PHÁT TRIỂN (ĐÃ FIX LỖI DROPDOWN & UI)
  // ======================================================
  Widget _buildGrowthRecordsTab() {
    return Column(
      children: [
        const SizedBox(height: 10),

        // 1. Dropdown chọn bé
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('children').snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                }

                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Hệ thống chưa có dữ liệu trẻ em."),
                  );
                }

                final childrenDocs = snap.data!.docs;

                // --- 🛠 FIX LỖI DROPDOWN START ---
                // Kiểm tra xem _selectedChildId hiện tại có còn tồn tại trong danh sách mới không?
                final containsSelected = childrenDocs.any((doc) => doc.id == _selectedChildId);

                if (_selectedChildId == null || !containsSelected) {
                  // Nếu chưa chọn hoặc ID đang chọn bị xóa mất -> Chọn bé đầu tiên
                  // Dùng microtask để tránh lỗi setState khi đang build
                  Future.microtask(() {
                    if (mounted && childrenDocs.isNotEmpty) {
                      setState(() => _selectedChildId = childrenDocs.first.id);
                    }
                  });

                  // Trong lúc chờ setState, hiển thị tạm loading hoặc text
                  if (!containsSelected && _selectedChildId != null) {
                    return const Padding(padding: EdgeInsets.all(12), child: Text("Đang cập nhật danh sách..."));
                  }
                }
                // --- FIX LỖI DROPDOWN END ---

                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Chọn bé để xem chỉ số"),
                    value: _selectedChildId, // Giá trị này giờ đã an toàn
                    items: childrenDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text("👶 ${data['name'] ?? 'Bé không tên'}"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedChildId = val;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 10),
        const Divider(),

        // 2. Hiển thị danh sách chỉ số
        Expanded( // Expanded ở đây yêu cầu cha của Column phải có chiều cao xác định (TabBarView OK)
          child: _selectedChildId == null
              ? const Center(child: Text("Đang tải dữ liệu bé..."))
              : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("growth_records")
                .where("childId", isEqualTo: _selectedChildId)
                .orderBy("record_date", descending: true)
            // ⚠️ LƯU Ý: Nếu vẫn lỗi, hãy bấm link trong Logcat để tạo Index
                .snapshots(),

            builder: (context, snap) {
              if (snap.hasError) {
                // In lỗi ra để bạn dễ copy link tạo Index
                print("❌ Lỗi Firebase: ${snap.error}");
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Lỗi tải dữ liệu.\nNếu thấy lỗi 'requires an index', hãy xem log để lấy link tạo Index.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                );
              }

              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snap.hasData || snap.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      const Text("Bé này chưa có chỉ số đo nào."),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: snap.data!.docs.length,
                itemBuilder: (_, i) {
                  var doc = snap.data!.docs[i];
                  var data = doc.data() as Map<String, dynamic>;

                  // Xử lý ngày tháng an toàn
                  String dateStr = "Không rõ";
                  if (data["record_date"] != null && data["record_date"] is Timestamp) {
                    dateStr = DateFormat("dd/MM/yyyy").format((data["record_date"] as Timestamp).toDate());
                  }

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.pinkAccent),
                              const SizedBox(width: 8),
                              Text(
                                  dateStr,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent, fontSize: 16)
                              ),
                            ],
                          ),
                          const Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(Icons.monitor_weight_outlined, "${data['weight'] ?? '--'} kg", Colors.blue),
                              _buildStatItem(Icons.height_outlined, "${data['height'] ?? '--'} cm", Colors.green),
                              _buildStatItem(Icons.face_retouching_natural, "${data['head_circumference'] ?? '--'} cm", Colors.orange),
                            ],
                          ),

                          if (data['notes'] != null && data['notes'].toString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text(
                                  "📝 ${data['notes']}",
                                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
                                ),
                              ),
                            )
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
    );
  }


  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  // ======================================================
  // TAB 2: QUẢN LÝ BÀI VIẾT
  // ======================================================
  Widget _buildArticlesTab() {
    if (_realExpertId == null) return const Center(child: CircularProgressIndicator());

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('articles')
          .where('expert_id', isEqualTo: _realExpertId)
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Lỗi tải bài viết"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 10),
                const Text("Bạn chưa có bài viết nào.", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateArticlePage())
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Viết bài đầu tiên"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white
                  ),
                )
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var data = doc.data() as Map<String, dynamic>;
            var article = ArticleModel.fromMap(data, doc.id);

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (article.image_url != null && article.image_url!.isNotEmpty)
                      ? Image.network(article.image_url!, width: 60, height: 60, fit: BoxFit.cover)
                      : Container(color: Colors.grey[200], width: 60, height: 60, child: const Icon(Icons.image, color: Colors.grey)),
                ),
                title: Text(article.title ?? "Không tiêu đề", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  article.created_at != null ? DateFormat('dd/MM/yyyy').format(article.created_at!) : "Vừa xong",
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditArticlePage(article: article))),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(doc.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận xoá"),
        content: const Text("Bạn có chắc chắn muốn xoá bài viết này không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Huỷ")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('articles').doc(docId).delete();
              Navigator.pop(ctx);
            },
            child: const Text("Xoá"),
          ),
        ],
      ),
    );
  }
}
