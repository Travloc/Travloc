import 'package:flutter/material.dart';

class BudgetSelection extends StatelessWidget {
  final String selectedBudget;
  final Function(String) onBudgetChanged;

  const BudgetSelection({
    super.key,
    required this.selectedBudget,
    required this.onBudgetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> budgetOptions = [
      {'label': 'Extreme Saver', 'value': 'extreme', 'icon': Icons.money_off},
      {'label': 'Budget', 'value': 'budget', 'icon': Icons.attach_money},
      {'label': 'Value', 'value': 'value', 'icon': Icons.local_offer},
      {'label': 'Balanced', 'value': 'balanced', 'icon': Icons.balance},
      {'label': 'Premium', 'value': 'premium', 'icon': Icons.diamond},
      {'label': 'Luxury', 'value': 'luxury', 'icon': Icons.emoji_events},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Budget',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              budgetOptions.map((option) {
                return ChoiceChip(
                  avatar: Icon(
                    option['icon'] as IconData,
                    color:
                        selectedBudget == option['value']
                            ? Colors.white
                            : Colors.black54,
                    size: 18,
                  ),
                  label: Text(option['label']!),
                  selected: selectedBudget == option['value'],
                  onSelected: (_) => onBudgetChanged(option['value']!),
                  selectedColor: const Color(0xFF2196F3),
                  labelStyle: TextStyle(
                    color:
                        selectedBudget == option['value']
                            ? Colors.white
                            : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color:
                          selectedBudget == option['value']
                              ? const Color(0xFF2196F3)
                              : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
