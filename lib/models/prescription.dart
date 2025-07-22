import 'package:tcc/models/medicine.dart';

class Prescription {
  int? id;
  Medicine medicine;
  double dosageAmount;
  String dosageUnit;
  int frequency;
  String uomFrequency;
  int totalDays;
  DateTime startDate;
  DateTime endDate;
  bool wantsNotifications;
  String? instructions;

  Prescription({
    this.id,
    required this.medicine,
    required this.dosageAmount,
    required this.dosageUnit,
    required this.frequency,
    required this.uomFrequency,
    required this.totalDays,
    required this.startDate,
    required this.endDate,
    required this.wantsNotifications,
    this.instructions,
  });

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'],
      medicine: Medicine.fromMap(map['medicine']),
      dosageAmount: map['dosageAmount'],
      dosageUnit: map['dosageUnit']?.toString() ?? '',
      frequency: map['frequency'],
      uomFrequency: map['uomFrequency'],
      totalDays: map['totalDays'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate'] ?? ''),
      wantsNotifications: map['wantsNotifications'],
      instructions: map['instructions']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dosageAmount': dosageAmount,
      'dosageUnit': dosageUnit,
      'frequency': frequency,
      'uomFrequency': uomFrequency,
      'totalDays': totalDays,
      'startDate': startDate.toIso8601String(),
      'wantsNotifications': wantsNotifications,
      'instructions': instructions,
    };
  }
}
