import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/notification/view_models/get_all_upcoming_notifications_view_model.dart';
import 'package:tcc/ui/notification/widgets/list_view_notifications_with_prescription.dart';
import 'package:tcc/utils/custom_text_style.dart';

class SectionUpcomingNotifications extends StatefulWidget {
  const SectionUpcomingNotifications({super.key});

  @override
  State<SectionUpcomingNotifications> createState() =>
      _SectionUpcomingNotificationsState();
}

class _SectionUpcomingNotificationsState
    extends State<SectionUpcomingNotifications> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<GetAllUpcomingNotificationsViewModel>(context, listen: false);
    viewModel.fetchUpcomingNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetAllUpcomingNotificationsViewModel>(
      builder: (context, viewModel, child) {
        final notifications = viewModel.notifications;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Próximos lembretes", style: customTextTitleSecondaryBlack()),
                  Text("Você tem ${notifications.length} lembrete(s) agendado(s).", style: customTextLabel()),
                ],
              ),
              if (notifications.isEmpty)
                const Center(child: Text("Nenhuma notificação encontrada."))
              else
                ListViewNotificationsWithPrescription(notifications: notifications)
            ],
          ),
        );
      },
    );
  }
}
