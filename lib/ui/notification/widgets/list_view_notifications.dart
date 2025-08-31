import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/prescription.dart';

import '../../../models/prescription_notification.dart';
import '../../../utils/custom_text_style.dart';
import '../../core/button_primary_component.dart';
import '../../core/button_secondary_component.dart';
import '../../prescription/view_models/update_status_notification_view_model.dart';

class ListViewNotifications extends StatelessWidget {
  final List<PrescriptionNotification> notifications;
  final Prescription prescription;

  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('HH:mm');

  const ListViewNotifications({
    super.key,
    required this.notifications,
    required this.prescription
  });

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    final updateStatusNotifier = Provider.of<UpdateStatusNotificationViewModel>(context, listen: true);

    final limitedNotifications = notifications.take(3).toList();

    print(notifications.toString());

    return Column(
      children: [
        Column(
          children: limitedNotifications.map((notification) {
            final formattedDate = _dateFormat.format(notification.notificationTime);
            final formattedTime = _timeFormat.format(notification.notificationTime);

            const colorGray = Color(0xFFF4F4F4);

            return Column(
              children: [
                ListTile(
                  minVerticalPadding: 8,
                  enableFeedback: true,
                  tileColor: colorGray,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  leading: const Icon(LucideIcons.bell600),
                  trailing: const Icon(
                    LucideIcons.arrowUpRight600,
                    size: 22,
                  ),
                  title: Text(
                    '$formattedDate - $formattedTime',
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.amber),
                      ),
                      backgroundColor: Colors.amber.withOpacity(0.2),
                      label: const Text(
                        "Pendente",
                        style: TextStyle(color: Colors.amber),
                      ),
                      avatar: const Icon(
                        LucideIcons.clockFading,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true, // necessário para permitir o sheet expansível
                        backgroundColor: Colors.transparent, // bordas arredondadas no container interno
                        builder: (context) {
                          final status = "PENDING"; // ex.: PENDING, CONFIRMED, CANCELLED
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
                                  boxShadow: const [
                                    BoxShadow(blurRadius: 12, color: Colors.black26, offset: Offset(0, -2)),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Handle
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 40, height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.black26, borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListView(
                                        controller: scrollController,
                                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(LucideIcons.pill600),
                                            title: Text(
                                              prescription.medicine.name,
                                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                                            ),
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
                                                      label: Text(
                                                        "PENDENTE",
                                                        style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                                                      ),
                                                      avatar: Icon(statusIcon, color: statusColor, size: 18),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(LucideIcons.syringe600),
                                                    title: const Text('Dosagem'),
                                                    subtitle: Text(
                                                      '${prescription.dosageAmount} ${prescription.dosageUnit}',
                                                      style: customTextLabel2(),
                                                    ),
                                                  ),
                                                ],
                                              ).toList(),
                                            ),
                                          ),

                                          const SizedBox(height: 16),

                                          // Ações
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
                ),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),
        if (notifications.isEmpty)
          Container(
            alignment: Alignment.center,
            height: 120,
            child: Center(
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    LucideIcons.bellOff500,
                    size: 40,
                    color: Colors.grey,
                  ),
                  Text("Nenhum lembrete encontrado"),
                ],
              ),
            ),
          )
      ],
    );
  }
}
