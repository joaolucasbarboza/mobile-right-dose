import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/ui/prescription/widgets/card_info_prescription.dart';
import 'package:tcc/utils/custom_text_style.dart';

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
    final String medicineDescription = prescription.medicine.description;
    final String medicineDosageAmount =
        prescription.medicine.dosagePerUnit?.dosageAmount.toString() ?? '-';
    final String medicineDosageUnit =
        prescription.medicine.dosagePerUnit?.dosageUnit ?? '-';
    final String medicineUnit = prescription.medicine.unit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          medicineName,
          style: customTextTitle(),
        ),
        Text(
          "$medicineDosageAmount $medicineDosageUnit",
          style: TextStyle(color: Colors.black87),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            CardInfoPrescription(
              icon: Icon(Icons.medication_rounded),
              primaryLabel: "Tomar",
              secondaryLabel:
                  '${prescription.dosageAmount} ${prescription.dosageUnit}',
            ),
            CardInfoPrescription(
              icon: Icon(Icons.access_time_outlined),
              primaryLabel: "Intervalo",
              secondaryLabel:
                  '${prescription.frequency} ${prescription.uomFrequency}',
            ),
          ],
        ),
        Divider(),
        Text("Duração: $totalDays dias"),
        Text("Período: $startDate até $endDate"),
        Divider(),
        Text("Instruções Adicionais:"),
        Text(instructions.isNotEmpty
            ? instructions
            : "Nenhuma instrução adicional."),
        Divider(),
        Text(
            "Notificações: ${wantsNotifications ? "Ativadas" : "Desativadas"}"),
      ],
    );
  }
}
