class Meals {
  String breakfast;
  String lunch;
  String dinner;
  String snackMorning;
  String snackAfternoon;

  Meals({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snackMorning,
    required this.snackAfternoon,
  });

  factory Meals.fromMap(Map<String, dynamic> map) {
    return Meals(
      breakfast: map['breakfast'] ?? '',
      lunch: map['lunch'] ?? '',
      dinner: map['dinner'] ?? '',
      snackMorning: map['snackMorning'] ?? '',
      snackAfternoon: map['snackAfternoon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'snackMorning': snackMorning,
      'snackAfternoon': snackAfternoon,
    };
  }
}