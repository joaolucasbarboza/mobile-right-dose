import 'package:flutter/widgets.dart';
import 'package:tcc/data/services/prescription_service.dart';

class AddPrescriptionViewModel with ChangeNotifier {
  final PrescriptionService _prescriptionService;

  AddPrescriptionViewModel(this._prescriptionService);

  bool isLoading = false;

  Future<void> addPrescription(Map<String, dynamic> prescriptionData) async {
    isLoading = true;
    notifyListeners();

    try {
      await _prescriptionService.addPrescription(prescriptionData);
    } catch (e) {
      debugPrint("Erro ao adicionar prescrição: $e\n");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}