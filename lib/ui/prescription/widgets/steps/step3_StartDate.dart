import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../utils/custom_text_style.dart';
import 'add_prescription_wizard_model.dart';

class Step3StartDate extends StatelessWidget {
  const Step3StartDate({super.key});

  Future<void> _showCupertinoPickerSheet({
    required BuildContext context,
    required Widget picker,
    required VoidCallback onConfirm,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 320,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            // barra de ações
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
                      onConfirm();
                      Navigator.pop(context);
                    },
                    child: const Text("Concluir", style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: picker),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateCupertino(BuildContext context) async {
    final model = context.read<AddPrescriptionWizardModel>();
    final current = model.startDate ?? DateTime.now();
    DateTime temp = current;

    await _showCupertinoPickerSheet(
      context: context,
      picker: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: current,
        minimumDate: DateTime(2020),
        maximumDate: DateTime(2100),
        onDateTimeChanged: (v) => temp = DateTime(v.year, v.month, v.day, current.hour, current.minute),
      ),
      onConfirm: () => model.setStartDate(temp),
    );
  }

  Future<void> _pickTimeCupertino(BuildContext context) async {
    final model = context.read<AddPrescriptionWizardModel>();
    final current = model.startDate ?? DateTime.now();
    DateTime temp = current;

    await _showCupertinoPickerSheet(
      context: context,
      picker: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        use24hFormat: true,
        initialDateTime: current,
        onDateTimeChanged: (v) => temp = DateTime(current.year, current.month, current.day, v.hour, v.minute),
      ),
      onConfirm: () => model.setStartDate(temp),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddPrescriptionWizardModel>();

    final dfDate = DateFormat('d \'de\' MMMM \'de\' yyyy', 'pt_BR');
    final dfTime = DateFormat('HH:mm', 'pt_BR');

    final hasValue = model.startDate != null;
    final dateText = hasValue ? dfDate.format(model.startDate!) : 'Selecione';
    final timeText = hasValue ? dfTime.format(model.startDate!) : 'Selecione';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 28,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Início do tratamento", style: customTextTitle()),
          GestureDetector(
            onTap: () => _pickDateCupertino(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Data de início",
                hintText: "Selecione",
                helperText: "Qual a data que você irá começar a tomar?",
                prefixIcon: const Icon(
                  LucideIcons.calendar500,
                  size: 28,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 1.5, color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 1.5, color: Colors.grey.shade200),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  dateText,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _pickTimeCupertino(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Horarío",
                hintText: "Selecione",
                helperText: "Qual o horário?",
                prefixIcon: const Icon(
                  LucideIcons.clock2500,
                  size: 28,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 1.5, color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 1.5, color: Colors.grey.shade200),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  timeText,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
