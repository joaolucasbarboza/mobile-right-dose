import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ui/medicine/view_models/get_all_medicine_view_model.dart';
import 'package:tcc/ui/medicine/widgets/add_medicine_screen.dart';
import 'package:tcc/ui/medicine/widgets/details_medicine_screen.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => Provider.of<GetAllMedicineViewModel>(context, listen: false).fetchMedicines(),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<GetAllMedicineViewModel>(context, listen: false).fetchMedicines(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetAllMedicineViewModel>(context);

    final medicines = provider.medicines.where((m) {
      final q = _searchText.toLowerCase();
      return m.name.toLowerCase().contains(q);
    }).toList();

    final listChildren = medicines.map((medicine) {
      final colorIndex = medicine.name.hashCode % Colors.primaries.length;
      final bg = Colors.primaries[colorIndex].shade200;

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailsMedicineScreen(medicine: medicine),
            ),
          );
        },
        title: Text(
          medicine.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: bg,
          child: Text(
            medicine.name.isNotEmpty ? medicine.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: const Text(
          "Toque para ver detalhes",
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        trailing: const Icon(LucideIcons.chevronRight500),
      );
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Adicionar"),
        icon: const Icon(LucideIcons.plus500),
          onPressed: () async {
            final added = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (ctx) => const AddMedicineBottomSheet(),
            );

            if (added == true && mounted) {
              _refresh(context);
            }
          }
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
          hintText: "Buscar medicamento",
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
            : medicines.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Center(child: Text("Nenhum medicamento encontrado")),
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