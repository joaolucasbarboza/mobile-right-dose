import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/ui/prescription/view_models/get_by_id_view_model.dart';
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
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = Provider.of<GetByIdViewModel>(context, listen: false);
      viewModel.prescription = widget.prescription;
      viewModel.findById(widget.prescription.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetByIdViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da Prescrição"),
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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.prescription == null
          ? const Center(child: Text("Prescrição não encontrada"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextDetailsPrescriptionComponent(
          prescription: provider.prescription!,
        ),
      ),
    );
  }
}
