import 'package:flutter/material.dart';

class ManualInputSection extends StatelessWidget {
  const ManualInputSection({super.key});

  static const _inputDecoration = InputDecoration(
    filled: true,
    fillColor: Color(0x0DFFFFFF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
  );

  static const _textStyle = TextStyle(color: Colors.white);
  static const _hintStyle = TextStyle(color: Color(0x80FFFFFF));

  static final _destinationDecoration = _inputDecoration.copyWith(
    hintText: 'Enter your destination',
    hintStyle: _hintStyle,
    prefixIcon: const Icon(Icons.search, color: Colors.white),
  );

  static final _startPointDecoration = _inputDecoration.copyWith(
    hintText: 'Enter your starting point',
    hintStyle: _hintStyle,
    prefixIcon: const Icon(Icons.location_on, color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(style: _textStyle, decoration: _destinationDecoration),
          const SizedBox(height: 12),
          TextField(style: _textStyle, decoration: _startPointDecoration),
        ],
      ),
    );
  }
}
