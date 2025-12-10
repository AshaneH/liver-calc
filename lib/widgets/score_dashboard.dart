import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liver_calc/providers/patient_provider.dart';
import 'package:liver_calc/logic/liver_calculator.dart';

class ScoreDashboard extends ConsumerWidget {
  const ScoreDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all scores
    final meldResult = ref.watch(meldResultProvider);
    final childPugh = ref.watch(childPughScoreProvider);
    final maddrey = ref.watch(maddreyScoreProvider);
    final albi = ref.watch(albiScoreProvider);

    String meldSubtitle = '';
    if (meldResult.type == MeldType.meld3) {
      meldSubtitle = 'MELD 3.0';
    } else if (meldResult.type == MeldType.meldNa) {
      meldSubtitle = 'MELD-Na';
    } else if (meldResult.type == MeldType.meld) {
      meldSubtitle = 'Standard MELD';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Results',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildScoreCard(
            context,
            'MELD Score',
            meldResult.score?.toStringAsFixed(1) ?? '--',
            _getMeldColor(meldResult.score),
            subtitle: meldResult.score != null ? meldSubtitle : null,
          ),
          _buildScoreCard(
            context,
            'Child-Pugh',
            childPugh != null
                ? '${childPugh['score']} (Class ${childPugh['grade']})'
                : '--',
            _getChildPughColor(childPugh?['score']),
          ),
          _buildScoreCard(
            context,
            "Maddrey's DF",
            maddrey?.toStringAsFixed(1) ?? '--',
            _getMaddreyColor(maddrey),
            subtitle: (maddrey != null && maddrey > 32)
                ? 'Poor Prognosis (>32)'
                : null,
          ),
          _buildScoreCard(
            context,
            'ALBI Grade',
            albi != null ? 'Grade ${albi['grade']}' : '--',
            _getAlbiColor(albi?['grade']),
            subtitle: albi != null ? 'Score: ${albi['score']}' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context,
    String title,
    String value,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Color Logics
  Color _getMeldColor(double? score) {
    if (score == null) return Colors.grey;
    if (score < 10) return Colors.green;
    if (score < 20) return Colors.orange;
    return Colors.red;
  }

  Color _getChildPughColor(int? score) {
    if (score == null) return Colors.grey;
    if (score <= 6) return Colors.green; // Class A
    if (score <= 9) return Colors.orange; // Class B
    return Colors.red; // Class C
  }

  Color _getMaddreyColor(double? score) {
    if (score == null) return Colors.grey;
    if (score < 32) return Colors.green;
    return Colors.red;
  }

  Color _getAlbiColor(String? grade) {
    if (grade == '1') return Colors.green;
    if (grade == '2') return Colors.orange;
    if (grade == '3') return Colors.red;
    return Colors.grey;
  }
}
