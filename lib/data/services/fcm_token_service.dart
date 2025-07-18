import 'dart:convert';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/custom_http_client.dart';
import 'package:tcc/utils/routes.dart';

class FcmService {
  final CustomHttpClient _httpClient;
  final String _fcmTokenUrl = Routes.fcmTokenUrl;

  FcmService(AuthService authService)
      : _httpClient = CustomHttpClient(authService);

  Future<void> sendToken(String token) async {
    final body = jsonEncode({"fcmToken": token});

    final response = await _httpClient.put(
      Uri.parse(_fcmTokenUrl),
      body: body,
    );

    if (response.statusCode == 200) {
      print("FCM token enviado com sucesso.");
    } else {
      throw Exception("Erro ao enviar FCM token: ${response.body}");
    }
  }
}
