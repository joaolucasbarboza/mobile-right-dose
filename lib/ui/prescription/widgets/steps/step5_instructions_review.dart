import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/utils/enums.dart';

import '../../../../utils/custom_text_style.dart';
import '../../../core/input_component.dart';
import 'add_prescription_wizard_model.dart';

class Step5InstructionsReview extends StatelessWidget {
  final TextEditingController instrCtrl;
  final DateFormat df;
  const Step5InstructionsReview({super.key, required this.instrCtrl, required this.df});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<AddPrescriptionWizardModel>();
    instrCtrl.text = m.instructions ?? '';

    Color colorDivider = Colors.grey.shade300;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 22,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Instruções e Notificações", style: customTextTitle()),
          InputComponent(
            controller: instrCtrl,
            label: "Instruções extras... (Opicional)",
            hint: "Ex: Tomar após o café...",
            helperText: "Ex: Tomar sempre após comer algo",
            prefixIcon: Icons.note_alt_outlined,
            obscureText: false,
            validator: (_) => null,
            onChanged: (v) => context.read<AddPrescriptionWizardModel>().setInstructions(v),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Deseja receber notificações?", style: const TextStyle(fontSize: 18),),
              Switch(
                value: m.wantsNotifications,
                onChanged: (v) => context.read<AddPrescriptionWizardModel>().setWantsNotifications(v),
              ),
            ],
          ),

          Divider(
              height: 24,
            indent: 0,
            endIndent: 0,
          ),

          Text("Revisão", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          _kv("Medicamento", m.medicineName ?? m.medicineId?.toString() ?? "-"),
          Divider(
            color: colorDivider,
            height: 2,
            indent: 0,
          ),
          _kv("Dosagem", m.dosageAmount != null && m.dosageUnit != null ? "${m.dosageAmount} "
              "${getDosageUnitLabel(m.dosageUnit)}" : "-"),
          Divider(
            color: colorDivider,
            height: 2,
            indent: 0,
          ),
          _kv("Frequência", m.frequency != null && m.uomFrequency != null ? "A cada ${m.frequency} ${getUomFrequencyLabel(m.uomFrequency)}" : "-"),
          Divider(
            color: colorDivider,
            height: 2,
            indent: 0,
          ),
          _kv("Início", m.startDate != null ? df.format(m.startDate!) : "-"),
          Divider(
            color: colorDivider,
            height: 2,
            indent: 0,
          ),
          _kv("Indefinida", m.indefinite ? "Sim" : "Não"),
          Divider(
            color: colorDivider,
            height: 2,
            indent: 0,
          ),
          _kv("Total de vezes", m.totalOccurrences?.toString() ?? "Não possui um total definido"),
          Divider(
            color: colorDivider,
            height: 2,
            indent: 0,
          ),
          _kv("Notificações", m.wantsNotifications ? "Sim" : "Não"),
          Divider(
            color: colorDivider,
            height: 2,
            indent: 0,
          ),
          _kv("Instruções", m.instructions?.isNotEmpty == true ? m.instructions! : "-"),
          const SizedBox(height: 12),
          const Text("Toque em SALVAR para concluir.", style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: const TextStyle(fontWeight: FontWeight.w500)),
        Flexible(child: Text(v, textAlign: TextAlign.right)),
      ],
    );
  }
}

