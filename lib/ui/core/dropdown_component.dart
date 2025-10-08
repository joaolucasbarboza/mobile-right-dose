import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DropdownComponent<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuEntry<T>> items;
  final void Function(T?)? onSelected;
  final IconData? leadingIcon;

  final Widget? trailingIcon;
  final double? menuHeight;
  final BorderRadius? menuBorderRadius;
  final Color? menuBackgroundColor;
  final TextStyle? textStyle;
  final bool expanded;
  final String? helperText;

  const DropdownComponent({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onSelected,
    this.leadingIcon,
    this.trailingIcon,
    this.menuHeight,
    this.menuBorderRadius,
    this.menuBackgroundColor,
    this.textStyle,
    this.expanded = true,
    this.helperText
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenuFormField<T>(
      initialSelection: value,
      onSelected: onSelected,
      dropdownMenuEntries: items,
      width: double.maxFinite,

      enableFilter: true,

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),

      label: Text(label),
      trailingIcon: trailingIcon ?? const Icon(LucideIcons.chevronDown500),
      helperText: helperText,

      menuHeight: menuHeight,
      menuStyle: MenuStyle(
        maximumSize: const WidgetStatePropertyAll(Size.fromHeight(250)),
        backgroundColor:
        WidgetStatePropertyAll(menuBackgroundColor ?? Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: menuBorderRadius ?? BorderRadius.circular(12),
          ),
        ),
      ),
      textStyle:
      textStyle ?? const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}