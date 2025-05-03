import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../navigation/navigation_provider.dart';
import '../navigation/bottom_navigation_bar.dart';
import '../../../features/explore/presentation/screens/explore_screen.dart';
import '../../../features/trip_planner/presentation/screens/trip_planner_screen.dart';

class AppLayout extends ConsumerStatefulWidget {
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationProvider);

    Widget getScreen(int index) {
      switch (index) {
        case 0:
          return const ExploreScreen();
        case 1:
          return const TripPlannerScreen();
        case 2:
          return const Center(child: Text('Guides Screen'));
        case 3:
          return const Center(child: Text('Messages Screen'));
        case 4:
          return const Center(child: Text('Profile Screen'));
        default:
          return const ExploreScreen();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: getScreen(currentIndex),
      ),
      bottomNavigationBar: TravlocBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).state = index;
        },
      ),
    );
  }
} 