import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const StepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bar
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isEven) {
              // Step circle
              final stepIndex = index ~/ 2;
              final isActive = stepIndex <= currentStep;
              final isCurrent = stepIndex == currentStep;

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? ThemeConfig.primaryColor : Colors.grey[300],
                  border: isCurrent
                      ? Border.all(color: ThemeConfig.primaryColor, width: 3)
                      : null,
                ),
                child: Center(
                  child: isActive
                      ? (stepIndex < currentStep
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : Text(
                              '${stepIndex + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ))
                      : Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              );
            } else {
              // Connector line
              final stepIndex = (index - 1) ~/ 2;
              final isActive = stepIndex < currentStep;

              return Expanded(
                child: Container(
                  height: 2,
                  color: isActive ? ThemeConfig.primaryColor : Colors.grey[300],
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 12),

        // Step titles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Text(
                stepTitles[index],
                textAlign: TextAlign.center,
                style: ThemeConfig.bodySmall.copyWith(
                  color: isActive
                      ? (isCurrent ? ThemeConfig.primaryColor : Colors.grey[800])
                      : Colors.grey[500],
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
