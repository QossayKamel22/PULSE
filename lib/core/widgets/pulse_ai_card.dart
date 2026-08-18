import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/pulse_colors.dart';
import '../theme/pulse_spacing.dart';

/// PULSE AI visual placeholder. No real AI/LLM backend — static local
/// mock copy only. Kept deliberately subtle: one card, not a screen.
class PulseAiCard extends StatelessWidget {
  const PulseAiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PulseSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PulseColors.pulseBlue.withValues(alpha: 0.10),
            PulseColors.pulseViolet.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(PulseRadius.lg),
        border: Border.all(color: PulseColors.pulseBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(gradient: PulseColors.brandGradient, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          ),
          const SizedBox(width: PulseSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PULSE AI', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 2),
                Text(PulseAiMocks.randomMessage(), style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
