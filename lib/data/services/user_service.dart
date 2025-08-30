import 'dart:convert';

import 'package:tcc/data/repositories/user/user_repository.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/custom_http_client.dart';
import 'package:tcc/utils/routes.dart';

class UserService implements UserRepository {
  final String getUserUrl = Routes.getUser;
  final CustomHttpClient _httpClient;

  UserService(AuthService authService) : _httpClient = CustomHttpClient(authService);

  @override
  Future<Map<String, dynamic>> getDetailsUser() async {
    final response = await _httpClient.get(
      Uri.parse(getUserUrl),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data);
    } else {
      throw Exception(
        'Failed to fetch user: ${response.statusCode}',
      );
    }
  }
}
