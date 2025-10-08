import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../utils/custom_text_style.dart';
import '../../../core/input_component.dart';
import 'add_prescription_wizard_model.dart';

class Step4Duration extends StatelessWidget {
  final TextEditingController totalOccCtrl;
  const Step4Duration({super.key, required this.totalOccCtrl});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddPrescriptionWizardModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 28,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tempo de uso", style: customTextTitle()),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Você vai tomar esse remédio por tempo indeterminado?",
                  style: const TextStyle(fontSize: 18),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              Switch(
                value: model.indefinite,
                onChanged: (v) =>
                    context.read<AddPrescriptionWizardModel>().setIndefinite(v),
              ),
            ],
          ),
          if (!model.indefinite)
            InputComponent(
              controller: totalOccCtrl,
              keyboardType: TextInputType.number,
              label: "Total de vezes",
              hint: "Informe o total de vezes",
              helperText: "Informe o quantas vezes você irá tomar o medicamento? (em dias)",
              prefixIcon: LucideIcons.calendar500,
              obscureText: false,
              validator: (_) => null,
              onChanged: (v) => context.read<AddPrescriptionWizardModel>().setTotalOccurrences(int.tryParse(v)),
            ),
        ],
      ),
    );
  }
}