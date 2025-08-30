import 'package:flutter/material.dart';
import 'package:tcc/ui/notification/view_models/get_all_upcoming_notifications_view_model.dart';
import 'package:tcc/ui/notification/widgets/list_view_notifications_with_prescription.dart';
import 'package:tcc/utils/custom_text_style.dart';

class SectionUpcomingNotifications extends StatelessWidget {
  final GetAllUpcomingNotificationsViewModel viewModel;

  const SectionUpcomingNotifications({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final notifications = viewModel.notifications;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Próximos lembretes", style: customTextTitleSecondaryBlack()),
            const SizedBox(height: 8),
            Text("Você tem ${notifications.length} lembrete(s) agendado(s).", style: customTextLabel()),
            const SizedBox(height: 12),
            if (notifications.isEmpty)
              const Center(child: Text("Nenhuma notificação encontrada."))
            else
              ListViewNotificationsWithPrescription(notifications: notifications),
          ],
        );
      },
    );
  }
}