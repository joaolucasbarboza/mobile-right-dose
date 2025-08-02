import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/data/services/fcm_token_service.dart';
import '../../utils/routes.dart';

class AuthService extends ChangeNotifier {
  final String authLogin = Routes.authLogin;
  final String authRegister = Routes.authRegister;

  String? _token;
  String? get token => _token;

  bool get isAuthenticated => _token != null;

  AuthService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(authLogin),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data["token"];
      if (token != null) {
        _token = token;
        await saveToken(token);

        if (!Platform.isIOS) {
          await _sendFcmToken();
        }
        notifyListeners();
      }
      return token;
    } else if (response.statusCode == 401) {
      throw Exception("E-mail ou senha inválidos. Tente novamente!");
    } else {
      throw Exception("Erro ao fazer login");
    }
  }

  Future<String?> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(authRegister),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": "USER",
      }),
    );

    if (response.statusCode == 201) {
      return await login(email, password);
    } else {
      throw Exception("Erro ao criar uma nova conta.");
    }
  }

  Future<void> logout() async {
    _token = null;
    await removeToken();
    notifyListeners();
  }

  Future<void> _sendFcmToken() async {
    final fcmService = FcmService(this);
    try {
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.requestPermission();
        final fcmTokenIos = await FirebaseMessaging.instance.getAPNSToken();
        if (fcmTokenIos != null) {
          await fcmService.sendToken(fcmTokenIos);
        }
      } else {
        final fcmTokenAndroid = await FirebaseMessaging.instance.getToken();
        if (fcmTokenAndroid != null) {
          await fcmService.sendToken(fcmTokenAndroid);
        }
      }
    } catch (_) {
      print("Erro no sendFcmToken");
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}