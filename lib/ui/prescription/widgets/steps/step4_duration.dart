import 'package:flutter/material.dart';
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
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tempo de uso", style: customTextTitle()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Prescrição indefinida?", style: customTextLabel()),
              Switch(
                value: model.indefinite,
                onChanged: (v) => context.read<AddPrescriptionWizardModel>().setIndefinite(v),
              ),
            ],
          ),
          if (!model.indefinite)
            InputComponent(
              controller: totalOccCtrl,
              keyboardType: TextInputType.number,
              label: "Total de vezes",
              hint: "Informe o total de vezes",
              prefixIcon: Icons.calendar_today_outlined,
              obscureText: false,
              validator: (_) => null,
              onChanged: (v) => context.read<AddPrescriptionWizardModel>().setTotalOccurrences(int.tryParse(v)),
            ),
        ],
      ),
    );
  }
}