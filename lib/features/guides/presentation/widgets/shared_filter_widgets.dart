import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: filterOptions),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: onApply, child: const Text('Apply')),
      ],
    );
  }
}
