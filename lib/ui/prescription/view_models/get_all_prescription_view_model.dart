import 'package:flutter/material.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/data/services/prescription_service.dart';

class GetAllPrescriptionViewModel with ChangeNotifier {
  final PrescriptionService _prescriptionService;

  GetAllPrescriptionViewModel(
    this._prescriptionService,
  );

  bool isLoading = false;
  bool _isFetching = false;
  final List<Prescription> _prescriptions = [];

  List<Prescription> get prescriptions => _prescriptions;

  Future<void> fetchPrescriptions() async {
    if (_isFetching) return;

    isLoading = true;
    _isFetching = true;
    notifyListeners();

    try {
      final response = await _prescriptionService.getAllPrescriptions();
      _prescriptions
        ..clear()
        ..addAll(toList(response));
    } catch (e) {
      debugPrint("Erro ao buscar prescrições: $e\n");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Prescription> toList(List<Map<String, dynamic>> response) {
    return response.map((e) => Prescription.fromMap(e)).toList();
  }
}
