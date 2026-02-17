import '../models/cost_prediction_model.dart';

class CostPredictionService {
  CostPredictionModel calculate(CostPredictionModel model) {
    return model.calculateCost(); // ✔ không truyền tham số
  }
}
