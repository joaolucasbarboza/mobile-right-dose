import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tcc/models/recommendation.dart';
import 'package:tcc/ui/core/button_primary_component.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';
import 'package:tcc/ui/recommendationsAi/widgets/recommendations_screen.dart';
import 'package:tcc/utils/custom_text_style.dart';
import '../../../models/meals.dart';
import '../view_model/generate_ai_view_model.dart';

class SectionRecommendationsComponent extends StatelessWidget {
  final GenerateAiViewModel viewModel;

  const SectionRecommendationsComponent({super.key, required this.viewModel});

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        Widget body;
        if (viewModel.isLoading && viewModel.data == null) {
          body = const _Skeleton();
        } else if (viewModel.error != null && viewModel.data == null) {
          body = _ErrorState(
            message: viewModel.error!,
            onRetry: () => viewModel.generateRecommendation(),
          );
        } else if (viewModel.data == null) {
          body = _EmptyState(onRefresh: () => viewModel.generateRecommendation());
        } else {
          body = _RecommendationView(data: viewModel.data!, df: _dateFormat);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              dateFormat: _dateFormat,
              data: viewModel.data,
              onRefresh: () => viewModel.generateRecommendation(),
              trailing: viewModel.isLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : null,
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120, minWidth: 250),
              child: body,
            ),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onRefresh;
  final Widget? trailing;
  final Recommendation? data;
  final DateFormat dateFormat;

  const _Header({
    required this.onRefresh,
    this.trailing,
    this.data,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recomendação da IA', style: customTextTitle()),
              if (data != null)
                Text(
                  'Gerado em ${dateFormat.format(data!.generatedAt.toLocal())}',
                  style: customTextLabel(),
                )
              else
                Text('Ainda não gerado', style: customTextLabel()),
            ],
          ),
        ),
        IconButton(tooltip: 'Atualizar', onPressed: onRefresh, icon: const Icon(LucideIcons.loaderCircle500)),
        if (trailing != null) trailing!,
      ],
    );
  }
}


class _RecommendationView extends StatelessWidget {
  final Recommendation data;
  final DateFormat df;

  const _RecommendationView({required this.data, required this.df});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MealsList(meals: data.meals, alerts: data.alerts, substitutions: data.substitutions),
      ],
    );
  }
}

class _MealsList extends StatelessWidget {
  final Meals meals;
  final List<String> alerts;
  final List<String> substitutions;

  const _MealsList({required this.meals, required this.alerts, required this.substitutions});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    final rows = <({IconData icon, String label, String value})>[
      (icon: LucideIcons.sun500, label: 'Café da manhã', value: meals.breakfast),
      (icon: LucideIcons.sandwich500, label: 'Almoço', value: meals.lunch),
      (icon: LucideIcons.moon500, label: 'Jantar', value: meals.dinner),
      (icon: LucideIcons.coffee500, label: 'Lanche da manhã', value: meals.snackMorning),
      (icon: LucideIcons.coffee500, label: 'Lanche da tarde', value: meals.snackAfternoon),
    ].where((e) => e.value.trim().isNotEmpty).toList();

    return Column(
      children: [
        Column(
          children: rows.map((e) {
            return Column(
              children: [
                ListTile(
                  tileColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: Icon(e.icon, color: c.primary),
                  title: Text(e.label, style: TextStyle(fontWeight: FontWeight.w600, color: c.onSurface)),
                  subtitle: Text(e.value, style: TextStyle(color: c.onSurfaceVariant)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: c.outlineVariant, width: 0.5),
                  ),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.label, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(e.value, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        ),
        ButtonPrimaryComponent(
          text: "Ver detalhes",
          isLoading: false,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecommendationsScreen(meals: meals, alerts: alerts, substitutions: substitutions),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Icon(LucideIcons.network, size: 40, color: c.outline),
                const SizedBox(height: 8),
                Text('Nenhuma recomendação no momento', style: TextStyle(color: c.onSurfaceVariant)),
                const SizedBox(height: 12),
                ButtonSecondaryComponent(icon: LucideIcons.brain300, text: "Gerar recomendações", isLoading: false, onPressed: onRefresh)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.bug500, size: 40, color: c.error),
            const SizedBox(height: 8),
            Text('Falha ao carregar recomendações', style: TextStyle(color: c.onSurface, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: c.onSurfaceVariant)),
            const SizedBox(height: 12),
            FilledButton.tonal(onPressed: onRetry, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Column(
      children: List.generate(
        3,
            (_) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 72,
          decoration: BoxDecoration(
            color: base.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}