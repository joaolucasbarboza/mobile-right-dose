import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tcc/utils/custom_text_style.dart';

class MedicationProgress extends StatelessWidget {
  final bool indefinite;
  final int totalOccurrences;
  final int totalConfirmed;
  final int totalPending;

  const MedicationProgress({
    super.key,
    required this.indefinite,
    required this.totalOccurrences,
    required this.totalConfirmed,
    required this.totalPending,
  });

  @override
  Widget build(BuildContext context) {
    if (indefinite) return const SizedBox.shrink(); // não exibe nada

    final denom = totalConfirmed + totalPending;
    final progress = denom > 0 ? totalConfirmed / denom : 0.0;

    return _CardContainer(
      title: 'Progresso da medicação',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  icon: LucideIcons.check,
                  color: Colors.green,
                  label: 'Tomadas',
                  value: '$totalConfirmed',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatChip(
                  icon: LucideIcons.circleDashed,
                  color: Colors.grey,
                  label: 'Faltam',
                  value: '$totalPending',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const _CardContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: customTextLabelPrimary()),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatChip({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Chip(
      side: BorderSide(color: color.withOpacity(0.6)),
      backgroundColor: color.withOpacity(0.1),
      avatar: Icon(icon, color: color, size: 18),
      label: Align(
        alignment: Alignment.center,
        child: Text(
          '$label: $value',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );

    return SizedBox(width: double.infinity, child: chip);
  }
}