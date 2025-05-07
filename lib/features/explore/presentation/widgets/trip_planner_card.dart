import 'package:flutter/material.dart';
import 'package:travloc/core/widgets/segmented_tab_control.dart';
import 'package:travloc/features/explore/presentation/widgets/voice_input_section.dart';
import 'package:travloc/features/explore/presentation/widgets/manual_input_section.dart';

class TripPlannerCard extends StatefulWidget {
  const TripPlannerCard({super.key});

  @override
  State<TripPlannerCard> createState() => _TripPlannerCardState();
}

class _TripPlannerCardState extends State<TripPlannerCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  int _selectedTabIndex = 0;
  late AnimationController _controller;
  late Animation<double> _contentAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _contentAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );
    _rotationAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutQuart,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF181A20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trip Planner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value * 3.14159,
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      onPressed: _toggleExpanded,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SegmentedTabControl(
                  tabs: const ['Voice', 'Manual'],
                  currentIndex: _selectedTabIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _contentAnimation,
            axisAlignment: -1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child:
                  _selectedTabIndex == 0
                      ? const VoiceInputSection()
                      : const ManualInputSection(),
            ),
          ),
        ],
      ),
    );
  }
}
