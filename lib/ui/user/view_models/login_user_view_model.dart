import 'package:flutter/material.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/ui/core/navigationBar.dart';

class LoginUserViewModel with ChangeNotifier {
  final AuthService authService;

  LoginUserViewModel(this.authService);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();
  bool isObscure = true;
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();

      try {
        final token = await _authService.login(
          emailController.text,
          passwordController.text,
        );

        if (token != null) {
          await _authService.saveToken(token);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationComponent(),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
