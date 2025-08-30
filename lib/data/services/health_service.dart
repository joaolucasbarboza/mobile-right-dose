import 'dart:convert';

import 'package:tcc/data/dto/disease_dto.dart';
import 'package:tcc/models/dietary.dart';

import '../../utils/routes.dart';
import '../repositories/health/health_repository.dart';
import 'auth_service.dart';
import 'custom_http_client.dart';

class HealthService implements HealthRepository {
  final String addDiseaseUrl = Routes.addDisease;
  final String searchDiseaseUrl = Routes.searchDisease;
  final String getDiseasesUrl = Routes.getAllDiseases;

  final String searchDietaryUrl = Routes.searchDietary;
  final String addDietaryUrl = Routes.addDietary;
  final String getDietariesUrl = Routes.getAllDietaries;

  final CustomHttpClient _httpClient;

  HealthService(AuthService authService)
      : _httpClient = CustomHttpClient(authService);

  @override
  Future<int> addDisease(Map<String, dynamic> diseaseData) async {

    final response = await _httpClient.post(
      Uri.parse(addDiseaseUrl),
      body: jsonEncode(diseaseData),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to add disease: ${response.statusCode} - ${response.body}',
      );
    }

    return response.statusCode;
  }

  @override
  Future<List<Map<String, dynamic>>> getDiseases() async {
    final uri = Uri.parse(getDiseasesUrl);

    final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        return List<Map<String, dynamic>>.from(jsonList);
      } else {
        throw Exception("Erro ao buscar doenças: ${response.statusCode}");
      }
  }

  @override
  Future<List<DiseaseDTO>> searchDiseases() async {
    final uri = Uri.parse(searchDiseaseUrl);

    final response = await _httpClient.get(uri);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return jsonList
          .map((e) => DiseaseDTO.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Erro ao buscar doenças: ${response.statusCode}");
    }
  }

  @override
  Future<int> addDietary(Map<String, dynamic> diseaseData) async {

    final response = await _httpClient.post(
      Uri.parse(addDietaryUrl),
      body: jsonEncode(diseaseData),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to add dietary: ${response.statusCode} - ${response.body}',
      );
    }

    return response.statusCode;
  }

  @override
  Future<List<Map<String, dynamic>>> getDietaries() async {
    final uri = Uri.parse(getDietariesUrl);

    final response = await _httpClient.get(uri);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return List<Map<String, dynamic>>.from(jsonList);
    } else {
      throw Exception("Erro ao buscar doenças: ${response.statusCode}");
    }
  }

  @override
  Future<List<Dietary>> searchDietaries() async {
    final uri = Uri.parse(searchDietaryUrl);

    final response = await _httpClient.get(uri);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return jsonList
          .map((e) => Dietary.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Erro ao buscar doenças: ${response.statusCode}");
    }
  }


}