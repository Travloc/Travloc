import 'package:flutter/material.dart';

class TravlocBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TravlocBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected(int idx) => currentIndex == idx;
    const purple = Color(0xFFB7A6FF);
    return SafeArea(
      top: false,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 76,
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF181A20),
              borderRadius: BorderRadius.zero,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.18 * 255).toInt()),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavBarIcon(
                        icon: Icons.calendar_today_outlined,
                        selected: isSelected(1),
                        onTap: () => onTap(1),
                        highlightColor: purple,
                      ),
                      _NavBarIcon(
                        icon: Icons.menu_book_outlined,
                        selected: isSelected(2),
                        onTap: () => onTap(2),
                        highlightColor: purple,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 64),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavBarIcon(
                        icon: Icons.chat_bubble_outline,
                        selected: isSelected(3),
                        onTap: () => onTap(3),
                        highlightColor: purple,
                      ),
                      _NavBarIcon(
                        icon: Icons.settings_outlined,
                        selected: isSelected(4),
                        onTap: () => onTap(4),
                        highlightColor: purple,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected(0) ? purple : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.10 * 255).toInt()),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.explore,
                  size: 32,
                  color: isSelected(0) ? const Color(0xFF181A20) : purple,
                ),
                onPressed: () => onTap(0),
                padding: const EdgeInsets.all(12),
                constraints: BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color highlightColor;

  const _NavBarIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration:
              selected
                  ? BoxDecoration(
                    color: highlightColor.withAlpha((0.18 * 255).toInt()),
                    shape: BoxShape.circle,
                  )
                  : null,
          child: Icon(
            icon,
            size: 26,
            color: selected ? highlightColor : Colors.white70,
          ),
        ),
      ),
    );
  }
}
