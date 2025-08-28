class DiseaseDTO {
  final int id;
  final String code;
  final String description;

  DiseaseDTO({
    required this.id,
    required this.code,
    required this.description,
  });

  factory DiseaseDTO.fromJson(Map<String, dynamic> json) {
    return DiseaseDTO(
      id: json['id'],
      code: json['code'],
      description: json['description'],
    );
  }
}