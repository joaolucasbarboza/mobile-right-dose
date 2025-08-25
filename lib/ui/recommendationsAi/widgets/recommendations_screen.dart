import 'package:flutter/material.dart';
import 'package:tcc/utils/custom_text_style.dart';

import '../../../models/meals.dart';

class RecommendationsScreen extends StatelessWidget {
  final Meals meals;
  final List<String> alerts;
  final List<String> substitutions;

  const RecommendationsScreen({
    super.key,
    required this.meals,
    required this.alerts,
    required this.substitutions,
  });

  @override
  Widget build(BuildContext context) {
    final mealRows = <ListTile>[
      if (meals.breakfast.trim().isNotEmpty)
        ListTile(
          leading: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
          title: Text('Café da manhã', style: customTextLabelPrimary()),
          subtitle: Text(meals.breakfast, style: customTextLabel2()),
        ),
      if (meals.lunch.trim().isNotEmpty)
        ListTile(
          leading: const Icon(Icons.lunch_dining_outlined, color: Colors.green),
          title: Text('Almoço', style: customTextLabelPrimary()),
          subtitle: Text(meals.lunch, style: customTextLabel2()),
        ),
      if (meals.dinner.trim().isNotEmpty)
        ListTile(
          leading: const Icon(Icons.dinner_dining_outlined, color: Colors.blueGrey),
          title: Text('Jantar', style: customTextLabelPrimary()),
          subtitle: Text(meals.dinner, style: customTextLabel2()),
        ),
      if (meals.snackMorning.trim().isNotEmpty)
        ListTile(
          leading: const Icon(Icons.free_breakfast_outlined, color: Colors.brown),
          title: Text('Lanche da manhã', style: customTextLabelPrimary()),
          subtitle: Text(meals.snackMorning, style: customTextLabel2()),
        ),
      if (meals.snackAfternoon.trim().isNotEmpty)
        ListTile(
          leading: const Icon(Icons.local_cafe_outlined, color: Colors.teal),
          title: Text('Lanche da tarde', style: customTextLabelPrimary()),
          subtitle: Text(meals.snackAfternoon, style: customTextLabel2()),
        ),
    ];

    final alertRows = alerts
        .map((alert) => ListTile(
              leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
              title: Text(alert, style: customTextLabel2()),
            ))
        .toList();

    final subRows = substitutions
        .map((sub) => ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.blue),
              title: Text(sub, style: customTextLabel2()),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ListView(
          children: [
            // --- Refeições ---
            Text('Refeições recomendadas', style: customTextTitleSecondary()),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mealRows.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) => mealRows[index],
            ),

            const SizedBox(height: 20),

            // --- Alertas ---
            if (alerts.isNotEmpty) ...[
              Text('Alertas', style: customTextTitleSecondary()),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alertRows.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) => alertRows[index],
              ),
              const SizedBox(height: 20),
            ],

            // --- Substituições ---
            if (substitutions.isNotEmpty) ...[
              Text('Substituições sugeridas', style: customTextTitleSecondary()),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subRows.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) => subRows[index],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
