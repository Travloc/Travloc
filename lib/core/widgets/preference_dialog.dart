import 'package:flutter/material.dart';
import 'app_button.dart';

class PreferenceDialog<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selectedOption;
  final String Function(T) optionLabel;
  final void Function(T) onSelected;
  final Color backgroundColor;

  const PreferenceDialog({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.optionLabel,
    required this.onSelected,
    this.backgroundColor = const Color(0xFFF3EDFF),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 18),
            ...options.map(
              (option) => InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  onSelected(option);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        option == selectedOption
                            ? Color.fromARGB((0.7 * 255).toInt(), 255, 255, 255)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        option == selectedOption
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          optionLabel(option),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                text: 'Cancel',
                isOutlined: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
