import 'package:tcc/models/prescription_notification.dart';

abstract class PrescriptionNotificationRepository {
  Future<List<PrescriptionNotification>> getAllUpcomingNotifications();
  Future<Map<String, dynamic>> getById(int id);
}