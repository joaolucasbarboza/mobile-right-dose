import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/models/prescription_notification.dart';
import 'package:tcc/ui/prescription/widgets/card_info_prescription.dart';
import 'package:tcc/ui/prescription/widgets/history_notifications.dart';
import 'package:tcc/ui/notification/widgets/list_view_notifications.dart';
import 'package:tcc/utils/custom_text_style.dart';
import 'package:tcc/utils/format_strings.dart';

class TextDetailsPrescriptionComponent extends StatelessWidget {
  final Prescription prescription;

  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final double _sizeIcon = 32;

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
    final isNotification = p.notifications.isNotEmpty;

    double spacing = 18;

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 12, bottom: 12),
              child: Row(
                children: [
                  Text(
                    medicineName,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    LucideIcons.dot600,
                    size: 28,
                  ),
                  if (isNotification)
                    Chip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8), side: BorderSide(color: Colors.amber)),
                      color: WidgetStatePropertyAll(Colors.amber.withOpacity(0.2)),
                      label: Text(
                        "Em andamento",
                        style: TextStyle(color: Colors.amber),
                      ),
                      avatar: Icon(
                        LucideIcons.clockFading500,
                        color: Colors.amber,
                      ),
                    )
                  else
                    Chip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8), side: BorderSide(color: Colors.green)),
                      color: WidgetStatePropertyAll(Colors.lightGreen.withOpacity(0.2)),
                      label: Text(
                        "Concluído",
                        style: TextStyle(color: Colors.green),
                      ),
                      avatar: Icon(
                        LucideIcons.check500,
                        color: Colors.green,
                      ),
                    )
                ],
              ),
            ),
            CardInfoPrescription(
              icon: Icon(LucideIcons.pill600, size: 36, color: Colors.amber),
              color: Colors.amber,
              primaryLabel: 'Dosagem a ser tomada',
              secondaryLabel: '$dosageAmount ${formatDosageUnit(dosageUnit)}',
            ),
            const SizedBox(height: 8),
            CardInfoPrescription(
                icon: Icon(LucideIcons.timer600, size: 36, color: Colors.deepPurpleAccent),
                color: Colors.deepPurpleAccent,
                primaryLabel: 'Intervalo',
                secondaryLabel: 'A cada $frequency ${formatUomFrequency(uomFrequency)}'),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Instruções de uso', style: customTextLabelPrimary()),
                Text(
                  instructions.isNotEmpty ? instructions : 'Nenhuma instrução adicional.',
                  style: customTextLabel(),
                ),
              ],
            ),
            Divider(
              height: 48,
              indent: 0,
            ),
            Row(
              spacing: spacing,
              children: [
                Icon(
                  LucideIcons.info,
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
                                style: customTextLabel2(),
                              ),
                              Text(
                                'Período: $startDate até $endDate',
                                style: customTextLabel2(),
                              ),
                            ],
                          )
                        : Text(
                            "Está medicação não possui um período definido.",
                            style: customTextLabel2(),
                          )
                  ],
                ),
              ],
            ),
            Divider(
              height: 48,
            ),
            Row(
              spacing: spacing,
              children: [
                Icon(
                  LucideIcons.bellRing,
                  size: _sizeIcon,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deseja receber notificações?', style: customTextLabelPrimary()),
                      Text(
                        'Você receberá notificações para tomar a medicação.',
                        style: customTextLabel2(),
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
            Divider(
              height: 48,
              indent: 0,
            ),
            const SizedBox(height: 8),
            MedicationProgress(
              indefinite: p.indefinite,
              totalOccurrences: p.totalOccurrences,
              totalConfirmed: p.totalConfirmed,
              totalPending: p.totalPending,
            ),
            const SizedBox(height: 16),
            Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lembretes',
                  style: customTextLabelPrimary(),
                ),
                !indefinite
                    ? Text(
                        "Você ainda receberá ${p.notifications.length} lembretes",
                        style: customTextLabel(),
                      )
                    : Text("Seus próximos lembretes")
              ],
            ),
            SizedBox(
              height: 8,
            ),
            ListViewNotifications(notifications: p.notifications, prescription: prescription,),
          ],
        ),
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
