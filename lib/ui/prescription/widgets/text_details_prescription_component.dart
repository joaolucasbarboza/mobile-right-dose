import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/ui/prescription/widgets/card_info_prescription.dart';
import 'package:tcc/ui/prescription/widgets/history_notifications.dart';
import 'package:tcc/ui/notification/widgets/list_view_notifications.dart';
import 'package:tcc/utils/custom_text_style.dart';
import 'package:tcc/utils/format_strings.dart';

class TextDetailsPrescriptionComponent extends StatelessWidget {
  final Prescription prescription;

  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final double _sizeIcon = 32;
  static final double _spacing = 8;

  const TextDetailsPrescriptionComponent({
    super.key,
    required this.prescription,
  });

  @override
  Widget build(BuildContext context) {
    final p = prescription;
    final dosageAmount = p.dosageAmount.toString();
    final dosageUnit = p.dosageUnit;
    final uomFrequency = p.uomFrequency;
    final frequency = p.frequency.toString();
    final totalOccurrences = p.totalOccurrences.toString();
    final startDate = _dateFormat.format(p.startDate);
    final endDate = _dateFormat.format(p.endDate);
    final indefinite = p.indefinite;
    final instructions = p.instructions?.toString() ?? '';
    final wantsNotifications = p.wantsNotifications;
    final medicineName = p.medicine.name;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(medicineName, style: customTextTitle()),
          ),
          CardInfoPrescription(
            icon: const Icon(Icons.medication_rounded,
                size: 36, color: Colors.amber),
            color: Colors.amber,
            primaryLabel: 'Dosagem a ser tomada',
            secondaryLabel: '$dosageAmount ${formatDosageUnit(dosageUnit)}',
          ),
          const SizedBox(height: 8),
          CardInfoPrescription(
            icon: const Icon(Icons.access_time_outlined,
                size: 36, color: Colors.deepPurpleAccent),
            color: Colors.deepPurpleAccent,
            primaryLabel: 'Intervalo',
            secondaryLabel: uomFrequency == 'HOURLY'
                ? 'A cada $frequency ${formatUomFrequency(uomFrequency)}'
                : '$frequency vez(es) ao dia',
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Instruções de uso', style: customTextLabelPrimary()),
              Text(
                instructions.isNotEmpty
                    ? instructions
                    : 'Nenhuma instrução adicional.',
                style: customTextLabel(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(),
          const SizedBox(height: 8),
          Row(
            spacing: _spacing,
            children: [
              Icon(
                Icons.details_outlined,
                size: _sizeIcon,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text('Detalhes', style: customTextLabelPrimary()),
                  !indefinite
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tomar a medicação $totalOccurrences vez(es)',
                              style: customTextLabel(),
                            ),
                            Text(
                              'Período: $startDate até $endDate',
                              style: customTextLabel(),
                            ),
                          ],
                        )
                      : Text(
                          "Está medicação não possui um período definido.",
                          style: customTextLabel(),
                        )
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 8),
          Row(
            spacing: _spacing,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: _sizeIcon,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deseja receber notificações?',
                        style: customTextLabelPrimary()),
                    Text(
                      'Você receberá notificações para tomar a medicação.',
                      style: customTextLabel(),
                    ),
                  ],
                ),
              ),
              Switch(
                activeColor: Colors.green,
                value: wantsNotifications,
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lembretes',
                style: customTextLabelPrimary(),
              ),
              !indefinite
                  ? Text(
                      "Você ainda receberá ${p.notifications.length} lembretes")
                  : Text("Seus próximos lembretes")
            ],
          ),
          const SizedBox(height: 8),
          ListViewNotifications(notifications: p.notifications),
          const SizedBox(height: 16),
          HistoryNotifications()
        ],
      ),
    );
  }

  static String formatLowerCase(String text) {
    return labelStatus(text).toLowerCase().replaceAll('_', ' ');
  }

  static String labelStatus(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return 'Confirmada';
      case 'PENDING':
        return 'Pendente';
      case 'CANCELLED':
        return 'Cancelada';
      default:
        return 'Desconhecida';
    }
  }
}
