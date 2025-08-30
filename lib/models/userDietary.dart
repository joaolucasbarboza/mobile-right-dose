import 'package:tcc/models/dietary.dart';

class UserDietary {
  final int id;
  final int userId;
  final Dietary dietary;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserDietary({
    required this.id,
    required this.userId,
    required this.dietary,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDietary.fromJson(Map<String, dynamic> json) {
    return UserDietary(
      id: json['id'],
      userId: json['userId'],
      dietary: Dietary.fromJson(json['dietaryRestriction']),
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