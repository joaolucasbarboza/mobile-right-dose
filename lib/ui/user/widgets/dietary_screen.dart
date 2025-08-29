import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/dietary.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/ui/core/input_component.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/user/view_models/create_health_view_model.dart';
import 'package:tcc/utils/custom_text_style.dart';

class DietaryScreen extends StatefulWidget {
  const DietaryScreen({super.key});

  @override
  State<DietaryScreen> createState() => _DietaryScreenState();
}

class _DietaryScreenState extends State<DietaryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateHealthViewModel>().loadAllDietaries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateHealthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: provider.formKeyDietary,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              spacing: 26,
              children: [
                Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Você possui alguma restrição alimentar?",
                      style: customTextTitle(),
                    ),
                    Text(
                      "Adicione suas condições de saúde para personalizar sua experiência no aplicativo. Ao cadastrar, você receberá recomendações específicas para cada refeição do dia, além de alertas importantes para o seu cuidado.",
                      style: customTextLabel2(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24,
                  children: [
                    DropdownSearch<Dietary>(
                      items: provider.dietarySearchResults,
                      selectedItem: provider.selectedDietary,
                      itemAsString: (d) => d.description ?? '—',
                      compareFn: (a, b) => a.id == b.id,
                      onChanged: (d) {
                        if (d == null) return;
                        provider.onDietarySelected(d);
                        FocusScope.of(context).unfocus();
                      },
                      validator: (d) => d == null ? 'Selecione uma restrição' : null,
                      enabled: !provider.isLoading,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Restrição',
                          hintText: 'Selecione uma restrição',
                          prefixIcon: const Icon(Icons.local_hospital_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(width: 1.5, color: Colors.grey.shade200),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(width: 1.5, color: Colors.redAccent),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(width: 2, color: Colors.redAccent),
                          ),
                        ),
                      ),
                      popupProps: PopupProps.bottomSheet(
                        showSelectedItems: true,
                        isFilterOnline: true,
                        showSearchBox: true,
                        bottomSheetProps: BottomSheetProps(
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Buscar restrução...',
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                              borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(26),
                              borderSide: BorderSide(width: 1.5, color: Colors.grey.shade400),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(width: 1.5, color: Colors.redAccent),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(width: 2, color: Colors.redAccent),
                            ),
                          ),
                        ),
                        emptyBuilder: (ctx, _) => const Center(child: Text("Nenhum resultado encontrado")),
                        loadingBuilder: (ctx, _) => const Center(child: CircularProgressIndicator()),
                        itemBuilder: (context, item, isSelected) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(item.description ?? '—'),
                                selected: isSelected,
                              ),
                              const Divider(
                                height: 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    InputComponent(
                      controller: provider.notesController,
                      label: "Anotações",
                      hint: "Digite anotações adicionais",
                      prefixIcon: Icons.description_outlined,
                      obscureText: false,
                    ),
                    ButtonPrimaryComponent(
                      onPressed: () async {
                        if (provider.formKeyDietary.currentState!.validate()) {
                          final success = await provider.addDietary(context);
                          if (success && context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "/home",
                                  (route) => false,
                            );
                          }
                          // se não tiver sucesso, só fica na tela
                        }
                      },
                      isLoading: provider.isLoading,
                      text: "Próximo",
                    ),
                    ButtonSecondaryComponent(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                              (route) => false,
                        );
                      },
                      isLoading: provider.isLoading,
                      text: "Fazer isso mais tarde",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
