import 'package:tcc/models/prescription.dart';
import 'package:tcc/models/prescription_notification.dart';

abstract class PrescriptionRepository {
  Future<List<Map<String, dynamic>>> getAllPrescriptions();
  Future<void> addPrescription(Map<String, dynamic> prescriptionData);
  Future<Prescription> getById(int id);
  Future<PrescriptionNotification> updateStatus(int id, String status);
  Future<void> deleteByIdPrescription(int id);
  Future<void> changeWantsNotifications(int id);
}