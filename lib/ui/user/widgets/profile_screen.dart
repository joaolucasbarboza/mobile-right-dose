import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/ui/user/widgets/card_profile_component.dart';
import 'package:tcc/ui/user/widgets/dietary_screen.dart';
import 'package:tcc/ui/user/widgets/disease_screen.dart';

import '../../../data/services/health_service.dart';
import '../../../utils/custom_text_style.dart';
import '../view_models/get_user_disease_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final GetUserDiseaseViewModel _viewModel;
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = context.read<AuthService>();
    _viewModel = GetUserDiseaseViewModel(HealthService(authService));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDiseases();
    });
  }

  Future<void> _loadDiseases() async {
    await _viewModel.loadUserDiseases();
    await _viewModel.loadUserDietaries();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color colorDivider = Colors.grey.shade200;

    final dividerTheme = const DividerThemeData(
      thickness: 1,
      space: 0,
      indent: 60,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Theme(
          data: Theme.of(context).copyWith(dividerTheme: dividerTheme),
          child: AnimatedBuilder(
            animation: _viewModel,
            builder: (context, _) {
              if (_viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_viewModel.errorMessage != null) {
                return Center(child: Text(_viewModel.errorMessage!));
              }

              final diseases = _viewModel.prescriptions;
              final userDietary = _viewModel.userDietaries;

              final hasDiseases = diseases.isNotEmpty;
              final hasUserDietary = userDietary.isNotEmpty;

              return RefreshIndicator(
                onRefresh: _loadDiseases,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Text("Meu perfil", style: customTextTitle()),
                    const SizedBox(height: 16),
                    ProfileInfoCard(),
                    Divider(
                      color: colorDivider,
                      height: 60,
                      indent: 40,
                      endIndent: 40,
                    ),
                    Text("Condições de saúde", style: customTextTitle()),
                    const SizedBox(height: 12),
                    Text("Doenças", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (!hasDiseases)
                      SizedBox(
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 32,
                          children: [
                            Column(
                              spacing: 12,
                              children: [
                                Icon(
                                  Icons.coronavirus_outlined,
                                  size: 62,
                                  color: Colors.grey.shade400,
                                ),
                                Text(
                                  'Nenhuma doença cadastrada.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            ButtonSecondaryComponent(
                              text: "Adicionar doença",
                              isLoading: _viewModel.isLoading,
                              icon: Icons.add_rounded,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseaseScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ...ListTile.divideTiles(
                      context: context,
                      tiles: diseases.map(
                        (disease) => ListTile(
                          leading: const Icon(Icons.coronavirus_outlined),
                          title: Text(disease.disease?.description ?? '—'),
                          subtitle: Text("CID: ${disease.disease?.code ?? '—'}"),
                        ),
                      ),
                    ),
                    Divider(
                      color: colorDivider,
                      indent: 40,
                      endIndent: 40,
                      height: 40,
                    ),
                    Text("Restrições alimentares", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (!hasUserDietary)
                      SizedBox(
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 32,
                          children: [
                            Column(
                              spacing: 12,
                              children: [
                                Icon(
                                  Icons.no_food_outlined,
                                  size: 62,
                                  color: Colors.grey.shade400,
                                ),
                                Text(
                                  'Nenhuma restrição alimentar cadastrada.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            ButtonSecondaryComponent(
                              text: "Adicionar restrição alimentar",
                              isLoading: _viewModel.isLoading,
                              icon: Icons.add_rounded,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DietaryScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ...ListTile.divideTiles(
                      context: context,
                      tiles: userDietary.map(
                        (dietary) => ListTile(
                          leading: const Icon(Icons.no_food_outlined),
                          title: Text(dietary.dietary.description),
                          subtitle: (dietary.notes != null && dietary.notes!.trim().isNotEmpty)
                              ? Text(dietary.notes!.trim())
                              : Text(
                                  "Sem observações",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
