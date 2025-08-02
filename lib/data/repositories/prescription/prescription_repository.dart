import 'package:tcc/models/prescription.dart';

abstract class PrescriptionRepository {
  Future<List<Map<String, dynamic>>> getAllPrescriptions();
  Future<void> addPrescription(Map<String, dynamic> prescriptionData);
  Future<Prescription> getById(int id);
}