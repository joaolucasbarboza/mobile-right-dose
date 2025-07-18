import 'package:flutter/material.dart';
import 'package:tcc/data/services/auth_service.dart';

class LoginUserViewModel with ChangeNotifier {
  final AuthService authService;

  LoginUserViewModel(this.authService);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();

      try {
        final token = await authService.login(
          emailController.text,
          passwordController.text,
        );

        if (token != null) {
          await authService.saveToken(token);

          Navigator.pushReplacementNamed(context, '/home');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              showCloseIcon: true,
              backgroundColor: Colors.green,
              content: Row(
                children: [
                  const Icon(
                    Icons.check_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Login realizado com sucesso!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              behavior: SnackBarBehavior.fixed,
            ),
          );
        }
      } catch (e) {
        print(e);
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
