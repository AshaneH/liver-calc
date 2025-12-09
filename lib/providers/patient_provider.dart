import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:liver_calc/models/patient_data.dart';
import 'package:liver_calc/logic/liver_calculator.dart';

class PatientDataNotifier extends StateNotifier<PatientData> {
  PatientDataNotifier() : super(const PatientData());

  void updateUnits(Units newUnits) {
    if (state.units == newUnits) return;

    // Convert values
    double? newBilirubin = state.bilirubin;
    double? newCreatinine = state.creatinine;
    double? newAlbumin = state.albumin;

    if (state.units == Units.us && newUnits == Units.si) {
      // US -> SI
      if (newBilirubin != null) newBilirubin *= 17.1;
      if (newCreatinine != null) newCreatinine *= 88.4;
      if (newAlbumin != null) newAlbumin *= 10.0; // g/dL -> g/L
    } else if (state.units == Units.si && newUnits == Units.us) {
      // SI -> US
      if (newBilirubin != null) newBilirubin /= 17.1;
      if (newCreatinine != null) newCreatinine /= 88.4;
      if (newAlbumin != null) newAlbumin /= 10.0;
    }

    // Round to reasonable decimals to avoid 1.1999999999
    if (newBilirubin != null) {
      newBilirubin = double.parse(newBilirubin.toStringAsFixed(1));
    }
    if (newCreatinine != null) {
      newCreatinine = double.parse(newCreatinine.toStringAsFixed(1));
    }
    if (newAlbumin != null) {
      newAlbumin = double.parse(newAlbumin.toStringAsFixed(1));
    }

    state = state.copyWith(
      units: newUnits,
      bilirubin: newBilirubin,
      creatinine: newCreatinine,
      albumin: newAlbumin,
    );
  }

  void updateBilirubin(String value) {
    state = state.copyWith(bilirubin: double.tryParse(value));
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
    state = state.copyWith(creatinine: double.tryParse(value));
  }

  void updateSodium(String value) {
    state = state.copyWith(sodium: int.tryParse(value));
  }

  void updateAlbumin(String value) {
    state = state.copyWith(albumin: double.tryParse(value));
  }

  void updateAscites(AscitesSeverity severity) {
    state = state.copyWith(ascites: severity);
  }

  void updateEncephalopathy(EncephalopathyGrade grade) {
    state = state.copyWith(encephalopathy: grade);
  }
}

final patientDataProvider =
    StateNotifierProvider<PatientDataNotifier, PatientData>((ref) {
      return PatientDataNotifier();
    });

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
