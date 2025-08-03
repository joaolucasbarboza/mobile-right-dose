import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/utils/custom_text_style.dart';
import '../../../models/prescription_notification.dart';

class ListViewNotifications extends StatelessWidget {
  final List<PrescriptionNotification> lengthNotifications;

  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _timeFormat = DateFormat('HH:mm');

  const ListViewNotifications({
    super.key,
    required this.lengthNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: lengthNotifications.map((notification) {
        final formattedDate = _dateFormat.format(notification.notificationTime);
        final formattedTime = _timeFormat.format(notification.notificationTime);

        const colorGray = Color(0xFFF4F4F4);

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
                '$formattedDate - $formattedTime',
                style: customTextLabel2(),
              ),
              subtitle: Text('Status: ${notification.status.name}'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
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
                              children: [
                                Text(
                                  'Detalhes da Notificação',
                                  style: customTextLabelPrimary(),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Data: $formattedDate',
                                  style: customTextLabel2(),
                                ),
                                Text(
                                  'Horário: $formattedTime',
                                  style: customTextLabel2(),
                                ),
                                Text(
                                  'Status: ${notification.status.name}',
                                  style: customTextLabel2(),
                                ),
                                const SizedBox(height: 8),
                                ButtonPrimaryComponent(
                                  text: "Tomar medicação",
                                  isLoading: false,
                                  onPressed: () => {},
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
                    })
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }
}
