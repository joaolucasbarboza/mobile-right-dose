import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/medicine.dart';
import 'package:tcc/data/services/medicine_service.dart';
import 'package:tcc/ui/core/medicine_card_component.dart';
import 'package:tcc/ui/medicine/view_models/get_all_medicine_view_model.dart';
import 'package:tcc/ui/medicine/widgets/add_medicine_screen.dart';
import 'package:tcc/ui/medicine/widgets/details_medicine_screen.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<GetAllMedicineViewModel>(
          context,
          listen: false,
        ).fetchMedicines()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetAllMedicineViewModel>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddMedicineScreen(),
            ),
          );
        },
        child: Icon(Icons.add_rounded),
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: SearchBar(
          elevation: WidgetStatePropertyAll(0),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16),
          ),
          hintText: "Pesquisar medicamento...",
          leading: const Icon(Icons.search_rounded),
        ),
      ),
      body: Container(
        color: Color(0xFFF8F9FC),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.fetchMedicines(force: true),
                child: provider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: provider.medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = provider.medicines[index];
                          return MedicineCardComponent(
                            backgroundColor: Colors.deepOrange.shade100,
                            colorIcon: Colors.deepOrange.shade400,
                            id: medicine.medicineId,
                            name: medicine.name,
                            unit: medicine.unit,
                            quantity: medicine.quantity,
                            icon: Icons.medication,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailsMedicineScreen(
                                      medicineId: medicine.medicineId),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
