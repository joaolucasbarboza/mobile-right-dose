import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/routes.dart';

class AuthService {
  final String authLogin = Routes.authLogin;

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(authLogin),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    } else if (response.statusCode == 401) {
      throw Exception(
          "E-mail ou senha inválidos. Tente novamente!");
    } else {
      throw Exception("Erro ao fazer login");
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", "$token");
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
