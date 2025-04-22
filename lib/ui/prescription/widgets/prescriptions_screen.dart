import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/prescription/view_models/get_all_prescription_view_model.dart';
import 'package:tcc/ui/prescription/widgets/add_prescription_screen.dart';
import 'package:tcc/ui/prescription/widgets/details_prescription_screen.dart';
import 'package:tcc/utils/custom_text_style.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<GetAllPrescriptionViewModel>(
        context,
        listen: false,
      ).fetchPrescriptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetAllPrescriptionViewModel>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddPrescriptionScreen(),
            ),
          );
        },
        child: Icon(Icons.add_rounded),
      ),
      appBar: AppBar(
        title: Text(
          "Minhas Prescrições",
          style: customTextTitle(),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: provider.prescriptions.length,
                    itemBuilder: (context, index) {
                      final prescription = provider.prescriptions[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white, // se quiser fundo branco
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailsPrescriptionScreen(
                                  prescription: prescription,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            prescription.medicine.name,
                            style: customTextLabelPrimary(),
                          ),
                          subtitle: Text(
                            "A cada ${prescription.frequency} ${prescription.uomFrequency.toLowerCase()} por ${prescription.totalDays} dias",
                            style: customTextLabel(),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
