import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liver_calc/models/patient_data.dart';
import 'package:liver_calc/logic/liver_calculator.dart';

class PatientDataNotifier extends Notifier<PatientData> {
  @override
  PatientData build() {
    return const PatientData();
  }

  void updateUnits(Units newUnits) {
    if (state.units == newUnits) return;
    // Just update the view unit. The data remains canonical (SI).
    state = state.copyWith(units: newUnits);
  }

  void updateBilirubin(String value) {
    double? val = double.tryParse(value);
    if (val != null && state.units == Units.us) {
      val = val * 17.1; // Mg/dL -> µmol/L
    }
    state = state.copyWith(bilirubinSi: val);
  }

  void updateInr(String value) {
    state = state.copyWith(inr: double.tryParse(value));
  }

  void updatePt(String value) {
    state = state.copyWith(pt: double.tryParse(value));
  }

  void updatePtControl(String value) {
    double? val = double.tryParse(value);
    if (val != null) {
      state = state.copyWith(ptControl: val);
    }
  }

  void updateCreatinine(String value) {
    double? val = double.tryParse(value);
    if (val != null && state.units == Units.us) {
      val = val * 88.4; // Mg/dL -> µmol/L
    }
    state = state.copyWith(creatinineSi: val);
  }

  void updateSodium(String value) {
    state = state.copyWith(sodium: int.tryParse(value));
  }

  void updateAlbumin(String value) {
    double? val = double.tryParse(value);
    if (val != null && state.units == Units.si) {
      // Input is g/L (SI). Store as g/L. No change.
    } else if (val != null && state.units == Units.us) {
      val = val * 10.0; // g/dL -> g/L
    }
    state = state.copyWith(albuminGl: val);
  }

  void updateAscites(AscitesSeverity severity) {
    state = state.copyWith(ascites: severity);
  }

  void updateEncephalopathy(EncephalopathyGrade grade) {
    state = state.copyWith(encephalopathy: grade);
  }
}

final patientDataProvider = NotifierProvider<PatientDataNotifier, PatientData>(
  PatientDataNotifier.new,
);

final meldScoreProvider = Provider<double?>((ref) {
  final data = ref.watch(patientDataProvider);
  return LiverCalculator.calculateMeld(data);
});

final meldNaScoreProvider = Provider<double?>((ref) {
  final data = ref.watch(patientDataProvider);
  return LiverCalculator.calculateMeldNa(data);
});

final childPughScoreProvider = Provider<Map<String, dynamic>?>((ref) {
  final data = ref.watch(patientDataProvider);
  return LiverCalculator.calculateChildPugh(data);
});

final maddreyScoreProvider = Provider<double?>((ref) {
  final data = ref.watch(patientDataProvider);
  return LiverCalculator.calculateMaddreyDf(data);
});

final albiScoreProvider = Provider<Map<String, dynamic>?>((ref) {
  final data = ref.watch(patientDataProvider);
  return LiverCalculator.calculateAlbi(data);
});
