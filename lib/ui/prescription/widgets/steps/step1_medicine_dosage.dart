import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../utils/custom_text_style.dart';
import '../../../../utils/enums.dart';
import '../../../core/dropdown_component.dart';
import '../../../core/input_component.dart';
import '../../../medicine/view_models/get_all_medicine_view_model.dart';
import 'add_prescription_wizard_model.dart';

class Step1MedicineDosage extends StatelessWidget {
  final TextEditingController dosageCtrl;
  const Step1MedicineDosage({super.key, required this.dosageCtrl});

  @override
  Widget build(BuildContext context) {
    final medsVm = context.watch<GetAllMedicineViewModel>();
    final model = context.watch<AddPrescriptionWizardModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 28,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Medicamento e Dosagem", style: customTextTitle()),

          DropdownComponent<int>(
            label: "Medicamento",
            value: model.medicineId,
            items: medsVm.medicines
                .map((m) => DropdownMenuEntry<int>(value: m.id, label: m.name))
                .toList(),
            onSelected: (v) {
              if (v == null) return;
              final name = medsVm.medicines.firstWhere((x) => x.id == v).name;
              context.read<AddPrescriptionWizardModel>().setMedicine(v, name);
            },
            leadingIcon: LucideIcons.pill,
            helperText: "Selecione seu medicamento",
          ),

          DropdownComponent<String>(
            label: "Unidade da Dose",
            value: model.dosageUnit,
            items: dosageUnitsMap.entries
                .map((e) => DropdownMenuEntry<String>(value: e.value, label: e.key))
                .toList(),
            onSelected: (v) {
              context.read<AddPrescriptionWizardModel>()
                  .setDosage(model.dosageAmount, v);
            },
            leadingIcon: LucideIcons.syringe,
            helperText: "Qual é o tipo do seu medicamento?",
          ),

          InputComponent(
            controller: dosageCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            label: "Dosagem",
            hint: "Quantidade da dose",
            prefixIcon: Icons.local_pharmacy_outlined,
            helperText: "Informe a dosagem conforme a unidade da dose",
            obscureText: false,
            validator: (_) => null,
            onChanged: (v) {
              final parsed = double.tryParse(v.replaceAll(',', '.'));
              context.read<AddPrescriptionWizardModel>()
                  .setDosage(parsed, model.dosageUnit);
            },
          ),
        ],
      ),
    );
  }
}