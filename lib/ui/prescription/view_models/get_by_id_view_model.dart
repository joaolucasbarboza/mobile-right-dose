import 'package:flutter/widgets.dart';
import 'package:tcc/data/services/prescription_service.dart';
import 'package:tcc/models/prescription.dart';

class GetByIdViewModel with ChangeNotifier {
  final PrescriptionService _prescriptionService;

  GetByIdViewModel(
    this._prescriptionService
  );

  bool isLoading = false;
  Prescription? prescription;
  String? error;

  Future<void> findById(int id) async {
    if (isLoading) return;
    isLoading = true;

    notifyListeners();

    try {
      prescription = await _prescriptionService.getById(id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}