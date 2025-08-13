import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/ui/prescription/view_models/update_status_notification_view_model.dart';
import 'package:tcc/utils/custom_text_style.dart';
import '../../../models/prescription_notification.dart';

class ListViewNotificationsWithPrescription extends StatelessWidget {
  final List<PrescriptionNotification> notifications;

  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('HH:mm');

  const ListViewNotificationsWithPrescription({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    final updateStatusNotifier = Provider.of<UpdateStatusNotificationViewModel>(context, listen: true);
    return Column(
      children: [
        Column(
          children: notifications.map((notification) {
            final formattedDate = _dateFormat.format(notification.notificationTime);
            final formattedTime = _timeFormat.format(notification.notificationTime);

            const colorGray = Color(0xFFF4F4F4);
            const confirmedStatus = 'CONFIRMED';

            const sizeIcon = 28.0;
            const spacingBetweenIconWithText = 8.0;

            Color colorIcon = Colors.grey.shade800;

            return Column(
              children: [
                ListTile(
                  minVerticalPadding: 16,
                  enableFeedback: true,
                  tileColor: colorGray,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  leading: const Icon(Icons.notifications_none_rounded),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  title: Text(
                    '${notification.medicineName} - ${notification.dosageAmount} ${notification.dosageUnit}',
                    style: customTextLabel2(),
                  ),
                  subtitle: Text(
                    '$formattedDate - $formattedTime',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onTap: () => {
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: false,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Text(
                                    'Detalhes do lembrete',
                                    style: customTextTitleSecondaryBlack(),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Row(
                                        spacing: spacingBetweenIconWithText,
                                        children: [
                                          Icon(
                                            Icons.medical_information_outlined,
                                            size: sizeIcon,
                                            color: colorIcon,
                                          ),
                                          Text("Medicamento: ${notification.medicineName}", style: customTextLabel(),)
                                        ],
                                      ),
                                      Row(
                                        spacing: spacingBetweenIconWithText,
                                        children: [
                                          Icon(
                                            Icons.medication_outlined,
                                            size: sizeIcon,
                                            color: colorIcon,
                                          ),
                                          Text("Dosagem: ${notification.dosageAmount} ${notification.dosageUnit}", style: customTextLabel()),
                                        ],
                                      ),
                                      Row(
                                        spacing: spacingBetweenIconWithText,
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            size: sizeIcon,
                                            color: colorIcon,
                                          ),
                                          Text(
                                            'Data: $formattedDate',
                                            style: customTextLabel(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: spacingBetweenIconWithText,
                                        children: [
                                          Icon(
                                            Icons.access_time_outlined,
                                            size: sizeIcon,
                                            color: colorIcon,
                                          ),
                                          Text(
                                            'Horário: $formattedTime',
                                            style: customTextLabel(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: spacingBetweenIconWithText,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            size: sizeIcon,
                                            color: colorIcon,
                                          ),
                                          Text(
                                            'Status: ${notification.status.name}',
                                            style: customTextLabel(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ButtonPrimaryComponent(
                                    text: "Tomar medicação",
                                    isLoading: updateStatusNotifier.isLoading,
                                    onPressed: () async {
                                      int response = await updateStatusNotifier.updateStatusNotification(
                                        parentContext,
                                        notification.id!,
                                        confirmedStatus,
                                      );

                                      if (response == HttpStatus.ok) {
                                        Navigator.pop(context);

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
                                  Divider(),
                                  ButtonSecondaryComponent(
                                    text: "Cancelar",
                                    isLoading: false,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  },
                ),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),
        notifications.isEmpty
            ? Container(
                alignment: Alignment.center,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_off_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                    Text("Nenhum lembrete encontrado"),
                  ],
                ),
              )
            : ButtonSecondaryComponent(text: "Ver todos os lembretes", isLoading: false, onPressed: () => {})
      ],
    );
  }
}
