class Dietary {
  final int id;
  final String code;
  final String description;

  Dietary({
    required this.id,
    required this.code,
    required this.description,
  });

  factory Dietary.fromJson(Map<String, dynamic> json) {
    return Dietary(
      id: json['id'],
      code: json['code'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
    };
  }
}
