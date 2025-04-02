import 'dart:convert';

import 'package:tcc/services/auth_service.dart';
import 'package:tcc/utils/constants.dart';
import 'package:http/http.dart' as http;

class MedicineService {
  final String getMedicine = AppConstants.getMedicine;
  final _authService = AuthService();

  Future<List<Map<String, dynamic>>> medicine() async {
    final getToken = await _authService.getToken();

    final response = await http.get(
      Uri.parse(getMedicine),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $getToken",
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Erro ao buscar medicamentos");
    }
  }

  Future<void> addMedicine(Map<String, dynamic> medicine) async {
    final getToken = await _authService.getToken();

    final response = await http.post(
      Uri.parse(AppConstants.getMedicine),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $getToken",
      },
      body: jsonEncode(medicine),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar medicamento");
    }
  }
}