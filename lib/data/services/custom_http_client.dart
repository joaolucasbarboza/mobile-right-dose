import 'package:http/http.dart' as http;
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/utils/navigator_service.dart'; // Explicarei isso abaixo

class CustomHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthService _authService;

  CustomHttpClient(this._authService);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _authService.getToken();

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/json';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401) {
      NavigatorService.navigateToLogin();
    }

    return response;
  }
}