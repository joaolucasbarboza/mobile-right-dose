import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tcc/data/services/prescription_service.dart';

class DeleteByIdPrescriptionViewModel with ChangeNotifier {
  final PrescriptionService _prescriptionService;
  var logger = Logger(printer: PrettyPrinter());

  DeleteByIdPrescriptionViewModel(this._prescriptionService);

  bool isLoading = false;

  Future<int> deleteByIdPrescription(int id) async {
    isLoading = true;

    try {
      logger.d("Deleting prescription with id: $id");
      await _prescriptionService.deleteByIdPrescription(id);

      logger.log(Logger.level, "Prescription deleted successfully");
      return HttpStatus.noContent;
    } catch (e) {

      return HttpStatus.internalServerError;
    } finally {
      isLoading = false;
    }
  }
}
