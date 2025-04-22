import 'package:flutter/material.dart';
import 'package:tcc/utils/custom_text_style.dart';

class CardInfoPrescription extends StatelessWidget {
  final Icon icon;
  final String primaryLabel;
  final String secondaryLabel;

  const CardInfoPrescription({
    super.key,
    required this.icon,
    required this.primaryLabel,
    required this.secondaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card.filled(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            spacing: 10,
            children: [
              icon,
              Expanded(
                // <- Aqui está a chave pra evitar overflow
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
                      style: customTextLabel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
