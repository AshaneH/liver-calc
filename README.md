# Liver Calc

**Liver Calc** is a high-precision clinical calculator designed for Hepatology and Transplant Medicine. It implements the latest **OPTN 2023** calculations for liver disease severity, strictly adhering to medical standards for precision, safety, and usability.

---

## ⚕️ Clinical Capabilities

### MELD 3.0 (OPTN 2023 Compliance)
The application implements the official **MELD 3.0** formula effective from July 13, 2023.
- **Strict Compliance**: Adheres to all OPTN policy requirements including gender-based coefficients and interaction terms.
- **Cascading Logic**: Automatically selects the most appropriate formula based on available data:
    1.  **MELD 3.0**: Prioritized if Gender, Sodium, and Albumin are available.
    2.  **MELD-Na**: Fallback if MELD 3.0 prerequisites are unmet but Sodium is available.
    3.  **Standard MELD**: Final fallback.
- **Dialysis Protocols**:
    - **MELD 3.0**: Creatinine is strictly capped at **3.0 mg/dL** (even for dialysis patients).
    - **Standard MELD**: Creatinine is capped at **4.0 mg/dL** or set to 4.0 if on dialysis.

### Additional Prognostic Scores
- **Child-Pugh Score**: Integrating clinical factors (Ascites, Encephalopathy) with lab values.
- **Maddrey's Discriminant Function (DF)**: For assessing alcoholic hepatitis prognosis.
- **ALBI Grade**: For assessing liver function in HCC (Hepatocellular Carcinoma).

---

## 🛡️ Safety & Architecture

### Canonical State Management
To ensure zero precision loss, the application utilizes a **Canonical State Architecture**.
- **Internal Storage**: All lab values are stored primarily in **SI Units** (International System) regardless of user input preference.
- **Display Layer**: Conversions to US/Conventional units occur strictly at the view layer.
- **Benefit**: Eliminates "drift" errors that occur from repeated floating-point conversions, ensuring 100% data integrity during unit toggling.

### Clinical Safety Features
- **Input Clamping**: Automatic enforcement of lower/upper bounds (e.g., Creatinine < 1.0 clamped to 1.0) as per formula definitions.
- **Context-Aware Inputs**: "Sex" and "Dialysis History" fields are explicitly handled for MELD 3.0 accuracy.
- **Rapid Data Entry**: Integrated **Keyboard Toolbar** (Next/Prev/Done) facilitates rapid entry of multiple lab values without view obstruction.

---

## 💻 Technical Specifications

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (v2)
- **Architecture**: Domain-Driven Design (DDD) with Clean Architecture principles.
- **Testing**:
    - **Unit Tests**: Verification of all medical formulas against OPTN test cases.
    - **Widget Tests**: Validation of UI state transitions and unit toggle safety.
    - **Precision Tests**: "Round-Trip" validation to ensure zero floating-point drift.

---

## ⚖️ Disclaimer

**For Medical Professionals Only.**
This application is intended as a clinical decision support tool for healthcare professionals. While rigorous testing has been performed to ensure compliance with OPTN/UNOS formulas, the results should not be the sole basis for medical decisions. Clinical judgment must always supersede calculated scores.

---

**© 2025 Clinicode Labs**
