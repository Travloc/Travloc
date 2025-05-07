import 'package:flutter/material.dart';
import 'package:travloc/features/explore/domain/models/trip_plan.dart';

class ConfirmButton extends StatelessWidget {
  final List<String> selectedLocations;
  final List<String> selectedInterests;
  final String budgetCategory;
  final int adultCount;
  final int childrenCount;
  final Function(TripPlan) onConfirm;

  const ConfirmButton({
    super.key,
    required this.selectedLocations,
    required this.selectedInterests,
    required this.budgetCategory,
    required this.adultCount,
    required this.childrenCount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            selectedLocations.isEmpty
                ? null
                : () {
                  final tripPlan = TripPlan(
                    destination: selectedLocations.join(', '),
                    startDate: DateTime.now(),
                    endDate: DateTime.now().add(const Duration(days: 7)),
                    activities: selectedInterests,
                    accommodations: [], // Will be populated by the trip planner
                    estimatedCost: _getBudgetEstimate(budgetCategory),
                    adultCount: adultCount,
                    childrenCount: childrenCount,
                  );
                  onConfirm(tripPlan);
                },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedLocations.isEmpty
                  ? const Color(0xFFB7E0FF)
                  : const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          minimumSize: const Size.fromHeight(36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Start Planning',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  double _getBudgetEstimate(String category) {
    switch (category) {
      case 'budget':
        return 500.0;
      case 'balanced':
        return 1000.0;
      case 'luxury':
        return 2000.0;
      default:
        return 1000.0;
    }
  }
}
