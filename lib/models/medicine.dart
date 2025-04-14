class Medicine {
  int? medicineId;
  String name;
  String description;
  int quantity;
  String unit;
  DateTime createdAt;

  Medicine({
    this.medicineId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.createdAt,
  });

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      medicineId: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      unit: map['unit'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicine_id': medicineId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
