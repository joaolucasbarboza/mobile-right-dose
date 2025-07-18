import 'package:flutter/material.dart';
import 'package:tcc/ui/core/input_component.dart';

class InputEmailUser extends StatefulWidget {
  final TextEditingController controller;

  const InputEmailUser({super.key, required this.controller});

  @override
  State<InputEmailUser> createState() => _InputEmailUserState();
}

class _InputEmailUserState extends State<InputEmailUser> {
  @override
  Widget build(BuildContext context) {
    return InputComponent(
      controller: widget.controller,
      label: "E-mail",
      hint: "nome@exemplo.com",
      prefixIcon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
      validator: (email) {
        if (email == null || email.isEmpty) {
          return "Digite um e-mail.";
        }
        return null;
      },
    );
  }
}
