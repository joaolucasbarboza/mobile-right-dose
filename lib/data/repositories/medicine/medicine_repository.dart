import 'package:tcc/models/medicine.dart';

abstract class MedicineRepository {
  Future<List<Medicine>> getAllMedicine();
  Future<void> addMedicine(Map<String, dynamic> medicine);
  Future<Medicine> getMedicineById(int id);
}