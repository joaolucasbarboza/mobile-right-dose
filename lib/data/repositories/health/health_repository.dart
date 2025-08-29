import 'package:tcc/data/dto/disease_dto.dart';
import 'package:tcc/models/dietary.dart';

abstract class HealthRepository {
  Future<List<Map<String, dynamic>>> getDiseases();
  Future<int> addDisease(Map<String, dynamic> diseaseData);
  Future<List<DiseaseDTO>> searchDiseases();

  Future<List<Dietary>> searchDietaries();
  Future<int> addDietary(Map<String, dynamic> dietaryData);
}