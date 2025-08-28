import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonPrimaryComponent extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const ButtonPrimaryComponent({
    super.key,
    required this.text,
    required this.isLoading,
    this.onPressed,
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
          backgroundColor: WidgetStatePropertyAll(Colors.blue)
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
