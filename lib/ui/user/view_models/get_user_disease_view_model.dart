// todo: implementar a busca de todas as doenças do usuário
// todo: implementar a adicição de N doenças ao usuário
//  dependendo do quantas doenças, tem que ser proporcional POST no backend. Fazer um for talvez?

import 'package:flutter/material.dart';
import 'package:tcc/data/services/health_service.dart';
import 'package:tcc/models/disease.dart';

class GetUserDiseaseViewModel extends ChangeNotifier {
  final HealthService _healthService;

  GetUserDiseaseViewModel(this._healthService);

  final List<Disease> _userDiseases = [];


  List<Disease> get prescriptions => _userDiseases;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadUserDiseases() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _healthService.getDiseases();
      _userDiseases
        ..clear()
        ..addAll(toList(response));
    } catch (e) {
      errorMessage = 'Failed to load diseases: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Disease> toList(List<Map<String, dynamic>> response) {
    return response.map((e) => Disease.fromJson(e)).toList();
  }
}