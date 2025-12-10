import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:liver_calc/models/patient_data.dart';
import 'package:liver_calc/providers/patient_provider.dart';
import 'package:liver_calc/widgets/common/app_text_field.dart';
import 'package:liver_calc/widgets/common/section_card.dart';

class InputForm extends ConsumerStatefulWidget {
  const InputForm({super.key});

  @override
  ConsumerState<InputForm> createState() => _InputFormState();
}

class _InputFormState extends ConsumerState<InputForm> {
  final _nodeBili = FocusNode();
  final _nodeInr = FocusNode();
  final _nodeAlb = FocusNode();
  final _nodeNa = FocusNode();
  final _nodeCreat = FocusNode();
  final _nodePt = FocusNode();
  final _nodePtControl = FocusNode();

  @override
  void dispose() {
    _nodeBili.dispose();
    _nodeInr.dispose();
    _nodeAlb.dispose();
    _nodeNa.dispose();
    _nodeCreat.dispose();
    _nodePt.dispose();
    _nodePtControl.dispose();
    super.dispose();
  }

  /// Configures the keyboard toolbar actions
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: _nodeBili),
        KeyboardActionsItem(focusNode: _nodeInr),
        KeyboardActionsItem(focusNode: _nodeAlb),
        KeyboardActionsItem(focusNode: _nodeNa),
        KeyboardActionsItem(focusNode: _nodeCreat),
        KeyboardActionsItem(focusNode: _nodePt),
        KeyboardActionsItem(focusNode: _nodePtControl),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final patientData = ref.watch(patientDataProvider);
    final notifier = ref.read(patientDataProvider.notifier);
    final isSi = patientData.units == Units.si;

    return KeyboardActions(
      config: _buildConfig(context),
      disableScroll:
          true, // We handle scrolling via SingleChildScrollView in parent
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Unit Toggle & Prompt
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enter Patient Data',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const SizedBox(
                        width: 50,
                        child: Center(child: Text('SI')),
                      ),
                      selected: isSi,
                      onSelected: (selected) {
                        if (selected) notifier.updateUnits(Units.si);
                      },
                    ),
                    ChoiceChip(
                      label: const SizedBox(
                        width: 50,
                        child: Center(child: Text('US')),
                      ),
                      selected: !isSi,
                      onSelected: (selected) {
                        if (selected) notifier.updateUnits(Units.us);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Labs Section
          SectionCard(
            title: 'Labs',
            icon: Icons.biotech,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                if (width <= 0 || width.isInfinite) {
                  return const SizedBox.shrink();
                }

                int cols = (width / 160).floor();
                if (cols < 2) cols = 2;

                double spacing = 12.0;
                double itemWidth = (width - ((cols - 1) * spacing)) / cols;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    AppTextField(
                      label: 'Bilirubin',
                      suffix: isSi ? 'µmol/L' : 'mg/dL',
                      onChanged: notifier.updateBilirubin,
                      width: itemWidth,
                      initialValue: patientData.bilirubinDisplay?.toString(),
                      isLast: false,
                      focusNode: _nodeBili,
                    ),
                    AppTextField(
                      label: 'INR',
                      suffix: '',
                      onChanged: notifier.updateInr,
                      width: itemWidth,
                      initialValue: patientData.inr?.toString(),
                      isLast: false,
                      focusNode: _nodeInr,
                    ),
                    AppTextField(
                      label: 'Albumin',
                      suffix: isSi ? 'g/L' : 'g/dL',
                      onChanged: notifier.updateAlbumin,
                      width: itemWidth,
                      initialValue: patientData.albuminDisplay?.toString(),
                      isLast: false,
                      focusNode: _nodeAlb,
                    ),
                    AppTextField(
                      label: 'Sodium (Na)',
                      suffix: 'mmol/L',
                      onChanged: notifier.updateSodium,
                      width: itemWidth,
                      isInteger: true,
                      initialValue: patientData.sodium?.toString(),
                      isLast: false,
                      focusNode: _nodeNa,
                    ),
                    AppTextField(
                      label: 'Creatinine',
                      suffix: isSi ? 'µmol/L' : 'mg/dL',
                      onChanged: notifier.updateCreatinine,
                      width: itemWidth,
                      initialValue: patientData.creatinineDisplay?.toString(),
                      isLast: false,
                      focusNode: _nodeCreat,
                    ),
                    AppTextField(
                      label: 'PT',
                      suffix: 'sec',
                      onChanged: notifier.updatePt,
                      width: itemWidth,
                      initialValue: patientData.pt?.toString(),
                      isLast: false,
                      focusNode: _nodePt,
                    ),
                    AppTextField(
                      label: 'Control PT',
                      suffix: 'sec',
                      onChanged: notifier.updatePtControl,
                      width: itemWidth,
                      initialValue: patientData.ptControl.toString(),
                      isLast: true,
                      focusNode: _nodePtControl,
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Clinical Factors Section
          SectionCard(
            title: 'Clinical Factors',
            icon: Icons.person_outline,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel(context, 'Sex (Required for MELD 3.0)'),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(
                      label: const Text('Male'),
                      selected: patientData.sex == Gender.male,
                      onSelected: (selected) {
                        if (selected) notifier.updateSex(Gender.male);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Female'),
                      selected: patientData.sex == Gender.female,
                      onSelected: (selected) {
                        if (selected) notifier.updateSex(Gender.female);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildLabel(
                        context,
                        'Dialysis History\n(Twice in past week or 24h CVVHD)',
                      ),
                    ),
                    Switch(
                      value: patientData.onDialysis,
                      onChanged: notifier.updateDialysis,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildLabel(context, 'Ascites'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: AscitesSeverity.values.map((severity) {
                    return ChoiceChip(
                      label: Text(
                        severity.name[0].toUpperCase() +
                            severity.name.substring(1),
                      ),
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
      ),
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
}
