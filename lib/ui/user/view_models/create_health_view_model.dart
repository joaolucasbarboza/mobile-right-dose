import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcc/data/services/health_service.dart';
import '../../../data/dto/disease_dto.dart';

class CreateHealthViewModel extends ChangeNotifier {
  final HealthService healthService;

  CreateHealthViewModel(this.healthService);

  final formKey = GlobalKey<FormState>();
  final diseaseNameController = TextEditingController();
  final notesController = TextEditingController();

  DiseaseDTO? _selectedDisease;
  List<DiseaseDTO> _allDiseases = [];
  List<DiseaseDTO> _searchResults = [];
  bool _isLoading = false;

  DiseaseDTO? get selectedDisease => _selectedDisease;
  List<DiseaseDTO> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  Future<void> loadAllDiseases() async {
    if (_allDiseases.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();
    try {
      _allDiseases = await healthService.searchDiseases();
      _searchResults = List.of(_allDiseases);
    } catch (e) {
      _allDiseases = [];
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterLocal([String? query]) {
    final q = (query ?? diseaseNameController.text).trim().toLowerCase();
    if (q.isEmpty) {
      _searchResults = List.of(_allDiseases);
    } else {
      _searchResults = _allDiseases
          .where((d) =>
      (d.description.toLowerCase().contains(q)) ||
          (d.description.toLowerCase().contains(q) ?? false))
          .toList();
    }
    notifyListeners();
  }

  void onDiseaseSelected(DiseaseDTO d) {
    _selectedDisease = d;
    diseaseNameController.text = d.description;
    notifyListeners();
  }

  Future<void> addDisease(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final selectedDisease = {
      "diseaseId": _selectedDisease?.id,
      "notes": notesController.text,
    };

    final result = await healthService.addDisease(selectedDisease);

    if (result == 201) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doença adicionada com sucesso!')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar doença: $result')),
        );
      }
    }

    if (kDebugMode) {
      print('Salvando: ${_selectedDisease?.description}, '
          'nome: ${diseaseNameController.text}, '
          'notas: ${notesController.text}');
    }
  }

  @override
  void dispose() {
    diseaseNameController.dispose();
    super.dispose();
  }
}