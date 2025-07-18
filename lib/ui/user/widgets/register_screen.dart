import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/input_component.dart';
import 'package:tcc/ui/user/view_models/register_user_view_model.dart';
import 'package:tcc/ui/user/widgets/input_email_user.dart';
import 'package:tcc/ui/user/widgets/input_password_user.dart';
import 'package:tcc/utils/custom_text_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterUserViewModel>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Criar uma nova conta",
                  style: customTextTitle(),
                ),
                Text(
                  "Crie sua conta para organizar seus medicamentos e cuidar melhor da sua saúde.",
                  style: customTextLabel(),
                ),
              ],
            ),
            Form(
              key: provider.formKey,
              child: Column(
                spacing: 22,
                children: [
                  InputComponent(
                    controller: provider.nameController,
                    label: "Nome completo",
                    hint: "Digite seu nome",
                    prefixIcon: Icons.account_circle_outlined,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Digite seu nome";
                      }
                      return null;
                    },
                  ),
                  InputEmailUser(
                    controller: provider.emailController,
                  ),
                  InputPasswordUser(
                    controller: provider.passwordController,
                  ),
                ],
              ),
            ),
            ButtonPrimaryComponent(
              onPressed: () {
                provider.registerUser(context);
              },
              isLoading: provider.isLoading,
              text: "Criar conta",
            ),
          ],
        ),
      ),
    );
  }
}
