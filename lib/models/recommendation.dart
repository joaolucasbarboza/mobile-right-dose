import 'meals.dart';

class Recommendation {
  String model;
  DateTime generatedAt;
  Meals meals;
  List<String> alerts;
  List<String> substitutions;
  Map<String, dynamic> profileApplied;

  Recommendation({
    required this.model,
    required this.generatedAt,
    required this.meals,
    required this.alerts,
    required this.substitutions,
    required this.profileApplied,
  });

  factory Recommendation.fromMap(Map<String, dynamic> map) {
    return Recommendation(
      model: map['model'] ?? '',
      generatedAt: DateTime.parse(map['generatedAt']),
      meals: Meals.fromMap(map['meals']),
      alerts: List<String>.from(map['alerts'] ?? []),
      substitutions: List<String>.from(map['substitutions'] ?? []),
      profileApplied: Map<String, dynamic>.from(map['profileApplied'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'generatedAt': generatedAt.toIso8601String(),
      'meals': meals.toJson(),
      'alerts': alerts,
      'substitutions': substitutions,
      'profileApplied': profileApplied,
    };
  }
}