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

  PrescriptionNotification({
    this.id,
    required this.notificationTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrescriptionNotification.fromMap(Map<String, dynamic> map) {
    return PrescriptionNotification(
      id: map['id'] as int?,
      notificationTime: DateTime.parse(map['notificationTime'] as String),
      status: _statusFromString(map['status'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  /// Mapeia string para enum Status
  static Status _statusFromString(String value) {
    return Status.values.firstWhere(
          (e) => e.toString().split('.').last.toUpperCase() == value.toUpperCase(),
      orElse: () => Status.PENDING,
    );
  }
}
