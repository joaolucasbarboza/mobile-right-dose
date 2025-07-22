import 'package:flutter/widgets.dart';
import 'package:tcc/data/services/prescription_service.dart';

class AddPrescriptionViewModel with ChangeNotifier {
  final PrescriptionService _prescriptionService;

  AddPrescriptionViewModel(this._prescriptionService);

  bool isLoading = false;
  bool _isAdding = false;

  Future<void> addPrescription(Map<String, dynamic> prescriptionData) async {
    if (_isAdding) return;

    isLoading = true;
    notifyListeners();

    try {
      await _prescriptionService.addPrescription(prescriptionData);
      _isAdding = true;
    } catch (e) {
      debugPrint("Erro ao adicionar prescrição: $e\n");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}