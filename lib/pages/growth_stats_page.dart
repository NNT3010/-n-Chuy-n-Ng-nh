// lib/pages/growth_stats_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/growth_record_model.dart';
import '../services/growth_service.dart';

class GrowthStatsPage extends StatefulWidget {
  final String childId;
  const GrowthStatsPage({super.key, required this.childId});

  @override
  State<GrowthStatsPage> createState() => _GrowthStatsPageState();
}

class _GrowthStatsPageState extends State<GrowthStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📊 Biểu đồ Chỉ số phát triển')),
      body: StreamBuilder<List<GrowthRecordModel>>(
        stream: GrowthService().getRecordsByChild(widget.childId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text("Lỗi: ${snap.error}"));
          }

          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(
              child: Text(
                '⚠ Bé chưa có dữ liệu chỉ số để thống kê.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Lấy danh sách bản ghi
          final records = snap.data!;

          // Sắp xếp theo ngày tăng dần để biểu đồ đúng
          records.sort((a, b) =>
              (a.record_date ?? DateTime(2000))
                  .compareTo(b.record_date ?? DateTime(2000)));

          // Chuẩn bị điểm dữ liệu
          final weightPoints = <FlSpot>[];
          final heightPoints = <FlSpot>[];
          final headPoints = <FlSpot>[];

          for (int i = 0; i < records.length; i++) {
            final r = records[i];
            final x = i.toDouble();

            weightPoints.add(FlSpot(x, r.weight ?? 0));
            heightPoints.add(FlSpot(x, r.height ?? 0));
            headPoints.add(FlSpot(x, r.head_circumference ?? 0));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 34,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index < 0 || index >= records.length) {
                                return const SizedBox();
                              }

                              final d = records[index].record_date;
                              final label = d != null
                                  ? "${d.day}/${d.month}"
                                  : "";

                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  label,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      lineBarsData: [
                        // Cân nặng
                        LineChartBarData(
                          spots: weightPoints,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.blue,
                          dotData: FlDotData(show: true),
                        ),
                        // Chiều cao
                        LineChartBarData(
                          spots: heightPoints,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.green,
                          dotData: FlDotData(show: true),
                        ),
                        // Vòng đầu
                        LineChartBarData(
                          spots: headPoints,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.red,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Chú thích biểu đồ
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.circle, color: Colors.blue, size: 12),
                    SizedBox(width: 5),
                    Text("Cân nặng (kg)"),
                    SizedBox(width: 20),
                    Icon(Icons.circle, color: Colors.green, size: 12),
                    SizedBox(width: 5),
                    Text("Chiều cao (cm)"),
                    SizedBox(width: 20),
                    Icon(Icons.circle, color: Colors.red, size: 12),
                    SizedBox(width: 5),
                    Text("Vòng đầu (cm)"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
