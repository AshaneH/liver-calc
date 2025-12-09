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
      children: [
        // Unit Toggle
        SegmentedButton<Units>(
          segments: const [
            ButtonSegment(
              value: Units.si,
              label: Text('SI Units'),
              icon: Icon(Icons.science),
            ),
            ButtonSegment(
              value: Units.us,
              label: Text('US Units'),
              icon: Icon(Icons.flag),
            ),
          ],
          selected: {patientData.units},
          onSelectionChanged: (Set<Units> newSelection) {
            notifier.updateUnits(newSelection.first);
          },
        ),
        const SizedBox(height: 16),

        // Grid of inputs
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            // Simple responsive logic: 2 columns on wide screens, 1 on narrow
            int crossAxisCount = width > 600 ? 3 : 2;
            // Actually, standard list might be better for mobile form feel?
            // Let's use Wrap or GridView.

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: [
                _buildInput(
                  context: context,
                  label: 'Bilirubin',
                  suffix: isSi ? 'µmol/L' : 'mg/dL',
                  onChanged: notifier.updateBilirubin,
                  width: (width - 20) / 2, // 2 col roughly
                ),
                _buildInput(
                  context: context,
                  label: 'INR',
                  suffix: '',
                  onChanged: notifier.updateInr,
                  width: (width - 20) / 2,
                ),
                _buildInput(
                  context: context,
                  label: 'Albumin',
                  suffix: isSi ? 'g/L' : 'g/dL',
                  onChanged: notifier.updateAlbumin,
                  width: (width - 20) / 2,
                ),
                _buildInput(
                  context: context,
                  label: 'Sodium (Na)',
                  suffix: 'mmol/L',
                  onChanged: notifier.updateSodium,
                  width: (width - 20) / 2,
                  isInteger: true,
                ),
                _buildInput(
                  context: context,
                  label: 'Creatinine',
                  suffix: isSi ? 'µmol/L' : 'mg/dL',
                  onChanged: notifier.updateCreatinine,
                  width: (width - 20) / 2,
                ),
                // Prothrombin Time (PT)
                _buildInput(
                  context: context,
                  label: 'PT',
                  suffix: 'sec',
                  onChanged: notifier.updatePt,
                  width: (width - 20) / 2,
                ),
                // Control PT (Maybe smaller or secondary?)
                _buildInput(
                  context: context,
                  label: 'Control PT',
                  suffix: 'sec',
                  onChanged: notifier.updatePtControl,
                  width: (width - 20) / 2,
                  initialValue: patientData.ptControl.toString(),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        // Semented controls for Child-Pugh
        _buildSegmentedLabel(context, 'Ascites'),
        SegmentedButton<AscitesSeverity>(
          segments: const [
            ButtonSegment(value: AscitesSeverity.none, label: Text('None')),
            ButtonSegment(value: AscitesSeverity.slight, label: Text('Slight')),
            ButtonSegment(
              value: AscitesSeverity.moderate,
              label: Text('Moderate'),
            ),
          ],
          selected: {patientData.ascites},
          onSelectionChanged: (Set<AscitesSeverity> newSelection) {
            notifier.updateAscites(newSelection.first);
          },
        ),

        const SizedBox(height: 16),
        _buildSegmentedLabel(context, 'Encephalopathy'),
        SegmentedButton<EncephalopathyGrade>(
          segments: const [
            ButtonSegment(value: EncephalopathyGrade.none, label: Text('None')),
            ButtonSegment(
              value: EncephalopathyGrade.grade1_2,
              label: Text('Grade 1-2'),
            ),
            ButtonSegment(
              value: EncephalopathyGrade.grade3_4,
              label: Text('Grade 3-4'),
            ),
          ],
          selected: {patientData.encephalopathy},
          onSelectionChanged: (Set<EncephalopathyGrade> newSelection) {
            notifier.updateEncephalopathy(newSelection.first);
          },
        ),
      ],
    );
  }

  Widget _buildInput({
    required BuildContext context,
    required String label,
    required String suffix,
    required Function(String) onChanged,
    required double width,
    bool isInteger = false,
    String? initialValue,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          filled: true,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSegmentedLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label, style: Theme.of(context).textTheme.titleSmall),
      ),
    );
  }
}
