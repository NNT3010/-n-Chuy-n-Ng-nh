import 'package:flutter/material.dart';
import '../models/child_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionSuggestionPage extends StatefulWidget {
  final String childId;

  const NutritionSuggestionPage({super.key, required this.childId});

  @override
  State<NutritionSuggestionPage> createState() => _NutritionSuggestionPageState();
}

class _NutritionSuggestionPageState extends State<NutritionSuggestionPage> {
  Future<ChildModel?> _loadChild(String id) async {
    final doc = await FirebaseFirestore.instance.collection('children').doc(id).get();
    if (!doc.exists) return null;
    return ChildModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  List<String> _recommendationsByMonths(int months) {
    if (months < 6) {
      return [
        'Chỉ bú mẹ hoàn toàn.',
        'Bổ sung vitamin D nếu cần.'
      ];
    } else if (months < 12) {
      return [
        'Tiếp tục bú mẹ + ăn dặm.',
        'Ăn cháo, rau nghiền, thịt xay.'
      ];
    } else if (months < 24) {
      return [
        'Ăn 3 bữa chính + 2 bữa phụ.',
        'Tăng cường canxi, sắt, kẽm.'
      ];
    } else {
      return [
        'Chế độ ăn đa dạng: cơm, thịt, cá, rau, trái cây.',
        'Hạn chế bánh kẹo, nước ngọt.'
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Đề xuất dinh dưỡng')),
      body: FutureBuilder<ChildModel?>(
        future: _loadChild(widget.childId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data == null) {
            return const Center(child: Text('Không tìm thấy bé'));
          }

          final child = snap.data!;
          final dob = child.date_of_birth ?? DateTime.now();
          final months = ((DateTime.now().difference(dob).inDays) / 30.44).floor();

          final recs = _recommendationsByMonths(months);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bé: ${child.name}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Tuổi: $months tháng'),
                const SizedBox(height: 12),
                const Text(
                  'Gợi ý dinh dưỡng:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...recs.map(
                      (r) => ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(r),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
