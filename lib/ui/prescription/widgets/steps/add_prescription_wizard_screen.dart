import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/ui/medicine/view_models/get_all_medicine_view_model.dart';
import 'package:tcc/ui/prescription/view_models/add_prescription_view_model.dart';
import 'package:tcc/ui/prescription/widgets/steps/step2_frequency.dart';
import 'package:tcc/ui/prescription/widgets/steps/step3_StartDate.dart';
import 'package:tcc/ui/prescription/widgets/steps/step4_duration.dart';
import 'package:tcc/ui/prescription/widgets/steps/step5_instructions_review.dart';

import 'step1_medicine_dosage.dart';
import 'add_prescription_wizard_model.dart'; // arquivo do model acima

class AddPrescriptionWizardScreen extends StatefulWidget {
  const AddPrescriptionWizardScreen({super.key});

  @override
  State<AddPrescriptionWizardScreen> createState() => _AddPrescriptionWizardScreenState();
}

class _AddPrescriptionWizardScreenState extends State<AddPrescriptionWizardScreen> {
  final _pageController = PageController();
  int _current = 0;

  final _dosageCtrl = TextEditingController();
  final _freqCtrl = TextEditingController();
  final _totalOccCtrl = TextEditingController();
  final _instrCtrl = TextEditingController();

  DateFormat df = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<GetAllMedicineViewModel>().fetchMedicines());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dosageCtrl.dispose();
    _freqCtrl.dispose();
    _totalOccCtrl.dispose();
    _instrCtrl.dispose();
    super.dispose();
  }

  void _goNext(BuildContext context) {
    final model = context.read<AddPrescriptionWizardModel>();
    final err = model.validateStep(_current);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err), backgroundColor: Colors.redAccent));
      return;
    }
    if (_current < 4) {
      setState(() => _current++);
      _pageController.animateToPage(_current, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    } else {
      _submit(context);
    }
  }

  void _goBack() {
    if (_current > 0) {
      setState(() => _current--);
      _pageController.animateToPage(_current, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submit(BuildContext context) async {
    final addVm = context.read<AddPrescriptionViewModel>();
    final model = context.read<AddPrescriptionWizardModel>();
    final req = model.toRequest();

    try {
      await addVm.addPrescription(req);

      model.reset();
      _dosageCtrl.clear();
      _freqCtrl.clear();
      _totalOccCtrl.clear();
      _instrCtrl.clear();
      setState(() => _current = 0);
      _pageController.jumpToPage(0);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Prescrição adicionada com sucesso!"), backgroundColor: Colors.green),
        );
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao adicionar: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepsTotal = 5;
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Prescrição (${_current + 1}/$stepsTotal)"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: LinearProgressIndicator(
                value: (_current + 1) / stepsTotal,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Step1MedicineDosage(dosageCtrl: _dosageCtrl),
                  Step2Frequency(),
                  Step3StartDate(),
                  Step4Duration(totalOccCtrl: _totalOccCtrl),
                  Step5InstructionsReview(instrCtrl: _instrCtrl, df: df),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonSecondaryComponent(
                      onPressed: _goBack,
                      isLoading: false,
                      text: "Voltar",
                      icon: LucideIcons.undo2500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonPrimaryComponent(
                      icon: _current == stepsTotal - 1
                          ? LucideIcons.save500
                          : LucideIcons.arrowBigRight600,
                      text: _current == stepsTotal - 1 ? "Salvar" : "Continuar",
                      isLoading: false,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _goNext(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
