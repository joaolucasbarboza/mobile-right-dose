import 'dart:convert';

import 'package:tcc/data/repositories/ai/recommendation_repository.dart';
import 'package:tcc/data/services/custom_http_client.dart';
import 'package:tcc/models/recommendation.dart';
import 'package:tcc/utils/routes.dart';

import 'auth_service.dart';

class RecommendationService implements RecommendationRepository {
  final String generateRecommendationUrl = Routes.generateRecommendation;
  final CustomHttpClient _httpClient;

  RecommendationService(AuthService authService)
      : _httpClient = CustomHttpClient(authService);

  @override
  Future<Recommendation> generateRecommendation() async {
    final response = await _httpClient.get(
      Uri.parse(generateRecommendationUrl),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Recommendation.fromMap(data);
    } else {
      throw Exception(
        'Failed to generate recommendation: ${response.statusCode} - ${response.body}',
      );
    }

  }

}