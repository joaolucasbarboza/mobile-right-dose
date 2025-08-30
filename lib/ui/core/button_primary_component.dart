import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonPrimaryComponent extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final IconData icon; // <- agora usa IconData, mais consistente com o Secondary

  const ButtonPrimaryComponent({
    super.key,
    required this.text,
    required this.isLoading,
    this.onPressed,
    required this.icon,
  });

  @override
  State<ButtonPrimaryComponent> createState() => _ButtonPrimaryComponentState();
}

class _ButtonPrimaryComponentState extends State<ButtonPrimaryComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          backgroundColor: const WidgetStatePropertyAll(Colors.blue),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
        ),
        onPressed: widget.onPressed,
        child: widget.isLoading
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...[
            Icon(widget.icon, size: 22),
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