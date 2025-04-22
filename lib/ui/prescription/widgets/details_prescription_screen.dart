import 'package:flutter/material.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/ui/prescription/widgets/text_details_prescription_component.dart';

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
        title: Text("Voltar"),
        centerTitle: false,
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
            Column(
              spacing: 8,
              children: [
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
            )
          ],
        ),
      ),
    );
  }
}
