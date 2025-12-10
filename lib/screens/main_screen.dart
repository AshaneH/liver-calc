import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liver_calc/widgets/input_form.dart';
import 'package:liver_calc/widgets/score_dashboard.dart';

import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liver Calc',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF152549), // Explicit header color
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Logo as Settings Button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                // Settings action (Unit toggle is already in inputs, maybe this is for future use?)
                // For now just a placeholder or show a dialog/snack
              },
              borderRadius: BorderRadius.circular(12),
              child: SvgPicture.asset(
                'asset/logo_appicon_square.svg',
                height: 44,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          children: [
            // Artistic "Knockout" Watermark
            Positioned(
              bottom: -100,
              right: -50,
              child: Opacity(
                opacity: 0.05, // Very subtle
                child: Transform.rotate(
                  angle: -0.2, // Jaunty angle
                  child: SvgPicture.asset(
                    'asset/logo_icon.svg',
                    height: 400, // Large
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ), // Greyscale
                  ),
                ),
              ),
            ),

            // Main Content
            Column(
              children: [
                const ScoreDashboard(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: const [
                        InputForm(),
                        SizedBox(
                          height: 100,
                        ), // Space for scrolling past bottom
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
