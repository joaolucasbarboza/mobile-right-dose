import 'package:flutter/material.dart';
import 'package:tcc/models/medicine.dart';
import 'package:tcc/services/medicine_service.dart';
import 'package:tcc/utils/custom_text_style.dart';

class DetailsMedicine extends StatefulWidget {
  final int? medicineId;

  const DetailsMedicine({super.key, required this.medicineId});

  @override
  State<DetailsMedicine> createState() => _DetailsMedicineState();
}

class _DetailsMedicineState extends State<DetailsMedicine> {
  final _medicineService = MedicineService();
  Medicine? medicine;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicineDetails(widget.medicineId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Detalhes do medicamento"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text("Nome"),
                    Text(
                      medicine!.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("Descrição"),
                    Text(
                      medicine!.description.isNotEmpty
                          ? medicine!.description
                          : "Sem descrição",
                      style: customTextLabel(),
                    ),
                    SizedBox(height: 16),
                    Text("Quantidade"),
                    Text(
                      medicine!.quantity.toString(),
                      style: customTextLabel(),
                    ),
                    SizedBox(height: 16),
                    Text("Unidade"),
                    Text(
                      medicine!.unit,
                      style: customTextLabel(),
                    ),
                    SizedBox(height: 16),
                    Text("Data de criação"),
                    Text(
                      medicine!.createdAt.toString(),
                      style: customTextLabel(),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.tonalIcon(
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 24,
                        ),
                        label: Text("Editar"),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        icon: Icon(
                          Icons.delete_outlined,
                          size: 24,
                        ),
                        label: Text("Excluir"),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _fetchMedicineDetails(int? medicineId) async {
    setState(() {
      isLoading = true;
    });

    try {
      Medicine medicine = await _medicineService.getMedicineById(medicineId!);
      setState(() {
        this.medicine = medicine;
      });

      print(medicine.toMap());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  
}
