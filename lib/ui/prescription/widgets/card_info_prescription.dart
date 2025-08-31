import 'package:flutter/material.dart';

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
          spacing: 18,
          children: [
            icon,
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryLabel,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                  ),
                  Text(
                    secondaryLabel,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey.shade800),
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