import 'package:flutter/material.dart';
import '../models/cost_prediction_model.dart';

class CostPredictionPage extends StatefulWidget {
  const CostPredictionPage({super.key});

  @override
  _CostPredictionPageState createState() => _CostPredictionPageState();
}

class _CostPredictionPageState extends State<CostPredictionPage> {
  final _formKey = GlobalKey<FormState>();
  CostPredictionModel model = CostPredictionModel();

  bool submitted = false;

  List<DropdownMenuItem<String>> getSubCategories() {
    switch (model.category) {
      case "Medical":
        return const [
          DropdownMenuItem(value: "GeneralCheck", child: Text("Khám tổng quát")),
          DropdownMenuItem(value: "Specialist", child: Text("Khám chuyên khoa")),
          DropdownMenuItem(value: "AdvancedUltrasound", child: Text("Siêu âm nâng cao")),
          DropdownMenuItem(value: "NutritionTherapy", child: Text("Liệu trình dinh dưỡng")),
        ];

      case "Vaccination":
        return const [
          DropdownMenuItem(value: "Hexaxim", child: Text("Hexaxim")),
          DropdownMenuItem(value: "Rota", child: Text("Rota virus")),
          DropdownMenuItem(value: "MMR", child: Text("Sởi – Quai bị – Rubella")),
          DropdownMenuItem(value: "HepatitisB", child: Text("Viêm gan B")),
        ];

      case "Consultation":
        return const [
          DropdownMenuItem(value: "Nutrition", child: Text("Tư vấn dinh dưỡng")),
          DropdownMenuItem(value: "Postpartum", child: Text("Tư vấn sau sinh")),
          DropdownMenuItem(value: "NewbornCare", child: Text("Tư vấn chăm sóc bé")),
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dự đoán chi phí"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "💰 Dự đoán chi phí chăm sóc mẹ và bé",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              const SizedBox(height: 16),

              /// CATEGORY
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "🔍 Loại chi phí",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Medical", child: Text("Khám & điều trị")),
                  DropdownMenuItem(value: "Vaccination", child: Text("Tiêm chủng")),
                  DropdownMenuItem(value: "Consultation", child: Text("Tư vấn")),
                  DropdownMenuItem(value: "Childbirth", child: Text("Sinh đẻ")),
                  DropdownMenuItem(value: "Other", child: Text("Khác")),
                ],
                onChanged: (value) {
                  setState(() {
                    model.category = value;
                    model.subCategory = null;
                  });
                },
                validator: (v) => v == null ? "Vui lòng chọn loại chi phí" : null,
              ),

              const SizedBox(height: 16),

              /// SUBCATEGORY
              if (model.category != null &&
                  model.category != "Childbirth" &&
                  model.category != "Other")
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "📌 Loại dịch vụ",
                    border: OutlineInputBorder(),
                  ),
                  items: getSubCategories(),
                  onChanged: (v) => setState(() => model.subCategory = v),
                  validator: (v) => v == null ? "Vui lòng chọn dịch vụ" : null,
                ),

              const SizedBox(height: 16),

              /// DURATION
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "🕒 Thời gian (tháng)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                model.durationInMonths = int.tryParse(v) ?? 1,
                validator: (v) =>
                (int.tryParse(v ?? "") == null) ? "Nhập số hợp lệ" : null,
              ),

              const SizedBox(height: 16),

              /// CHILDBIRTH TYPE
              if (model.category == "Childbirth")
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "🤰 Loại sinh",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Normal", child: Text("Sinh thường")),
                    DropdownMenuItem(value: "C-section", child: Text("Sinh mổ")),
                  ],
                  onChanged: (v) => setState(() => model.childbirthType = v),
                  validator: (v) =>
                  v == null ? "Vui lòng chọn loại sinh" : null,
                ),

              const SizedBox(height: 20),

              /// BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      submitted = true;
                      model = model.calculateCost();
                    });
                  }
                },
                child: const Text("📊 Dự đoán chi phí"),
              ),

              const SizedBox(height: 20),

              if (submitted) _buildResult(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("📈 Kết quả ước tính:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _resultRow("💊 Thuốc men", model.medicationCost),
          _resultRow("👨‍⚕️ Phí khám", model.doctorFee),
          _resultRow("🧪 Xét nghiệm", model.labTestCost),
          _resultRow("💉 Tiêm chủng", model.vaccinationCost),
          _resultRow("🛒 Khác", model.otherCost),

          if (model.category == "Childbirth") ...[
            const SizedBox(height: 8),
            const Text("🏥 Chi phí sinh đẻ:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            _resultRow("🚼 Phí sinh", model.deliveryCost),
            _resultRow("💉 Gây tê", model.anesthesiaCost),
            _resultRow("🛏️ Nằm viện", model.hospitalStayCost),
            _resultRow("👩‍⚕️ Chăm sóc sau sinh", model.postpartumCareCost),
          ],

          const Divider(),

          Text(
            "💸 Tổng chi phí: ${model.format(model.predictedCost)} VNĐ",
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String label, double value) {
    if (value <= 0) return Container();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text("$label: ${model.format(value)} VNĐ"),
    );
  }
}
