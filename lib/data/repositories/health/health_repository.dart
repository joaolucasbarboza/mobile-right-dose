import 'package:tcc/data/dto/disease_dto.dart';

abstract class HealthRepository {
  Future<List<Map<String, dynamic>>> getDiseases();
  Future<void> addDisease(Map<String, dynamic> diseaseData);
  Future<List<DiseaseDTO>> searchDiseases();
}