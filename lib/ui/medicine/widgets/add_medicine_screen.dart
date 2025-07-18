import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/medicine_service.dart';
import 'package:tcc/utils/custom_input_decoration.dart';
import 'package:tcc/utils/custom_text_style.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  String? _selectedUnit;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: "1");
  final _descriptionController = TextEditingController();
  final _medicineService = MedicineService(AuthService());
  bool isLoading = false;

  final Map<String, String> _units = {
    'MILLIGRAM': 'Miligrama',
    'MICROGRAM': 'Micrograma',
    'GRAM': 'Grama',
    'KILOGRAM': 'Quilograma',
    'MILLILITER': 'Mililitro',
    'LITER': 'Litro',
    'UNIT': 'Unidade',
    'DROP': 'Gota',
    'TABLET': 'Comprimido',
    'CAPSULE': 'Cápsula',
    'TEASPOON': 'Colher de chá',
    'TABLESPOON': 'Colher de sopa',
    'INHALATION': 'Inalação',
    'PATCH': 'Adesivo',
    'PUFF': 'Jato',
    'DOSE': 'Dose'
  };

  void _incrementQuantity() {
    setState(() {
      int currentQuantity = int.tryParse(_quantityController.text) ?? 0;
      _quantityController.text = (currentQuantity + 1).toString();
    });
  }

  void _decrementQuantity() {
    setState(() {
      int currentQuantity = int.tryParse(_quantityController.text) ?? 0;
      if (currentQuantity > 1) {
        _quantityController.text = (currentQuantity - 1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar medicamento"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nome", style: customTextLabel()),
              TextFormField(
                controller: _nameController,
                decoration: customInputDecoration("Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite o nome do medicamento.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Descrição (opcional)",
                style: customTextLabel(),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: customInputDecoration("Descrição"),
              ),
              const SizedBox(height: 16),
              Text(
                "Quantidade em estoque",
                style: customTextLabel(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      textAlign: TextAlign.center,
                      decoration: customInputDecoration("Quantidade"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Digite a quantidade em estoque.";
                        } else if (int.tryParse(value)! < 1) {
                          return "A quantidade deve ser maior que zero.";
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.minimize_rounded),
                    onPressed: _decrementQuantity,
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.add_rounded),
                    onPressed: _incrementQuantity,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("Unidade", style: customTextLabel()),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: customInputDecoration(""),
                hint: const Text(
                  'Selecione a unidade',
                  style: TextStyle(fontSize: 14),
                ),
                items: _units.entries
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item.key,
                        child: Text(
                          item.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                    .toList(),
                validator: (value) =>
                    value == null ? 'Selecione uma unidade.' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value;
                    print(value);
                  });
                },
                onSaved: (value) {
                  _selectedUnit = value;
                },
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addMedicine();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.redAccent,
                          content:
                              Text("Preencha todos os campos obrigatórios."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text("Adicionar Medicamento"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addMedicine() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final Map<String, dynamic> medicine = {
        "name": _nameController.text.trim(),
        "description": _descriptionController.text.trim(),
        "quantity": int.parse(_quantityController.text),
        "unit": _selectedUnit,
      };

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Adicionando medicamento..."),
              ],
            ),
          ),
        );

        await _medicineService.addMedicine(medicine);
        Navigator.pop(context);

        Future.delayed(
          const Duration(seconds: 1),
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Medicamento adicionado com sucesso!"),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
