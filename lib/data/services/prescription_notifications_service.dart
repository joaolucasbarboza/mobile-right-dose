import 'dart:convert';

import 'package:tcc/data/repositories/prescription_notification/prescription_notification_respository.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/custom_http_client.dart';
import 'package:tcc/models/prescription_notification.dart';
import 'package:tcc/utils/routes.dart';

class PrescriptionNotificationService implements PrescriptionNotificationRepository {
  final CustomHttpClient _httpClient;

  PrescriptionNotificationService(AuthService authService) : _httpClient = CustomHttpClient(authService);

  @override
  Future<List<PrescriptionNotification>> getAllUpcomingNotifications() async {
    final String getAllUpcomingNotificationsUrl = Routes.getAllUpcomingNotifications;
    final uri = Uri.parse(getAllUpcomingNotificationsUrl).replace(queryParameters: {
      'page': '0',
      'size': '3',
    });
    try {
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(body);

        final List<dynamic> content = data['content'] ?? [];

        return content.map((e) => PrescriptionNotification.fromMap(e as Map<String, dynamic>)).toList();
      } else {
        throw Exception(
          'Failed to fetch upcoming notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch upcoming notifications: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getById(int id) async {
    final uri = Uri.parse('${Routes.getPrescriptionNotificationById}/$id');

    try {
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(body) as Map<String, dynamic>;
        return data;
      } else if (response.statusCode == 404) {
        throw Exception('Notification $id not found (404).');
      } else {
        throw Exception('Failed to fetch notification by id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch notification by id: $e');
    }
  }
}
