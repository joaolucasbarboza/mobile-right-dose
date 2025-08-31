import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../models/prescription_notification.dart';
import '../../../utils/custom_text_style.dart';
import '../../core/button_primary_component.dart';
import '../../core/button_secondary_component.dart';
import '../../prescription/view_models/update_status_notification_view_model.dart';

final _dateFormat = DateFormat('dd/MM/yyyy');
final _timeFormat = DateFormat('HH:mm');

Future<void> showNotificationBottomSheet(BuildContext context, PrescriptionNotification notification) {
  final parentContext = context;
  final updateStatusNotifier = Provider.of<UpdateStatusNotificationViewModel>(context, listen: false);

  final formattedDate = _dateFormat.format(notification.notificationTime);
  final formattedTime = _timeFormat.format(notification.notificationTime);

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      const status = "PENDING";
      Color statusColor;
      IconData statusIcon;
      switch (status) {
        case 'CONFIRMED':
          statusColor = Colors.green;
          statusIcon = LucideIcons.check;
          break;
        case 'CANCELLED':
          statusColor = Colors.red;
          statusIcon = LucideIcons.x;
          break;
        default:
          statusColor = Colors.amber;
          statusIcon = LucideIcons.clockFading500;
      }

      return DraggableScrollableSheet(
        minChildSize: 0.65,
        expand: true,
        initialChildSize: 0.66,
        maxChildSize: 0.68,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26, offset: Offset(0, -2))],
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(99))),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(LucideIcons.pill600),
                        title: Text(notification.medicineName ?? '-', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 8),
                      Material(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: ListTile.divideTiles(
                            color: Theme.of(context).dividerColor,
                            tiles: [
                              ListTile(
                                leading: const Icon(LucideIcons.calendar600),
                                title: const Text('Data'),
                                subtitle: Text(formattedDate, style: customTextLabel2()),
                              ),
                              ListTile(
                                leading: const Icon(LucideIcons.timer600),
                                title: const Text('Horário'),
                                subtitle: Text(formattedTime, style: customTextLabel2()),
                              ),
                              ListTile(
                                leading: Icon(statusIcon),
                                title: const Text('Status'),
                                trailing: Chip(
                                  backgroundColor: statusColor.withOpacity(0.12),
                                  side: BorderSide(color: statusColor.withOpacity(0.5)),
                                  label: Text("PENDENTE", style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)),
                                  avatar: Icon(statusIcon, color: statusColor, size: 18),
                                ),
                              ),
                              ListTile(
                                leading: const Icon(LucideIcons.syringe600),
                                title: const Text('Dosagem'),
                                subtitle: Text('${notification.dosageAmount} ${notification.dosageUnit}', style: customTextLabel2()),
                              ),
                            ],
                          ).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ButtonPrimaryComponent(
                        icon: LucideIcons.check600,
                        text: "Tomar medicação",
                        isLoading: updateStatusNotifier.isLoading,
                        onPressed: () async {
                          const confirmedStatus = 'CONFIRMED';
                          final resp = await updateStatusNotifier.updateStatusNotification(
                            parentContext,
                            notification.id!,
                            confirmedStatus,
                          );
                          if (resp == HttpStatus.ok) {
                            if (context.mounted) Navigator.pop(context);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                  content: Text('Status atualizado com sucesso!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      ButtonSecondaryComponent(
                        icon: LucideIcons.x,
                        text: "Cancelar",
                        isLoading: false,
                        onPressed: () => Navigator.pop(context),
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