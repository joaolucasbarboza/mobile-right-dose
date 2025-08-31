import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/prescription/view_models/get_all_prescription_view_model.dart';
import 'package:tcc/ui/prescription/widgets/details_prescription_screen.dart';
import 'package:tcc/utils/custom_text_style.dart';
import 'package:tcc/utils/format_strings.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionsScreen> {
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => Provider.of<GetAllPrescriptionViewModel>(context, listen: false).fetchPrescriptions(),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<GetAllPrescriptionViewModel>(context, listen: false).fetchPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetAllPrescriptionViewModel>(context);

    final prescriptions = provider.prescriptions.where((p) {
      final q = _searchText.toLowerCase();
      return p.medicine.name.toLowerCase().contains(q) ||
          p.frequency.toString().contains(q) ||
          p.uomFrequency.toLowerCase().contains(q);
    }).toList();

    final listChildren = prescriptions.map((prescription) {
      final colorIndex = prescription.medicine.name.hashCode % Colors.primaries.length;
      final bg = Colors.primaries[colorIndex].shade200;

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailsPrescriptionScreen(prescription: prescription),
            ),
          );
        },
        title: Text(prescription.medicine.name, style: customTextLabelPrimary()),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: bg,
          child: Text(
            prescription.medicine.name.isNotEmpty ? prescription.medicine.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              "A cada ${prescription.frequency} ${formatUomFrequency(prescription.uomFrequency)}, ",
              style: customTextLabel(),
            ),
            Text(
              (prescription.totalOccurrences == 0) ? "indeterminado" : "${prescription.totalOccurrences} vezes",
              style: customTextLabel(),
            ),
          ],
        ),
        trailing: const Icon(LucideIcons.chevronRight500),
      );
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
      label: Text("Adicionar"),
        icon: Icon(LucideIcons.plus500),
        onPressed: () {
          Navigator.pushNamed(context, '/prescriptions/new');
        },
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
          hintText: "Buscar prescrição",
          leading: const Icon(LucideIcons.search600),
          onChanged: (value) => setState(() => _searchText = value),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: provider.isLoading
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 400),
          ],
        )
            : prescriptions.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Center(child: Text("Nenhuma prescrição encontrada")),
            SizedBox(height: 400),
          ],
        )
            : ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: ListTile
              .divideTiles(
            context: context,
            color: Colors.grey.shade300,
            tiles: listChildren,
          )
              .toList(),
        ),
      ),
    );
  }
}