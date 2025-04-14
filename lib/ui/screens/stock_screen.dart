import 'package:flutter/material.dart';
import 'package:tcc/models/medicine.dart';
import 'package:tcc/services/medicine_service.dart';
import 'package:tcc/ui/components/medicine_card_component.dart';
import 'package:tcc/ui/screens/add_medicine_screen.dart';
import 'package:tcc/ui/screens/details_medicine.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final _medicineService = MedicineService();
  final List<Medicine> medicines = [];
  bool isLoading = true;
  bool _isFetched = false;

  @override
  void initState() {
    super.initState();
    if (!_isFetched) {
      _fetchMedicine();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onRefresh: _fetchMedicine,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
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
                                  builder: (context) => DetailsMedicine(
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

  Future<void> _fetchMedicine() async {
    setState(() {
      isLoading = true;
    });

    try {
      final medicineList = await _medicineService.medicine();
      setState(() {
        medicines.clear();
        medicines.addAll(medicineList.map((medicineMap) {
          return Medicine.fromMap(medicineMap);
        }).toList());
        print(medicines);
        isLoading = false;
        _isFetched = true;
      });
    } catch (e) {
      print('Erro ao carregar medicamentos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}
