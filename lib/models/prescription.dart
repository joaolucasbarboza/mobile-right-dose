import 'package:tcc/models/medicine.dart';
import 'package:tcc/models/prescription_notification.dart';

class Prescription {
  int id;
  Medicine medicine;
  double dosageAmount;
  String dosageUnit;
  int frequency;
  String uomFrequency;
  bool indefinite;
  int totalOccurrences;
  DateTime startDate;
  DateTime endDate;
  bool wantsNotifications;
  String? instructions;
  List<PrescriptionNotification> notifications;

  Prescription({
    required this.id,
    required this.medicine,
    required this.dosageAmount,
    required this.dosageUnit,
    required this.frequency,
    required this.uomFrequency,
    required this.indefinite,
    required this.totalOccurrences,
    required this.startDate,
    required this.endDate,
    required this.wantsNotifications,
    this.instructions,
    this.notifications = const [],
  });

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'],
      medicine: Medicine.fromMap(map['medicine']),
      dosageAmount: map['dosageAmount'],
      dosageUnit: map['dosageUnit']?.toString() ?? '',
      frequency: map['frequency'],
      uomFrequency: map['uomFrequency'],
      indefinite: map['indefinite'] ?? false,
      totalOccurrences: map['totalOccurrences'] ?? 0,
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : DateTime.now(), // Corrigido aqui
      wantsNotifications: map['wantsNotifications'],
      instructions: map['instructions']?.toString() ?? '',
      notifications: (map['notifications'] as List<dynamic>?)
          ?.map((n) => PrescriptionNotification.fromMap(n as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dosageAmount': dosageAmount,
      'dosageUnit': dosageUnit,
      'frequency': frequency,
      'uomFrequency': uomFrequency,
      'totalOcurrences': totalOccurrences,
      'startDate': startDate.toIso8601String(),
      'wantsNotifications': wantsNotifications,
      'instructions': instructions,
    };
  }
}
