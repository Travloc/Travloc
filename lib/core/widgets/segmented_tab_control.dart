import 'package:flutter/material.dart';

class SegmentedTabControl extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final double? currentPosition;
  final ValueChanged<int> onTabSelected;

  const SegmentedTabControl({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    final double position = currentPosition ?? currentIndex.toDouble();
    return SizedBox(
      height: 44,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181A20),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / tabs.length;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.ease,
                  margin: const EdgeInsets.all(3),
                  width: tabWidth - 6,
                  height: 38,
                  transform: Matrix4.translationValues(
                    position * tabWidth,
                    0,
                    0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7A6FF),
                    borderRadius: BorderRadius.circular(19),
                  ),
                );
              },
            ),
            Row(
              children: List.generate(tabs.length, (index) {
                final bool selected = (position.round() == index);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTabSelected(index),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      height: 38,
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: selected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
