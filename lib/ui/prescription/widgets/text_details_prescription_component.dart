import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/ui/prescription/widgets/card_info_prescription.dart';
import 'package:tcc/utils/custom_text_style.dart';
import 'package:tcc/utils/format_strings.dart';

class TextDetailsPrescriptionComponent extends StatelessWidget {
  final Prescription prescription;
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('HH:mm');

  const TextDetailsPrescriptionComponent({
    Key? key,
    required this.prescription,
  }) : super(key: key);

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

          // Informações principais
          CardInfoPrescription(
            icon: const Icon(Icons.medication_rounded, size: 36, color: Colors.amber),
            color: Colors.amber,
            primaryLabel: 'Dosagem a ser tomada',
            secondaryLabel: '$dosageAmount ${formatDosageUnit(dosageUnit)}',
          ),
          const SizedBox(height: 8),

          CardInfoPrescription(
            icon: const Icon(Icons.access_time_outlined, size: 36, color: Colors.deepPurpleAccent),
            color: Colors.deepPurpleAccent,
            primaryLabel: 'Intervalo',
            secondaryLabel: uomFrequency == 'HOURLY'
                ? 'A cada $frequency ${formatUomFrequency(uomFrequency)}'
                : '$frequency vez(es) ao dia',
          ),
          const SizedBox(height: 16),

          // Instruções de uso
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Instruções de uso', style: customTextLabelPrimary()),
                Text(instructions.isNotEmpty ? instructions : 'Nenhuma instrução adicional.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 8),

          // Detalhes gerais
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detalhes', style: customTextLabelPrimary()),
                Text('Tomar a medicação $totalOccurrences vez(es)'),
                Text('Período: $startDate até $endDate'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 8),

          // Switch de notificações
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notificações', style: customTextLabelPrimary()),
                Switch(activeColor: Colors.green, value: wantsNotifications, onChanged: (_) {}),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(),
          const SizedBox(height: 8),

          // Histórico de notificações
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Próximas Notificações', style: customTextLabelPrimary()),
          ),

          if (p.notifications.isNotEmpty)
            ...p.notifications.map((n) {
              final date = _dateFormat.format(n.notificationTime);
              final time = _timeFormat.format(n.notificationTime);
              final statusText = n.status.name;
              return ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Data: $date'),
                subtitle: Row(
                  children: [
                    Text('Horário: $time'),
                  ],
                ),
                trailing: Chip(
                  label: Text(formatLowerCase(statusText)),
                  backgroundColor: Colors.orange,
                  labelStyle: const TextStyle(color: Colors.white),
                  padding: const EdgeInsets.all(0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) {
                      return Container(
                        width: MediaQuery.of(ctx).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text('Data: $date', style: customTextLabelPrimary()),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time),
                                const SizedBox(width: 8),
                                Text('Horário: $time'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.info_outline),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(formatLowerCase(statusText)),
                                  backgroundColor: Colors.orange,
                                  labelStyle: const TextStyle(color: Colors.white),
                                  padding: const EdgeInsets.all(0),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.medication_rounded),
                                const SizedBox(width: 8),
                                Text('Dose: $dosageAmount ${formatDosageUnit(dosageUnit)}'),
                              ],
                            ),
                            const SizedBox(height: 14),

                            ButtonPrimaryComponent(
                              text: 'Tomar medicação',
                              isLoading: false,
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),

                            const SizedBox(height: 14),

                            ButtonSecondaryComponent(
                              text: 'Cancelar',
                              isLoading: false,
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }).toList()
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Sem notificações registradas.'),
            ),

          const SizedBox(height: 24),
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
