import 'package:flutter/material.dart';
import 'package:tcc/models/medicine.dart';
import 'package:tcc/services/medicine_service.dart';
import 'package:tcc/ui/components/medicine_card_component.dart';
import 'package:tcc/ui/screens/add_medicine_screen.dart';
import 'package:tcc/ui/screens/details_medicine.dart';
import 'package:tcc/utils/custom_text_style.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final _medicineService = MedicineService();
  final List<Medicine> medicines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicine();
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
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text('Meus medicamentos', style: customTextTitle()),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total de medicamentos: ${medicines.length}"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchMedicine,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        reverse: false,
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
                          return MedicineCardComponent(
                            name: medicine.name,
                            unit: medicine.unit,
                            quantity: medicine.quantity,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailsMedicine(),
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
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar medicamentos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}
