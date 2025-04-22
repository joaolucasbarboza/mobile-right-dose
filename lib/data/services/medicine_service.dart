import 'dart:convert';

import 'package:tcc/data/services/custom_http_client.dart';
import 'package:tcc/models/medicine.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/utils/routes.dart';

import '../repositories/medicine/medicine_repository.dart';

class MedicineService implements MedicineRepository {
  final String getMedicineUrl = Routes.getMedicine;
  final CustomHttpClient _httpClient;

  MedicineService(AuthService authService)
      : _httpClient = CustomHttpClient(authService);

  @override
  Future<void> addMedicine(Map<String, dynamic> medicine) async {
    final response = await _httpClient.post(Uri.parse(getMedicineUrl),
        body: jsonEncode(medicine));

    if (response.statusCode != 201) {
      throw Exception("Erro ao adicionar medicamento");
    }
  }

  @override
  Future<Medicine> getMedicineById(int id) async {
    final response = await _httpClient.get(
      Uri.parse("$getMedicineUrl/$id"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Medicine.fromMap(data);
    } else {
      throw Exception("Erro ao buscar medicamento");
    }
  }

  @override
  Future<List<Medicine>> getAllMedicine() async {
    final response = await _httpClient.get(
      Uri.parse(getMedicineUrl),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Medicine.fromMap(e)).toList();
    } else {
      throw Exception("Erro ao buscar medicamentos");
    }
  }
}
