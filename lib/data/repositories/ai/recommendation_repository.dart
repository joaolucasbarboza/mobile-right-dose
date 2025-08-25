import 'package:tcc/models/recommendation.dart';

abstract class RecommendationRepository {
  Future<Recommendation> generateRecommendation();
}