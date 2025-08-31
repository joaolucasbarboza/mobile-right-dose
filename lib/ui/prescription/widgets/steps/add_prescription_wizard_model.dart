import 'package:flutter/material.dart';

class AddPrescriptionWizardModel extends ChangeNotifier {
  int? medicineId;
  String? medicineName;
  double? dosageAmount;
  String? dosageUnit;

  int? frequency;
  String? uomFrequency;

  DateTime? startDate;

  bool indefinite = false;
  int? totalOccurrences;

  String? instructions;
  bool wantsNotifications = true;

  void reset() {
    medicineId = null;
    medicineName = null;
    dosageAmount = null;
    dosageUnit = null;

    frequency = null;
    uomFrequency = null;

    startDate = null;

    indefinite = false;
    totalOccurrences = null;

    instructions = null;
    wantsNotifications = true;

    notifyListeners();
  }

  void setMedicine(int? id, String? name) {
    medicineId = id;
    medicineName = name;
    notifyListeners();
  }

  void setDosage(double? amount, String? unit) {
    dosageAmount = amount;
    dosageUnit = unit;
    notifyListeners();
  }

  void setFrequency(int? value, String? unit) {
    frequency = value;
    uomFrequency = unit;
    notifyListeners();
  }

  void setStartDate(DateTime? dt) {
    startDate = dt;
    notifyListeners();
  }

  void setIndefinite(bool v) {
    indefinite = v;
    if (v) totalOccurrences = null;
    notifyListeners();
  }

  void setTotalOccurrences(int? v) {
    totalOccurrences = v;
    notifyListeners();
  }

  void setInstructions(String? v) {
    instructions = v;
    notifyListeners();
  }

  void setWantsNotifications(bool v) {
    wantsNotifications = v;
    notifyListeners();
  }

  Map<String, dynamic> toRequest() {
    return {
      "medicineId": medicineId,
      "dosageAmount": dosageAmount,
      "dosageUnit": dosageUnit,
      "frequency": frequency,
      "uomFrequency": uomFrequency,
      "indefinite": indefinite,
      "totalOccurrences": indefinite ? null : totalOccurrences,
      "startDate": startDate?.toIso8601String(),
      "wantsNotifications": wantsNotifications,
      "instructions": instructions?.trim(),
    };
  }

  String? validateStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        if (medicineId == null) return "Selecione um medicamento";
        if (dosageAmount == null) return "Informe a dosagem";
        if (dosageUnit == null) return "Selecione a unidade da dose";
        return null;
      case 1:
        if (frequency == null) return "Informe a frequência";
        if (uomFrequency == null) return "Selecione a unidade da frequência";
        return null;
      case 2:
        if (startDate == null) return "Selecione a data/hora de início";
        return null;
      case 3:
        if (!indefinite && (totalOccurrences == null || totalOccurrences! <= 0)) {
          return "Informe o total de vezes";
        }
        return null;
      default:
        return null;
    }
  }
}
