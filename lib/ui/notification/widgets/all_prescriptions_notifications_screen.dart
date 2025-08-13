import 'package:flutter/widgets.dart';
import 'package:tcc/models/prescription_notification.dart';
import 'package:tcc/ui/notification/widgets/list_view_notifications_with_prescription.dart';

class AllPrescriptionsNotificationsScreen extends StatefulWidget {
  List<PrescriptionNotification> notifications;

  AllPrescriptionsNotificationsScreen({super.key, required this.notifications});

  @override
  State<AllPrescriptionsNotificationsScreen> createState() => _AllPrescriptionsNotificationsScreenState();
}

class _AllPrescriptionsNotificationsScreenState extends State<AllPrescriptionsNotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListViewNotificationsWithPrescription(notifications: widget.notifications,);
  }
}
