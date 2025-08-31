import 'package:flutter/foundation.dart';
import 'package:tcc/models/prescription_notification.dart';

import '../../../data/services/prescription_notifications_service.dart';

class GetNotificationByIdViewModel extends ChangeNotifier {
  final PrescriptionNotificationService service;

  GetNotificationByIdViewModel(this.service);

  bool _isLoading = false;
  String? _error;
  PrescriptionNotification? _notification;

  bool get isLoading => _isLoading;
  String? get error => _error;
  PrescriptionNotification? get notification => _notification;

  Future<PrescriptionNotification?> fetchById(int id) async {
    _isLoading = true;
    _error = null;
    _notification = null;
    notifyListeners();

    try {
      final map = await service.getById(id);
      _notification = PrescriptionNotification.fromMap(map);
      return _notification;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}