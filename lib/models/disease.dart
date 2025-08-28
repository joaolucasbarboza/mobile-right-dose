import 'package:tcc/data/dto/disease_dto.dart';

class Disease {
  final int? id;
  final DiseaseDTO? disease;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Disease({
    this.id,
    this.disease,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'],
      disease: json['disease'] != null ? DiseaseDTO.fromJson(json['disease']) : null,
      notes: json['notes'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}