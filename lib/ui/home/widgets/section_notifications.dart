import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/prescription/widgets/details_prescription_screen.dart';

import '../../prescription/view_models/get_all_prescription_view_model.dart';

class SectionNotifications extends StatelessWidget {
  const SectionNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GetAllPrescriptionViewModel>(context);
    final prescriptions = viewModel.prescriptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prescriptions.isEmpty)
          const Center(child: Text("Nenhuma notificação encontrada."))
        else
          ...prescriptions.map((prescription) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.medication_outlined),
                  trailing: const Icon(Icons.navigate_next_outlined),
                  title: Text(prescription.medicine.name),
                  subtitle:
                  Text("${prescription.dosageAmount} ${prescription
                      .dosageUnit}"),
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsPrescriptionScreen(
                              prescription: prescription,
                            ),
                      ),
                    );
                  },
                ),
              ),
            );
          })
      ],
    );
  }
}