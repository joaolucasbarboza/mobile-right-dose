import 'package:flutter/foundation.dart';
import 'package:tcc/models/recommendation.dart';

import '../../../data/services/recommendation_service.dart';

class GenerateAiViewModel with ChangeNotifier {
  final RecommendationService _service;

  GenerateAiViewModel(this._service);

  bool _isLoading = false;
  bool _isGenerating = false;
  Recommendation? _data;
  String? _error;

  bool get isLoading => _isLoading;
  Recommendation? get data => _data;
  String? get error => _error;

  Future<void> generateRecommendation() async {
    if (_isGenerating) return; // dedupe

    _isLoading = true;
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.generateRecommendation();
      _data = result;
    } catch (e, st) {
      debugPrint('Erro ao gerar recomendação: $e\n$st');
      _error = 'Não foi possível gerar recomendações agora.';
    } finally {
      _isLoading = false;
      _isGenerating = false;
      notifyListeners();
    }
  }

  void clear() {
    _data = null;
    _error = null;
    notifyListeners();
  }
}