import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tcc/data/services/prescription_service.dart';
import 'package:tcc/models/prescription_notification.dart';
import 'package:tcc/ui/prescription/view_models/get_by_id_view_model.dart';

class UpdateStatusNotificationViewModel with ChangeNotifier {
  final PrescriptionService _prescriptionService;
  final GetByIdViewModel _getByIdViewModel;

  UpdateStatusNotificationViewModel(
      this._prescriptionService, this._getByIdViewModel);

  bool isLoading = false;

  Future<int> updateStatusNotification(
      BuildContext context, int notificationId, String newStatus) async {
    isLoading = true;
    notifyListeners();

    try {
      PrescriptionNotification response =
          await _prescriptionService.updateStatus(notificationId, newStatus);

      await _getByIdViewModel.findById(response.prescriptionId!);
      return HttpStatus.ok;
    } catch (e) {
      debugPrint("Erro ao atualizar status da notificação: $e\n");
      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return HttpStatus.internalServerError;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
