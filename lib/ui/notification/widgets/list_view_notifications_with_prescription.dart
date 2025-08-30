import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/prescription_notification.dart';
import '../../../utils/custom_text_style.dart';
import '../../core/button_primary_component.dart';
import '../../core/button_secondary_component.dart';
import '../../prescription/view_models/update_status_notification_view_model.dart';

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

    final random = Random();

    return Column(
      children: [
        Column(
          children: notifications.map((notification) {
            final formattedDate = _dateFormat.format(notification.notificationTime);
            final formattedTime = _timeFormat.format(notification.notificationTime);

            const confirmedStatus = 'CONFIRMED';

            const sizeIcon = 28.0;
            const spacingBetweenIconWithText = 8.0;

            Color colorIcon = Colors.grey.shade800;

            return Column(
              children: [
                ListTile(
                  iconColor: Colors.grey.shade500,
                  minVerticalPadding: 16,
                  enableFeedback: true,
                  tileColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  leading: Icon(LucideIcons.bell300, size: 28,),
                  trailing: Icon(LucideIcons.chevronRight500),
                  title: Text(
                    '${notification.medicineName} - ${notification.dosageAmount} ${notification.dosageUnit}',
                    style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Text(
                    '$formattedDate - $formattedTime',
                    style: customTextLabel2(),
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
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
            children: const [
              Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: Colors.grey,
              ),
              Text("Nenhum lembrete encontrado"),
            ],
          ),
        )
            : ButtonSecondaryComponent(
          icon: LucideIcons.galleryVerticalEnd,
          text: "Ver todos os lembretes",
          isLoading: false,
          onPressed: () {
          },
        )
      ],
    );
  }
}