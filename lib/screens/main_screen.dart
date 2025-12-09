import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liver_calc/widgets/input_form.dart';
import 'package:liver_calc/widgets/score_dashboard.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liver Calc',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Unit toggle will go here
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const InputForm(),
                    const SizedBox(
                      height: 100,
                    ), // Space for bottom sheet or scroll
                  ],
                ),
              ),
            ),
            const ScoreDashboard(),
          ],
        ),
      ),
    );
  }
}
