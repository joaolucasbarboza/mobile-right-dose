import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonSecondaryComponent extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool isLogout;
  final IconData? icon; // <- pode ser nulo

  const ButtonSecondaryComponent({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
    this.isLogout = false,
    this.icon,
  });

  @override
  State<ButtonSecondaryComponent> createState() =>
      _ButtonSecondaryComponentState();
}

class _ButtonSecondaryComponentState extends State<ButtonSecondaryComponent> {
  @override
  Widget build(BuildContext context) {
    final buttonStyle = OutlinedButton.styleFrom(
      backgroundColor:
      widget.isLogout ? Colors.red.shade400 : Colors.grey.shade100,
      foregroundColor: widget.isLogout ? Colors.white : Colors.black54,
      side: BorderSide(
        color: widget.isLogout ? Colors.red.shade700 : Colors.grey.shade300, // 👈 borda customizada
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: buttonStyle,
        onPressed: widget.onPressed,
        child: widget.isLoading
            ? CupertinoActivityIndicator(
          color: widget.isLogout
              ? CupertinoColors.white
              : CupertinoColors.black,
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null || widget.isLogout) ...[
              Icon(
                widget.icon ?? Icons.logout_outlined,
                size: 22,
              ),
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