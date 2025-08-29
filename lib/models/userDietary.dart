import 'package:tcc/models/dietary.dart';

class UserDietary {
  final Dietary dietary;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserDietary({
    required this.dietary,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDietary.fromJson(Map<String, dynamic> json) {
    return UserDietary(
      dietary: Dietary.fromJson(json['dietary']),
      notes: json['notes'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dietary': dietary.toJson(),
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}