import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                    Text("Quantidade em estoque"),
                    Text(
                      "${medicine!.quantity.toString()} ${medicine!.unit}",
                      style: customTextSubtitle(medicine!.quantity),
                    ),
                    SizedBox(height: 16),
                    Text("Dosagem por unidade"),
                    Text(
                      "${medicine!.dosagePerUnit!.dosageAmount.toString()} ${medicine!.dosagePerUnit!.dosageUnit}",
                      style: customTextLabel(),
                    ),
                    SizedBox(height: 16),
                    Text("Data de criação"),
                    Text(
                      DateFormat('dd/MM/yyyy').format(medicine!.createdAt),
                      style: customTextLabel(),
                    ),
                    SizedBox(height: 16),
                    Text("Data da ultima atualização"),
                    Text(
                      DateFormat('dd/MM/yyyy').format(medicine!.updatedAt!),
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
