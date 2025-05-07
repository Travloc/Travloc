import 'package:flutter/material.dart';

class VoiceManualToggle extends StatelessWidget {
  final bool isVoiceMode;
  final ValueChanged<bool> onChanged;

  const VoiceManualToggle({
    super.key,
    required this.isVoiceMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const black = Colors.black;
    const white = Colors.white;
    return Container(
      height: 36,
      width: 148,
      decoration: BoxDecoration(
        border: Border.all(color: black, width: 2),
        borderRadius: BorderRadius.circular(24),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isVoiceMode ? Colors.transparent : black,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Voice',
                  style: TextStyle(
                    color: isVoiceMode ? black : white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: !isVoiceMode ? Colors.transparent : black,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Manual',
                  style: TextStyle(
                    color: !isVoiceMode ? black : white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 