import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/medicine.dart';
import 'package:tcc/utils/custom_text_style.dart';

class DetailsMedicineScreen extends StatefulWidget {
  final Medicine medicine;

  const DetailsMedicineScreen({super.key, required this.medicine});

  @override
  State<DetailsMedicineScreen> createState() => _DetailsMedicineScreenState();
}

class _DetailsMedicineScreenState extends State<DetailsMedicineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Detalhes do medicamento"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.medicine.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text("Descrição"),
              Text(
                widget.medicine.description.isNotEmpty
                    ? widget.medicine.description
                    : "Sem descrição",
                style: customTextLabel(),
              ),
              SizedBox(height: 16),
              Text("Data de criação"),
              Text(
                DateFormat('dd/MM/yyyy').format(widget.medicine.createdAt),
                style: customTextLabel(),
              ),
              SizedBox(height: 16),
              Text("Data da ultima atualização"),
              Text(
                DateFormat('dd/MM/yyyy').format(widget.medicine.updatedAt!),
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
}
