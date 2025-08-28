import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonSecondaryComponent extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool isLogout; // 👈 novo parâmetro

  const ButtonSecondaryComponent({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
    this.isLogout = false,
  });

  @override
  State<ButtonSecondaryComponent> createState() =>
      _ButtonSecondaryComponentState();
}

class _ButtonSecondaryComponentState extends State<ButtonSecondaryComponent> {
  @override
  Widget build(BuildContext context) {
    final buttonStyle = FilledButton.styleFrom(
      backgroundColor: widget.isLogout ? Colors.red.shade400 : null,
      foregroundColor: widget.isLogout ? Colors.white : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.tonal(
        style: buttonStyle,
        onPressed: widget.onPressed,
        child: widget.isLoading
            ? const CupertinoActivityIndicator(
          color: CupertinoColors.white,
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLogout) ...[
              const Icon(Icons.logout_outlined, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}