import 'package:flutter/material.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/ui/core/navigationBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text("E-mail"),
                    hintText: "nome@exemplo.com",
                    prefixIcon: Icon(Icons.mail_rounded),
                  ),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Digite um e-mail.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    label: Text("Senha"),
                    hintText: "Digite sua senha",
                    prefixIcon: Icon(Icons.password_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: _isObscure
                          ? Icon(Icons.remove_red_eye_rounded)
                          : Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Digite uma senha.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.redAccent)
                      : Text("Entrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final token = await _authService.login(
          _emailController.text,
          _passwordController.text,
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}