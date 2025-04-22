import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/user/view_models/login_user_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginUserViewModel>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: provider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Entrar"),
                TextFormField(
                  controller: provider.emailController,
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
                  controller: provider.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: provider.isObscure,
                  decoration: InputDecoration(
                    label: Text("Senha"),
                    hintText: "Digite sua senha",
                    prefixIcon: Icon(Icons.password_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          provider.isObscure = !provider.isObscure;
                        });
                      },
                      icon: provider.isObscure
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
                  onPressed: () => {
                    provider.login(context)
                  },
                  child: provider.isLoading
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
}
