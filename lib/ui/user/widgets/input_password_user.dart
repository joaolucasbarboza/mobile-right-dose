import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tcc/ui/core/input_component.dart';

class InputPasswordUser extends StatefulWidget {
  final TextEditingController controller;

  const InputPasswordUser({super.key, required this.controller});

  @override
  State<InputPasswordUser> createState() => _InputPasswordUserState();
}

class _InputPasswordUserState extends State<InputPasswordUser> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return InputComponent(
      controller: widget.controller,
      hint: "Digite sua senha",
      label: "Senha",
      prefixIcon: LucideIcons.keyRound500,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _isObscure,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _isObscure = !_isObscure;
          });
        },
        icon: Icon(
          _isObscure
              ? LucideIcons.eye400
              : LucideIcons.eyeClosed400,
        ),
      ),
      validator: (password) {
        if (password == null || password.isEmpty) {
          return "Digite sua senha.";
        }
        return null;
      },
    );
  }
}
