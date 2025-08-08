import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/dropdown_component.dart';
import 'package:tcc/ui/core/input_component.dart';
import 'package:tcc/ui/medicine/view_models/get_all_medicine_view_model.dart';
import 'package:tcc/ui/prescription/view_models/add_prescription_view_model.dart';
import 'package:tcc/utils/custom_text_style.dart';
import 'package:tcc/utils/enums.dart';

class AddPrescriptionScreen extends StatefulWidget {
  const AddPrescriptionScreen({super.key});

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<GetAllMedicineViewModel>(
          context,
          listen: false,
        ).fetchMedicines());
  }

  final _formKey = GlobalKey<FormState>();
  final _dosageAmountController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _totalOccurrences = TextEditingController();
  final _instructionsController = TextEditingController();
  int? _selectedMedicineId;

  String? _selectedDosageUnit;
  String? _selectedUomFrequency;
  DateTime? _startDate;
  bool _wantsNotifications = true;
  bool _indefinite = false;

  final List<String> _dosageUnits = dosageUnits;
  final List<String> _uomFrequencyUnits = uomFrequencyUnits;

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _startDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _startDate != null) {
      final prescription = {
        "medicineId": _selectedMedicineId,
        "dosageAmount": int.parse(_dosageAmountController.text),
        "dosageUnit": _selectedDosageUnit,
        "frequency": int.parse(_frequencyController.text),
        "uomFrequency": _selectedUomFrequency,
        "indefinite": _indefinite,
        "totalOccurrences": !_indefinite && _totalOccurrences.text.isNotEmpty
            ? int.parse(_totalOccurrences.text)
            : null,
        "startDate": _startDate!.toIso8601String(),
        "wantsNotifications": _wantsNotifications,
        "instructions": _instructionsController.text.trim(),
      };

      final provider = context.read<AddPrescriptionViewModel>();

      provider.addPrescription(prescription).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Prescrição adicionada com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao adicionar: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      });
    } else if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione a data de início."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GetAllMedicineViewModel>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Adicionar nova prescrição", style: customTextTitle()),
              Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Preencha os dados da prescrição",
                    style: customTextLabelPrimary(),
                  ),
                  DropdownComponent<int>(
                    label: "Medicamento",
                    value: _selectedMedicineId,
                    items: provider.medicines
                        .map(
                          (medicine) => DropdownMenuItem<int>(
                            value: medicine.id,
                            child: Text(medicine.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      _selectedMedicineId = value;
                    }),
                    validator: (value) =>
                        value == null ? "Selecione um medicamento" : null,
                    prefixIcon: Icons.medication_outlined,
                  ),
                  InputComponent(
                    keyboardType: TextInputType.number,
                    controller: _dosageAmountController,
                    label: "Dosagem",
                    hint: "Quantidade da dose",
                    prefixIcon: Icons.local_pharmacy_outlined,
                    obscureText: false,
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Informe a dosagem"
                        : null,
                  ),
                  DropdownComponent<String>(
                    label: "Unidade da Dose",
                    value: _selectedDosageUnit,
                    items: _dosageUnits
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedDosageUnit = value),
                    validator: (value) =>
                        value == null ? 'Selecione a unidade' : null,
                    prefixIcon: Icons.straighten,
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade100,
              ),
              Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Frequência de uso",
                    style: customTextLabelPrimary(),
                  ),
                  InputComponent(
                    keyboardType: TextInputType.number,
                    controller: _frequencyController,
                    label: "Frequência",
                    hint: "Quantas vezes ao dia ou horas?",
                    prefixIcon: Icons.schedule,
                    obscureText: false,
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Informe a frequência"
                        : null,
                  ),
                  DropdownComponent<String>(
                    label: "Unidade da Frequência",
                    value: _selectedUomFrequency,
                    items: _uomFrequencyUnits
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedUomFrequency = value),
                    validator: (value) =>
                        value == null ? 'Selecione a unidade' : null,
                    prefixIcon: Icons.access_time,
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selecione a data de inicio ",
                    style: customTextLabelPrimary(),
                  ),
                  ListTile(
                    title: Text(
                      "Data/Hora de início: ${_startDate != null ? DateFormat('dd/MM/yyyy HH:mm').format(_startDate!) : 'Selecione'}",
                    ),
                    trailing: const Icon(Icons.calendar_month_outlined),
                    onTap: _pickDateTime,
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    "Tempo de uso da medicação:",
                    style: customTextLabelPrimary(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Prescrição indefinida?",
                        style: customTextLabel(),
                      ),
                      Switch(
                        value: _indefinite,
                        onChanged: (value) =>
                            setState(() => _indefinite = value),
                      )
                    ],
                  ),
                  if (!_indefinite) ...[
                    Text(
                      "Total de vezes que você tomará a medicação",
                      style: customTextLabelPrimary(),
                    ),
                    InputComponent(
                      controller: _totalOccurrences,
                      label: "Total de vezes",
                      hint: "Informe o total de vezes",
                      prefixIcon: Icons.calendar_today_outlined,
                      obscureText: false,
                      validator: (value) {
                        if (_indefinite && (value == null || value.isEmpty)) {
                          return "Informe o total de vezes";
                        }
                        return null;
                      },

                    ),
                  ],
                ],
              ),
              Divider(
                color: Colors.grey.shade100,
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Instruções adicionais",
                    style: customTextLabelPrimary(),
                  ),
                  InputComponent(
                    controller: _instructionsController,
                    label: "Escreva aqui...",
                    hint: "Ex: Tomar após o café",
                    prefixIcon: Icons.note_alt_outlined,
                    obscureText: false,
                    validator: (value) => null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Receber notificações?",
                        style: customTextLabel(),
                      ),
                      Switch(
                        value: _wantsNotifications,
                        onChanged: (value) =>
                            setState(() => _wantsNotifications = value),
                      )
                    ],
                  ),
                ],
              ),
              ButtonPrimaryComponent(
                onPressed: _submitForm,
                isLoading: false,
                text: "Salvar Prescrição",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
