import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/ui/user/view_models/login_user_view_model.dart';
import 'package:tcc/ui/user/widgets/input_email_user.dart';
import 'package:tcc/ui/user/widgets/input_password_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginUserViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 28,
            children: [
              SizedBox(height: 40,),
              Image(image: AssetImage("assets/logo.png"), width: 300,),
              Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputEmailUser(
                      controller: provider.emailController,
                    ),
                    SizedBox(height: 18),
                    InputPasswordUser(controller: provider.passwordController),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: isRememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    isRememberMe = !isRememberMe;
                                  });
                                }),
                            Text("Lembrar-me")
                          ],
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              "/forgot-password",
                            );
                          },
                          child: Text(
                            "Esqueceu a senha?",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 24),

                    ButtonPrimaryComponent(
                      icon: LucideIcons.arrowBigRight300,
                      text: "Entrar",
                      isLoading: provider.isLoading,
                      onPressed: () {
                        provider.login(context);
                      },
                    ),

                    SizedBox(height: 18),

                    Text("Não tem uma conta?"),

                    SizedBox(height: 6),

                    ButtonSecondaryComponent(
                      icon: LucideIcons.userPlus300,
                      text: "Criar conta",
                      isLoading: false,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/register",
                        );
                      },
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
