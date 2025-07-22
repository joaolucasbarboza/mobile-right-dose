import 'dart:convert';

import 'package:tcc/data/repositories/prescription/prescription_repository.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/custom_http_client.dart';
import 'package:tcc/utils/routes.dart';

class PrescriptionService implements PrescriptionRepository {
  final String getPrescriptionUrl = Routes.getPrescription;
  final CustomHttpClient _httpClient;

  PrescriptionService(AuthService authService)
      : _httpClient = CustomHttpClient(authService);

  @override
  Future<List<Map<String, dynamic>>> getAllPrescriptions() async {
    final response = await _httpClient.get(
      Uri.parse(getPrescriptionUrl),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(
        'Failed to fetch prescriptions: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> addPrescription(Map<String, dynamic> prescriptionData) async {
    final String addPrescriptionUrl = Routes.addPrescription;

    print('Adding prescription with data: $prescriptionData');

    final response = await _httpClient.post(
      Uri.parse(addPrescriptionUrl),
      body: jsonEncode(prescriptionData),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to add prescription: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
