import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonSecondaryComponent extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const ButtonSecondaryComponent({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<ButtonSecondaryComponent> createState() =>
      _ButtonSecondaryComponentState();
}

class _ButtonSecondaryComponentState extends State<ButtonSecondaryComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.tonal(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
        ),
        onPressed: widget.onPressed,
        child: widget.isLoading
            ? CupertinoActivityIndicator(color: CupertinoColors.white,)
            : Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
