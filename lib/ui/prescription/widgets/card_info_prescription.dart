import 'package:flutter/material.dart';
import 'package:tcc/utils/custom_text_style.dart';

class CardInfoPrescription extends StatelessWidget {
  final Icon icon;
  final Color color;
  final String primaryLabel;
  final String secondaryLabel;

  const CardInfoPrescription({
    super.key,
    required this.icon,
    required this.color,
    required this.primaryLabel,
    required this.secondaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryLabel,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: customTextLabelPrimary(),
                  ),
                  Text(
                    secondaryLabel,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: customTextLabelPrimary(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}