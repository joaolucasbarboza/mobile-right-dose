import 'package:flutter/material.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/ui/prescription/widgets/text_details_prescription_component.dart';
import 'package:tcc/utils/custom_text_style.dart';

class DetailsPrescriptionScreen extends StatefulWidget {
  final Prescription prescription;

  const DetailsPrescriptionScreen({super.key, required this.prescription});

  @override
  State<DetailsPrescriptionScreen> createState() =>
      _DetailsPrescriptionScreenState();
}

class _DetailsPrescriptionScreenState extends State<DetailsPrescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            elevation: 1,
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text("Editar"),
                ),
                onTap: () {},
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.delete_outlined),
                  title: Text("Excluir"),
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            TextDetailsPrescriptionComponent(
              prescription: widget.prescription,
            ),
          ],
        ),
      ),
    );
  }
}
