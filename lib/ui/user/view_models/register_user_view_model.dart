import 'package:flutter/material.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/ui/user/widgets/disease_screen.dart';

class RegisterUserViewModel with ChangeNotifier {
  final AuthService authService;

  RegisterUserViewModel(this.authService);

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> registerUser(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();

      try {
        final token = await authService.register(
          nameController.text,
          emailController.text,
          passwordController.text,
        );

        if (token != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DiseaseScreen(),
            ),
                (route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              showCloseIcon: true,
              backgroundColor: Colors.green,
              content: Row(
                children: const [
                  Icon(
                    Icons.check_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Conta criada com sucesso!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.fixed,
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
