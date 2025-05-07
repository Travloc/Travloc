import 'package:flutter/material.dart';
import 'package:travloc/core/widgets/app_button.dart';

/// Shared Search Bar Widget
class SharedSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String) onChanged;
  final Color backgroundColor;
  final Color iconColor;
  final double borderRadius;

  const SharedSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black54,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search, color: iconColor),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
      onChanged: onChanged,
    );
  }
}

/// Shared Filter Dialog Widget
class SharedFilterDialog extends StatelessWidget {
  final String title;
  final List<Widget> filterOptions;
  final VoidCallback onApply;
  final VoidCallback? onCancel;

  const SharedFilterDialog({
    super.key,
    required this.title,
    required this.filterOptions,
    required this.onApply,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF3EDFF),
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
            ...filterOptions,
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: 'Cancel',
                  isOutlined: true,
                  onPressed: onCancel ?? () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                AppButton(text: 'Apply', onPressed: onApply),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
