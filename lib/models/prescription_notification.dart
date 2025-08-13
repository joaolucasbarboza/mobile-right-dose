enum Status {
  PENDING,
  CONFIRMED,
  CANCELLED,
}

class PrescriptionNotification {
  final int? id;
  final DateTime notificationTime;
  final Status status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? medicineName;
  final double? dosageAmount;
  final int? prescriptionId;
  final String? dosageUnit;

  PrescriptionNotification({
    this.id,
    required this.notificationTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.medicineName,
    this.dosageAmount,
    this.prescriptionId,
    this.dosageUnit,
  });

  factory PrescriptionNotification.fromMap(Map<String, dynamic> map) {
    return PrescriptionNotification(
      id: map['id'] as int?,
      notificationTime: DateTime.parse(map['notificationTime'] as String),
      status: _statusFromString(map['status'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      medicineName: map['medicineName'] as String?,
      dosageAmount: map['dosageAmount'] as double?,
      prescriptionId: map['prescriptionId'] as int?,
      dosageUnit: map['dosageUnit'] as String?,
    );
  }

  static Status _statusFromString(String value) {
    return Status.values.firstWhere(
          (e) => e.toString().split('.').last.toUpperCase() == value.toUpperCase(),
      orElse: () => Status.PENDING,
    );
  }
}
