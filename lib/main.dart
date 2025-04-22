import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi-Disease Predictor',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const PredictorPage(),
    );
  }
}

class PredictorPage extends StatefulWidget {
  const PredictorPage({super.key});

  @override
  State<PredictorPage> createState() => _PredictorPageState();
}

class _PredictorPageState extends State<PredictorPage> {
  final List<String> featureNames = [
    'Glucose', 'Cholesterol', 'Hemoglobin', 'Platelets', 'White Blood Cells',
    'Red Blood Cells', 'Hematocrit', 'Mean Corpuscular Volume',
    'Mean Corpuscular Hemoglobin', 'Mean Corpuscular Hemoglobin Concentration',
    'Insulin', 'BMI', 'Systolic Blood Pressure', 'Diastolic Blood Pressure',
    'Triglycerides', 'HbA1c', 'LDL Cholesterol', 'HDL Cholesterol',
    'ALT', 'AST', 'Heart Rate', 'Creatinine', 'Troponin',
    'C-reactive Protein'
  ];

  final List<TextEditingController> controllers = List.generate(
    24,
    (index) => TextEditingController(),
  );

  void simulatePrediction() {
    List<double> inputs = controllers.map((c) => double.tryParse(c.text) ?? 0.0).toList();
    double sum = inputs.fold(0.0, (a, b) => a + b);

    String result;
    if (sum > 1500) {
      result = '🩺 High Risk: Please consult a doctor.';
    } else if (sum > 800) {
      result = '⚠️ Moderate Risk: Monitor your health.';
    } else {
      result = '✅ Low Risk: You seem healthy.';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Prediction Result'),
        content: Text(result, style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columns = screenWidth > 900 ? 4 : 2;
    double itemWidth = screenWidth / columns - 24;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D2671), Color(0xFFC33764)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '🧬 Multi-Disease Predictor',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(controllers.length, (index) {
                        return GlassmorphicContainer(
                          width: itemWidth,
                          height: 90,
                          borderRadius: 20,
                          blur: 15,
                          alignment: Alignment.bottomCenter,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: controllers[index],
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: featureNames[index],
                                labelStyle: const TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.medical_services, color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: simulatePrediction,
                    icon: const Icon(Icons.health_and_safety),
                    label: const Text('Predict Disease'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
