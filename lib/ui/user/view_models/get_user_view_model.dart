// todo: implementar a busca de todas as doenças do usuário
// todo: implementar a adicição de N doenças ao usuário
//  dependendo do quantas doenças, tem que ser proporcional POST no backend. Fazer um for talvez?

import 'package:flutter/material.dart';
import 'package:tcc/data/services/health_service.dart';
import 'package:tcc/models/disease.dart';
import 'package:tcc/models/userDietary.dart';

class GetUserViewModel extends ChangeNotifier {
  final HealthService _healthService;

  GetUserViewModel(this._healthService);

  final List<Disease> _userDiseases = [];
  final List<UserDietary> _userDietaries = [];

  List<Disease> get prescriptions => _userDiseases;

  List<UserDietary> get userDietaries => _userDietaries;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadUserDiseases() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _healthService.getDiseases();
      final diseases = toList<Disease>(response, (e) => Disease.fromJson(e));
      _userDiseases
        ..clear()
        ..addAll(diseases);
    } catch (e) {
      errorMessage = 'Failed to load diseases: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserDietaries() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _healthService.getDietaries();
      print(response);
      final userDietaries = toList<UserDietary>(response, (e) => UserDietary.fromJson(e));
      _userDietaries
        ..clear()
        ..addAll(userDietaries);
    } catch (e) {
      errorMessage = 'Failed to load diseases: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<T> toList<T>(
      List<Map<String, dynamic>> response,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    return response.map((e) => fromJson(e)).toList();
  }
}
