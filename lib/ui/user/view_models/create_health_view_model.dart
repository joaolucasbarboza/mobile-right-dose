import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcc/data/services/health_service.dart';
import 'package:tcc/models/dietary.dart';
import '../../../data/dto/disease_dto.dart';

class CreateHealthViewModel extends ChangeNotifier {
  final HealthService healthService;

  CreateHealthViewModel(this.healthService);

  final formKey = GlobalKey<FormState>();
  final diseaseNameController = TextEditingController();
  final notesController = TextEditingController();

  final formKeyDietary = GlobalKey<FormState>();
  final dietaryNameController = TextEditingController();
  final notesDietaryController = TextEditingController();


  List<DiseaseDTO> _allDiseases = [];
  List<DiseaseDTO> _searchResults = [];

  DiseaseDTO? _selectedDisease;
  DiseaseDTO? get selectedDisease => _selectedDisease;
  List<DiseaseDTO> get searchResults => _searchResults;


  List<Dietary> _allDietaries = [];
  List<Dietary> _searchDietaryResults = [];

  Dietary? _selectedDietary;
  Dietary? get selectedDietary => _selectedDietary;
  List<Dietary> get dietarySearchResults => _searchDietaryResults;

  bool _isLoading = false;

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

  Future<void> loadAllDietaries() async {
    if (_allDietaries.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();
    try {
      _allDietaries = await healthService.searchDietaries();
      _searchDietaryResults = List.of(_allDietaries);
    } catch (e) {
      _allDietaries = [];
      _searchDietaryResults = [];
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
          (d.description.toLowerCase().contains(q)))
          .toList();
    }
    notifyListeners();
  }

  void filterDietaryLocal([String? query]) {
    final q = (query ?? dietaryNameController.text).trim().toLowerCase();
    if (q.isEmpty) {
      _searchDietaryResults = List.of(_allDietaries);
    } else {
      _searchDietaryResults = _allDietaries
          .where((d) =>
      ((d.description).toLowerCase().contains(q)) ||
          ((d.description).toLowerCase().contains(q)))
          .toList();
    }
    notifyListeners();
  }

  void onDiseaseSelected(DiseaseDTO d) {
    _selectedDisease = d;
    diseaseNameController.text = d.description;
    notifyListeners();
  }

  void onDietarySelected(Dietary d) {
    _selectedDietary = d;
    dietaryNameController.text = d.description;
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

  Future<bool> addDietary(BuildContext context) async {
    if (!formKeyDietary.currentState!.validate()) return false;

    final selectedDietary = {
      "dietaryRestrictionId": _selectedDietary?.id,
      "notes": notesDietaryController.text,
    };

    final result = await healthService.addDietary(selectedDietary);

    if (result == 201) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restrição adicionada com sucesso!')),
        );
      }
      return true;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar restrição: $result')),
        );
      }
      return false;
    }
  }

  @override
  void dispose() {
    diseaseNameController.dispose();
    super.dispose();
  }
}