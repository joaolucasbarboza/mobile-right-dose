import 'package:flutter/material.dart';

String capitalizeFirstLetter(String string) {
  return string.isNotEmpty ? string[0].toUpperCase() + string.substring(1) : '';
}

TextStyle customTextLabel() {
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey.shade700,
  );
}

TextStyle customTextLabel2() {
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.grey.shade600,
  );
}

TextStyle customTextLabelPrimary() {
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.grey.shade600,
  );
}

TextStyle customTextSubtitle(int quantity) {
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: quantity > 10 ? Colors.green : Colors.red,
  );
}

TextStyle customTextTitle() {
  return TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}

TextStyle customTextTitleSecondary() {
  return TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: Colors.black54,
  );
}

TextStyle customTextTitleSecondaryBlack() {
  return TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
}
