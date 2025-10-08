import 'dart:convert';

import 'package:tcc/data/repositories/prescription/prescription_repository.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/custom_http_client.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/models/prescription_notification.dart';
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

  @override
  Future<Prescription> getById(int id) async {
    final String getByIdUrl = Routes.getPrescription;

    final url = Uri.parse('$getByIdUrl/$id');

    final response = await _httpClient.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Prescription.fromMap(data);
    } else {
      throw Exception(
        'Failed to fetch prescription by ID: ${response.statusCode}',
      );
    }
  }

  @override
  Future<PrescriptionNotification> updateStatus(int id, String status) async {
    final String updateStatusUrl = Routes.updatePrescriptionStatus;

    Map<String, dynamic> body = {
      'notificationId': id,
      'status': status,
    };

    final response = await _httpClient.patch(
      Uri.parse(updateStatusUrl),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PrescriptionNotification.fromMap(data);
    } else {
      throw Exception(
        'Failed to update prescription status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> deleteByIdPrescription(int id) {
    final String deleteByIdUrl = Routes.deleteByIdPrescription;

    final url = Uri.parse('$deleteByIdUrl/$id');

    return _httpClient.delete(url).then((response) {
      if (response.statusCode != 204) {
        throw Exception(
          'Failed to delete prescription: ${response.statusCode}',
        );
      }
    });
  }

  @override
  Future<void> changeWantsNotifications(int id) async {
    final String changeWantsNotificationsUrl =
        Routes.getPrescription;

    final url = Uri.parse('$changeWantsNotificationsUrl/$id/wants-notification');

    final response = await _httpClient.patch(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to change wants notifications: ${response.statusCode}',
      );
    }
  }
}
