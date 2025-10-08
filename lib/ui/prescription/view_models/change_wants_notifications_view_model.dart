import 'package:flutter/material.dart';
import 'package:tcc/data/services/prescription_service.dart';

class ChangeWantsNotificationsViewModel with ChangeNotifier {
  final PrescriptionService prescriptionService;

  ChangeWantsNotificationsViewModel(
    this.prescriptionService
  );

  Future<void> changeWantsNotifications(int prescriptionId) async {
    await prescriptionService.changeWantsNotifications(prescriptionId);
  }
}