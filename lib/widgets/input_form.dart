import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liver_calc/models/patient_data.dart';
import 'package:liver_calc/providers/patient_provider.dart';

class InputForm extends ConsumerWidget {
  const InputForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientData = ref.watch(patientDataProvider);
    final notifier = ref.read(patientDataProvider.notifier);
    final isSi = patientData.units == Units.si;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Unit Toggle - Prominent at the top
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('SI'),
                  selected: isSi,
                  onSelected: (selected) {
                    if (selected) notifier.updateUnits(Units.si);
                  },
                ),
                ChoiceChip(
                  label: const Text('US'),
                  selected: !isSi,
                  onSelected: (selected) {
                    if (selected) notifier.updateUnits(Units.us);
                  },
                ),
              ],
            ),
          ),
        ),

        // Labs Section
        _buildSectionCard(
          context: context,
          title: 'Labs',
          icon: Icons.biotech,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              // Safeguard
              if (width <= 0 || width.isInfinite)
                return const SizedBox.shrink();

              // Flexible Grid Logic
              // Min item width ~150px.
              int cols = (width / 160).floor();
              if (cols < 2) cols = 2; // Keep at least 2 cols usually

              double spacing = 12.0;
              // Formula: (TotalWidth - (SpacerCount * SpacerWidth)) / ColCount
              double itemWidth = (width - ((cols - 1) * spacing)) / cols;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _buildInput(
                    label: 'Bilirubin',
                    suffix: isSi ? 'µmol/L' : 'mg/dL',
                    onChanged: notifier.updateBilirubin,
                    width: itemWidth,
                    initialValue: patientData.bilirubin?.toString(),
                    isLast: false,
                  ),
                  _buildInput(
                    label: 'INR',
                    suffix: '',
                    onChanged: notifier.updateInr,
                    width: itemWidth,
                    initialValue: patientData.inr?.toString(),
                    isLast: false,
                  ),
                  _buildInput(
                    label: 'Albumin',
                    suffix: isSi ? 'g/L' : 'g/dL',
                    onChanged: notifier.updateAlbumin,
                    width: itemWidth,
                    initialValue: patientData.albumin?.toString(),
                    isLast: false,
                  ),
                  _buildInput(
                    label: 'Sodium (Na)',
                    suffix: 'mmol/L',
                    onChanged: notifier.updateSodium,
                    width: itemWidth,
                    isInteger: true,
                    initialValue: patientData.sodium?.toString(),
                    isLast: false,
                  ),
                  _buildInput(
                    label: 'Creatinine',
                    suffix: isSi ? 'µmol/L' : 'mg/dL',
                    onChanged: notifier.updateCreatinine,
                    width: itemWidth,
                    initialValue: patientData.creatinine?.toString(),
                    isLast: false,
                  ),
                  _buildInput(
                    label: 'PT',
                    suffix: 'sec',
                    onChanged: notifier.updatePt,
                    width: itemWidth,
                    initialValue: patientData.pt?.toString(),
                    isLast: false,
                  ),
                  _buildInput(
                    label: 'Control PT',
                    suffix: 'sec',
                    onChanged: notifier.updatePtControl,
                    width: itemWidth,
                    initialValue: patientData.ptControl.toString(),
                    isLast: true,
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Clinical Factors Section
        _buildSectionCard(
          context: context,
          title: 'Clinical Factors',
          icon: Icons.person_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(context, 'Ascites'),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: AscitesSeverity.values.map((severity) {
                  return ChoiceChip(
                    label: Text(
                      severity.name[0].toUpperCase() +
                          severity.name.substring(1),
                    ), // Capitalize
                    selected: patientData.ascites == severity,
                    onSelected: (selected) {
                      if (selected) notifier.updateAscites(severity);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _buildLabel(context, 'Encephalopathy'),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildEncephChip(
                    notifier,
                    patientData,
                    EncephalopathyGrade.none,
                    'None',
                  ),
                  _buildEncephChip(
                    notifier,
                    patientData,
                    EncephalopathyGrade.grade1_2,
                    '1-2',
                  ),
                  _buildEncephChip(
                    notifier,
                    patientData,
                    EncephalopathyGrade.grade3_4,
                    '3-4',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEncephChip(
    PatientDataNotifier notifier,
    PatientData data,
    EncephalopathyGrade grade,
    String label,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: data.encephalopathy == grade,
      onSelected: (selected) {
        if (selected) notifier.updateEncephalopathy(grade);
      },
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 0, // Flat card logic for cleaner look, or slight elevation
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String suffix,
    required Function(String) onChanged,
    required double width,
    bool isInteger = false,
    String? initialValue,
    required bool isLast,
  }) {
    return SizedBox(
      width: width,
      key: ValueKey("${label}_$suffix"),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
        textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
