import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/ui/prescription/widgets/card_info_prescription.dart';
import 'package:tcc/utils/custom_text_style.dart';
import 'package:tcc/utils/format_strings.dart';

class TextDetailsPrescriptionComponent extends StatelessWidget {
  final Prescription prescription;

  const TextDetailsPrescriptionComponent({
    super.key,
    required this.prescription,
  });

  static final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final String dosageAmount = prescription.dosageAmount.toString();
    final String dosageUnit = prescription.dosageUnit;
    final String uomFrequency = prescription.uomFrequency;
    final String frequency = prescription.frequency.toString();
    final String totalDays = prescription.totalDays.toString();
    final String startDate = _dateFormat.format(prescription.startDate);
    final String endDate = _dateFormat.format(prescription.endDate);
    final String instructions = prescription.instructions.toString();
    final bool wantsNotifications = prescription.wantsNotifications;
    final String medicineName = prescription.medicine.name;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Text(
              medicineName,
              style: customTextTitle(),
            ),
          ],
        ),
        Column(
          children: [
            CardInfoPrescription(
              icon: const Icon(
                Icons.medication_rounded,
                color: Colors.amber,
                size: 36,
              ),
              color: Colors.amber,
              primaryLabel: "Dosagem a ser tomada",
              secondaryLabel: '$dosageAmount ${formatDosageUnit(dosageUnit)}'
            ),
            const SizedBox(height: 12),
            CardInfoPrescription(
              icon: const Icon(
                Icons.access_time_outlined,
                color: Colors.deepPurpleAccent,
                size: 36,
              ),
              color: Colors.deepPurpleAccent,
              primaryLabel: "Intervalo",
              secondaryLabel: uomFrequency == 'HOURLY'
                  ? "A cada $frequency ${formatUomFrequency(uomFrequency)}"
                  : "$frequency vez(es) ao dia",
            ),
          ],
        ),
        Text(
          "Instruções de uso",
          style: customTextLabelPrimary(),
        ),
        Text(instructions.isNotEmpty
            ? instructions
            : "Nenhuma instrução adicional."),
        Divider(),
        Text(
          "Detalhes",
          style: customTextLabelPrimary(),
        ),
        Text("Tomar a medicação por $totalDays dias"),
        Text("Período: $startDate até $endDate"),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Notificações",
              style: customTextLabelPrimary(),
            ),
            Switch(
              activeColor: Colors.green,
              value: wantsNotifications,
              onChanged: (value) {},
            ),
          ],
        )
      ],
    );
  }
}
