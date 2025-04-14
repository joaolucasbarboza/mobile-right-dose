import 'package:flutter/material.dart';
import 'package:tcc/utils/custom_text_style.dart';

class MedicineCardComponent extends StatelessWidget {
  final int? id;
  final String name;
  final String unit;
  final int quantity;
  final Color backgroundColor;
  final Color colorIcon;
  final IconData icon;
  final VoidCallback? onTap;

  const MedicineCardComponent({
    super.key,
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.backgroundColor,
    required this.colorIcon,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.medication, size: 58, color: colorIcon),
              ),
              Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeFirstLetter(name),
                      style: customTextLabelPrimary(),
                    ),
                    Text(
                      capitalizeFirstLetter(unit.toLowerCase()),
                      style: customTextLabel(),
                    ),
                    Text(
                      "$quantity em estoque",
                      style: customTextSubtitle(quantity),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
