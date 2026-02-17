import 'package:intl/intl.dart';

class CostPredictionModel {
  String? category;
  String? subCategory;
  int durationInMonths;

  // Tổng chi phí
  double predictedCost = 0;

  // Các chi tiết chi phí
  double medicationCost = 0;
  double doctorFee = 0;
  double labTestCost = 0;
  double vaccinationCost = 0;
  double otherCost = 0;

  // Sinh đẻ
  String? childbirthType;
  double hospitalStayCost = 0;
  double deliveryCost = 0;
  double anesthesiaCost = 0;
  double postpartumCareCost = 0;

  // Extra
  double ultrasoundCost = 0;
  double supplementCost = 0;
  double ambulanceCost = 0;
  double babyCareCost = 0;

  CostPredictionModel({
    this.category,
    this.subCategory,
    this.childbirthType,
    this.durationInMonths = 1,
  });

  /// ⭐ HÀM TÍNH CHI PHÍ
  CostPredictionModel calculateCost() {
    _resetCosts();

    switch (category) {
      case "Medical":
        _calculateMedical();
        break;
      case "Vaccination":
        _calculateVaccination();
        break;
      case "Consultation":
        _calculateConsultation();
        break;
      case "Childbirth":
        _calculateChildbirth();
        break;
      case "Other":
        otherCost = 100000.0 * durationInMonths;
        break;
    }

    predictedCost =
        medicationCost +
            doctorFee +
            labTestCost +
            vaccinationCost +
            otherCost +
            hospitalStayCost +
            deliveryCost +
            anesthesiaCost +
            postpartumCareCost +
            ultrasoundCost +
            supplementCost +
            ambulanceCost +
            babyCareCost;

    return this;
  }

  /// ============================
  /// ⭐ TÍNH THEO LOẠI DỊCH VỤ
  /// ============================

  void _calculateMedical() {
    switch (subCategory) {
      case "GeneralCheck":
        doctorFee = 150000.0;
        labTestCost = 120000.0;
        medicationCost = 100000.0;
        break;

      case "Specialist":
        doctorFee = 300000.0;
        labTestCost = 150000.0;
        medicationCost = 180000.0;
        break;

      case "AdvancedUltrasound":
        ultrasoundCost = 350000.0;
        break;

      case "NutritionTherapy":
        doctorFee = 250000.0;
        supplementCost = 200000.0;
        break;
    }
  }

  void _calculateVaccination() {
    switch (subCategory) {
      case "Hexaxim":
        vaccinationCost = 1200000.0;
        break;

      case "Rota":
        vaccinationCost = 950000.0;
        break;

      case "MMR":
        vaccinationCost = 450000.0;
        break;

      case "HepatitisB":
        vaccinationCost = 250000.0;
        break;
    }
  }

  void _calculateConsultation() {
    switch (subCategory) {
      case "Nutrition":
        doctorFee = 300000.0;
        break;

      case "Postpartum":
        doctorFee = 350000.0;
        break;

      case "NewbornCare":
        doctorFee = 280000.0;
        break;
    }
  }

  void _calculateChildbirth() {
    hospitalStayCost = 3000000.0;
    postpartumCareCost = 2500000.0;
    babyCareCost = 1200000.0;
    ambulanceCost = 500000.0;

    if (childbirthType == "Normal") {
      deliveryCost = 5000000.0;
      anesthesiaCost = 0.0;
    } else if (childbirthType == "C-section") {
      deliveryCost = 9000000.0;
      anesthesiaCost = 1500000.0;
    }
  }

  /// RESET CHI PHÍ
  void _resetCosts() {
    medicationCost = 0;
    doctorFee = 0;
    labTestCost = 0;
    vaccinationCost = 0;
    otherCost = 0;
    hospitalStayCost = 0;
    deliveryCost = 0;
    anesthesiaCost = 0;
    postpartumCareCost = 0;
    ultrasoundCost = 0;
    supplementCost = 0;
    ambulanceCost = 0;
    babyCareCost = 0;
    predictedCost = 0;
  }

  /// FORMAT MONEY
  String format(double value) {
    return NumberFormat("#,###", "vi_VN").format(value);
  }
}
