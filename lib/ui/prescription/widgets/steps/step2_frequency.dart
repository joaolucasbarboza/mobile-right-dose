import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/custom_text_style.dart';
import 'add_prescription_wizard_model.dart';

class Step2Frequency extends StatelessWidget {
  const Step2Frequency({super.key});

  static const _units = [
    {'label': 'hora(s)', 'plural': 'horas', 'enum': 'HOURLY'},
    {'label': 'dia(s)',  'plural': 'dias',  'enum': 'DAILY'},
  ];

  String _formatFrequency(int? value, String? unitEnum) {
    if (value == null || unitEnum == null) return "Definir intervalo";
    final isDaily = unitEnum == "DAILY";
    final singular = isDaily ? "dia" : "hora";
    final plural   = isDaily ? "dias" : "horas";
    return "A cada $value ${value == 1 ? singular : plural}";
  }

  void _openCupertinoPickers(BuildContext context) {
    final model = context.read<AddPrescriptionWizardModel>();

    int selectedNumber = model.frequency ?? 8;
    int unitIndex = model.uomFrequency == "DAILY" ? 1 : 0;

    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 320,
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            final unitEnum = _units[unitIndex]['enum'] as String;
                            model.setFrequency(selectedNumber, unitEnum);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Concluir",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 36,
                            onSelectedItemChanged: (int value) {},
                            children: [
                              Text(
                                "A cada",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        // Picker de número
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 36,
                            scrollController: FixedExtentScrollController(
                              initialItem: (selectedNumber - 1).clamp(0, 23),
                            ),
                            onSelectedItemChanged: (i) {
                              setState(() => selectedNumber = i + 1);
                            },
                            children: List<Widget>.generate(24, (i) {
                              final n = i + 1;
                              return Center(
                                child: Text(n.toString(), style: const TextStyle(fontSize: 18)),
                              );
                            }),
                          ),
                        ),

                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 36,
                            scrollController: FixedExtentScrollController(initialItem: unitIndex),
                            onSelectedItemChanged: (i) {
                              setState(() => unitIndex = i);
                            },
                            children: _units.map((u) {
                              return Center(
                                child: Text(u['label'] as String, style: const TextStyle(fontSize: 18)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddPrescriptionWizardModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Frequência de uso", style: customTextTitle()),

          GestureDetector(
            onTap: () => _openCupertinoPickers(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Frequência",
                hintText: "Toque para escolher",
                prefixIcon: const Icon(Icons.schedule),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 1.5, color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 1.5, color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatFrequency(model.frequency, model.uomFrequency),
                    style: TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}