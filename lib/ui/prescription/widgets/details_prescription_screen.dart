import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/prescription.dart';
import 'package:tcc/ui/core/navigationBar.dart';
import 'package:tcc/ui/prescription/view_models/delete_by_id_prescription_view_model.dart';
import 'package:tcc/ui/prescription/view_models/get_by_id_view_model.dart';
import 'package:tcc/ui/prescription/widgets/text_details_prescription_component.dart';

class DetailsPrescriptionScreen extends StatefulWidget {
  final Prescription prescription;

  const DetailsPrescriptionScreen({super.key, required this.prescription});

  @override
  State<DetailsPrescriptionScreen> createState() => _DetailsPrescriptionScreenState();
}

class _DetailsPrescriptionScreenState extends State<DetailsPrescriptionScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = Provider.of<GetByIdViewModel>(context, listen: false);
      viewModel.prescription = widget.prescription;
      viewModel.findById(widget.prescription.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetByIdViewModel>(context);
    final deleteProvider = Provider.of<DeleteByIdPrescriptionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(LucideIcons.circleEllipsis500),
            onPressed: () {
              HapticFeedback.mediumImpact();
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.5,
                    minChildSize: 0.2,
                    maxChildSize: 0.5,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Opções",
                                style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onBackground),
                              ),
                              Text(
                                "Selecione uma das opções abaixo",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  spacing: 8,
                                  children: [
                                    ListTile(
                                      leading: const Icon(LucideIcons.pencil600),
                                      title: const Text('Editar'),
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                      },
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(LucideIcons.trash600, color: Colors.red),
                                      title: const Text('Excluir'),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              actionsAlignment: MainAxisAlignment.spaceBetween,
                                              actionsOverflowAlignment: OverflowBarAlignment.center,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              title: Text(
                                                  'Deseja mesmo excluir "${widget.prescription.medicine.name}"?',
                                                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
                                              content: Text(
                                                  "Todos os lembretes e informações associadas a esta prescrição serão excluídos.",
                                                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
                                              actions: [
                                                FilledButton(
                                                  onPressed: () async {
                                                    final response = await deleteProvider
                                                        .deleteByIdPrescription(widget.prescription.id);

                                                    if (response == 204) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text("Prescrição excluída com sucesso!"),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );

                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => const NavigationComponent(initialIndex: 1),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text("Erro ao excluir prescrição!"),
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      );
                                                      Navigator.of(context).pop();
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    minimumSize:
                                                        WidgetStateProperty.all(const Size(double.infinity, 48)),
                                                  ),
                                                  child: const Text("Excluir mesmo assim"),
                                                ),
                                                const SizedBox(height: 8),
                                                FilledButton.tonal(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ButtonStyle(
                                                    minimumSize:
                                                        WidgetStateProperty.all(const Size(double.infinity, 48)),
                                                  ),
                                                  child: const Text("Cancelar"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        HapticFeedback.mediumImpact();
                                      },
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.prescription == null
              ? const Center(child: Text("Prescrição não encontrada"))
              : TextDetailsPrescriptionComponent(
                  prescription: provider.prescription!,
                ),
    );
  }
}
