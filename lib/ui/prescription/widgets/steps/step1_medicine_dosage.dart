import 'package:flutter/material.dart';
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
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Medicamento e Dosagem", style: customTextTitle()),
          DropdownComponent<int>(
            label: "Medicamento",
            value: model.medicineId,
            items: medsVm.medicines.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name))).toList(),
            onChanged: (v) {
              final name = medsVm.medicines.firstWhere((x) => x.id == v).name;
              context.read<AddPrescriptionWizardModel>().setMedicine(v, name);
            },
            validator: (_) => null,
            prefixIcon: Icons.medication_outlined,
          ),
          InputComponent(
            controller: dosageCtrl,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            label: "Dosagem",
            hint: "Quantidade da dose",
            prefixIcon: Icons.local_pharmacy_outlined,
            obscureText: false,
            validator: (_) => null,
            onChanged: (v) {
              final parsed = double.tryParse(v.replaceAll(',', '.'));
              context.read<AddPrescriptionWizardModel>().setDosage(parsed, model.dosageUnit);
            },
          ),
          DropdownComponent<String>(
            label: "Unidade da Dose",
            value: model.dosageUnit,
            items: dosageUnitsMap.entries
                .map((e) => DropdownMenuItem(
              value: e.value,
              child: Text(e.key),
            ))
                .toList(),
            onChanged: (v) =>
                context.read<AddPrescriptionWizardModel>().setDosage(model.dosageAmount, v),
            validator: (_) => null,
            prefixIcon: Icons.straighten,
          ),
        ],
      ),
    );
  }
}