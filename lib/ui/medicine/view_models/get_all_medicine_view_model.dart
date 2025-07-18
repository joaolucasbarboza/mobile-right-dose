import 'package:flutter/material.dart';
import 'package:tcc/data/services/medicine_service.dart';
import 'package:tcc/models/medicine.dart';

class GetAllMedicineViewModel with ChangeNotifier {
  final MedicineService _medicineService;

  GetAllMedicineViewModel(
      this._medicineService,
  );

  bool isLoading = true;
  bool _isFetching = false;
  final List<Medicine> medicines = [];

  Future<void> fetchMedicines({bool force = false}) async {
    if (_isFetching && !force) return;

    notifyListeners();

    try {
      final medicineList = await _medicineService.getAllMedicine();
        medicines.clear();
        medicines.addAll(medicineList);
        _isFetching = true;
    } catch (e) {
      debugPrint("Erro ao buscar medicines: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}