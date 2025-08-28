import 'package:tcc/data/dto/disease_dto.dart';

abstract class HealthRepository {
  Future<List<String>> getDiseases();
  Future<void> addDisease(Map<String, dynamic> diseaseData);
  Future<List<DiseaseDTO>> searchDiseases();
}