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
    final String medicineDosageAmount =
        prescription.medicine.dosagePerUnit?.dosageAmount.toString() ?? '-';
    final String medicineDosageUnit =
        prescription.medicine.dosagePerUnit?.dosageUnit ?? '-';
    final String medicineUnit = prescription.medicine.unit;

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
            Icon(
              Icons.circle,
              size: 6,
            ),
            Text(
              "$medicineDosageAmount $medicineDosageUnit",
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
        Row(
          children: [
            CardInfoPrescription(
              icon: Icon(Icons.medication_rounded, color: Colors.amber, size: 36,),
              color: Colors.amber,
              primaryLabel: "Tomar",
              secondaryLabel:
                  '$dosageAmount $dosageUnit',
            ),
            CardInfoPrescription(
              icon: Icon(Icons.access_time_outlined, color: Colors.deepPurpleAccent, size: 36,),
              color: Colors.deepPurpleAccent,
              primaryLabel: "Intervalo",
              secondaryLabel:
                  '$frequency $uomFrequency',
            ),
          ],
        ),
        Text("Instruções de uso", style: customTextLabelPrimary(),),
        Text(instructions.isNotEmpty
            ? instructions
            : "Nenhuma instrução adicional."),
        Divider(),
        Text("Detalhes", style: customTextLabelPrimary(),),
        Text("Tomar a medicação por $totalDays dias"),
        Text("Período: $startDate até $endDate"),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Notificações", style: customTextLabelPrimary(),),
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
