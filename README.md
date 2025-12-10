# Liver Calc by Clinicode Labs

**Liver Calc** is a precise, professional calculator for Hepatology designed for clinical use. It provides instant calculation of critical liver disease scores (MELD, MELD-Na, Child-Pugh, Maddrey's DF, ALBI) with a focus on usability, accuracy, and robust handling of unit conversions.

---

## 🚀 Features

### Core Calculators
- **MELD & MELD-Na**: Automatic calculation with lower-bound clamping and sodium correction logic (for MELD > 11).
- **Child-Pugh Score**: Clinical factor grading (Ascites, Encephalopathy) alongside lab values.
- **Maddrey's Discriminant Function (DF)**: Prognostic score for alcoholic hepatitis.
- **ALBI Grade**: Assessment of liver function in HCC patients.

### Engineered for Accuracy
- **Canonical State Architecture**: All data is stored internally in **SI Units** (µmol/L, g/L) regardless of user input preference. This prevents precision drift caused by repeated unit toggling.
- **Smart Unit Conversion**: Seamlessly toggle between **SI** (International) and **US** (Conventional) units. Conversions happen on-the-fly for display only.
- **Input Validation**: Robust handling of empty states, zeros, and edge cases.

### UX/UI Design
- **Material 3 Expressive**: Modern, clean interface adhering to the latest Flutter design guidelines.
- **Results-First Layout**: Sticky header displaying scores ensures clinical answers are always visible while editing inputs.
- **Clinicode Branding**: Professional Navy Blue & Teal aesthetic with custom SVG iconography.

---

## 🛠 Tech Stack

- **Flutter**: Framework for cross-platform compiled apps.
- **Riverpod**: Robust state management and dependency injection.
- **Freezed**: Code generation for immutable data classes and unions.
- **Material 3**: Design system components.

## 🏗 Architecture

The project follows a clean, layered architecture:

- **`lib/logic/`**: Pure Dart business logic and calculator algorithms (isolated from UI).
- **`lib/models/`**: Immutable data classes (`PatientData`) using Freezed.
- **`lib/providers/`**: Riverpod notifiers managing app state (`PatientDataNotifier`).
- **`lib/widgets/`**: Reusable UI components.
    - `common/`: Extracted generic widgets (`AppTextField`, `SectionCard`).
    - `input_form.dart`: Main user input interface.
    - `score_dashboard.dart`: Live results display.

## 🧪 Testing

The codebase maintains high test coverage to ensure clinical safety.

### Running Tests
To run the full test suite (logic, UI, and precision stability):

```bash
flutter test
```

### Key Tests
- **`test/logic_test.dart`**: Verifies all medical formulas against known test cases.
- **`test/precision_test.dart`**: Validates the Canonical State logic, ensuring values don't drift after 10+ unit toggles ("Round Trip" test).

---

## 📦 Setup

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/AshaneH/liver-calc.git
    cd liver-calc
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run code generation** (if modifying models):
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

---

**© 2025 Clinicode Labs. All Rights Reserved.**
