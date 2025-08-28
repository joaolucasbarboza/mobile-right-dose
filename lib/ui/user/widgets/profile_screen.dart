import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/ui/user/widgets/card_profile_component.dart';

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

    // Carrega os dados após o 1º frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDiseases();
    });
  }

  Future<void> _loadDiseases() async {
    await _viewModel.loadUserDiseases();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // Mock de restrições (você pode trocar por dados reais do backend)
  final restrictions = const [
    {'name': 'Intolerância à lactose', 'notes': 'Evitar leite e queijos'},
    {'name': 'Glúten', 'notes': 'Preferir opções sem glúten'},
  ];

  @override
  Widget build(BuildContext context) {
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

              final diseases = _viewModel.prescriptions; // ou o nome correto da lista no seu VM
              final hasDiseases = diseases.isNotEmpty;

              return RefreshIndicator(
                onRefresh: _loadDiseases,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Text("Meu perfil", style: customTextTitle()),
                    const SizedBox(height: 16),

                    ProfileInfoCard(),

                    const SizedBox(height: 24),
                    Text("Condições de saúde", style: customTextTitle()),
                    const SizedBox(height: 12),

                    // Doenças
                    Text("Doenças", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (hasDiseases)
                      ...ListTile.divideTiles(
                        context: context,
                        tiles: diseases.map(
                              (disease) => ListTile(
                            leading: const Icon(Icons.coronavirus_outlined),
                            title: Text(disease.disease?.description ?? '—'),
                            subtitle: Text("CID: ${disease.disease?.code ?? '—'}"),
                          ),
                        ),
                      ).toList()
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4, bottom: 8),
                        child: Text(
                          'Nenhuma doença cadastrada.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Restrições alimentares (mock)
                    Text("Restrições alimentares", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...ListTile.divideTiles(
                      context: context,
                      tiles: restrictions.map(
                            (r) => ListTile(
                          leading: const Icon(Icons.no_food_outlined),
                          title: Text(r['name'] as String),
                          subtitle: Text("Anotações: ${r['notes']}"),
                        ),
                      ),
                    ).toList(),

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