import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/medicine_service.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/ui/core/input_component.dart';

Future<bool?> showAddMedicineBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => const AddMedicineBottomSheet(),
  );
}

class AddMedicineBottomSheet extends StatefulWidget {
  const AddMedicineBottomSheet({super.key});

  @override
  State<AddMedicineBottomSheet> createState() => _AddMedicineBottomSheetState();
}

class _AddMedicineBottomSheetState extends State<AddMedicineBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _medicineService = MedicineService(AuthService());
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Preencha todos os campos obrigatórios."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final payload = {
      "name": _nameCtrl.text.trim(),
      "description": _descriptionCtrl.text.trim(),
    };

    try {
      await _medicineService.addMedicine(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Medicamento adicionado com sucesso!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: insets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.36,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(LucideIcons.pill600, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Adicionar medicamento",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22, color: Colors.grey.shade800),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              InputComponent(
                label: "Nome do medicamento",
                helperText: "Digite o nome do seu medicamento",
                controller: _nameCtrl,
                hint: "Exemplo: Dipirona...",
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Digite o nome do medicamento.";
                  } else if (value.trim().length <= 3) {
                    return "Digite um nome maior.";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              InputComponent(
                label: "Descrição do medicamento (opcional)",
                helperText: "Digite a descrição do medicamento, se desejar.",
                controller: _descriptionCtrl,
                hint: "Ex: Esse medicamento é para dores de cabeça...",
                keyboardType: TextInputType.text,
                validator: (_) => null,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ButtonSecondaryComponent(
                      text: "Cancelar",
                      isLoading: false,
                      icon: LucideIcons.x500,
                      onPressed: () {
                        if (_isSaving) return;
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ButtonPrimaryComponent(
                        text: "Adicionar",
                        isLoading: _isSaving,
                        icon: LucideIcons.plus400,
                        onPressed: _isSaving ? null : _submit,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}