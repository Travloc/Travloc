import 'package:flutter/material.dart';

class GroupSizeSelection extends StatelessWidget {
  final int adultCount;
  final int childrenCount;
  final Function(int) onAdultCountChanged;
  final Function(int) onChildrenCountChanged;

  const GroupSizeSelection({
    super.key,
    required this.adultCount,
    required this.childrenCount,
    required this.onAdultCountChanged,
    required this.onChildrenCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Group Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildCounter(
                label: 'Adults',
                count: adultCount,
                onIncrement: () => onAdultCountChanged(adultCount + 1),
                onDecrement:
                    () =>
                        adultCount > 1
                            ? onAdultCountChanged(adultCount - 1)
                            : null,
                icon: Icons.person,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCounter(
                label: 'Children',
                count: childrenCount,
                onIncrement: () => onChildrenCountChanged(childrenCount + 1),
                onDecrement:
                    () =>
                        childrenCount > 0
                            ? onChildrenCountChanged(childrenCount - 1)
                            : null,
                icon: Icons.child_care,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.group, color: Color(0xFF2196F3), size: 18),
              const SizedBox(width: 6),
              Text(
                'Total: ${adultCount + childrenCount} ${adultCount + childrenCount == 1 ? 'person' : 'people'}',
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounter({
    required String label,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback? onDecrement,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black54, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color:
                    onDecrement == null ? Colors.grey : const Color(0xFF2196F3),
                onPressed: onDecrement,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 24,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF2196F3),
                onPressed: onIncrement,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
