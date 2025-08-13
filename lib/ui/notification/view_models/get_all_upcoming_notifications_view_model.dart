import 'package:flutter/material.dart';
import 'package:tcc/data/services/prescription_notifications_service.dart';
import 'package:tcc/models/prescription_notification.dart';

class GetAllUpcomingNotificationsViewModel with ChangeNotifier {
  final PrescriptionNotificationService _notificationService;

  GetAllUpcomingNotificationsViewModel(this._notificationService);

  bool isLoading = false;
  final List<PrescriptionNotification> _notifications = [];
  List<PrescriptionNotification> get notifications => _notifications;

  Future<void> fetchUpcomingNotifications() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _notificationService.getAllUpcomingNotifications();
      _notifications
        ..clear()
      ..addAll(response);
    } catch (e) {
      debugPrint("Erro ao buscar notificações: $e\n");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
