import 'package:intl/intl.dart';
import 'package:tcc/models/dosage_per_unit.dart';

class Medicine {
  int? medicineId;
  String name;
  String description;
  int quantity;
  String unit;
  DosagePerUnit? dosagePerUnit;
  DateTime createdAt;
  DateTime? updatedAt;

  Medicine({
    this.medicineId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.dosagePerUnit,
    required this.createdAt,
    this.updatedAt,
  });

  static final _dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      medicineId: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      unit: map['unit'],
      dosagePerUnit: map['dosagePerUnit'] != null
          ? DosagePerUnit.fromMap(map['dosagePerUnit'])
          : null,
      createdAt: _dateFormat.parse(map['createdAt']),
      updatedAt: _dateFormat.parse(map['updatedAt']) 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_id': medicineId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'dosagePerUnit': dosagePerUnit?.toMap(),
    };
  }
}
