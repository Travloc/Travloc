import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../navigation/navigation_provider.dart';
import '../navigation/bottom_navigation_bar.dart';
import '../../../features/explore/presentation/screens/explore_screen.dart';
import '../../../features/trip_planner/presentation/screens/trip_planner_screen.dart';
import '../../../features/guides/presentation/screens/guides_screen.dart';
import '../../../features/messages/presentation/screens/messages_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends ConsumerStatefulWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  late final PageController _pageController;
  static const int _pageCount = 5;

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(navigationProvider);
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationProvider);
    final currentPath = GoRouterState.of(context).uri.path;

    // Only show the main tab screens for exact matches
    final mainTabPaths = ['/', '/profile', '/settings'];
    if (!mainTabPaths.contains(currentPath)) {
      return Scaffold(
        body: SafeArea(child: widget.child),
        bottomNavigationBar: TravlocBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(navigationProvider.notifier).state = index;
          },
        ),
      );
    }

    // For main routes, show the corresponding screen
    Widget getScreen(int index) {
      switch (index) {
        case 0:
          return const TripPlannerScreen();
        case 1:
          return const GuidesScreen();
        case 2:
          return const ExploreScreen();
        case 3:
          return const MessagesScreen();
        case 4:
          return const ProfileScreen();
        default:
          return const ExploreScreen();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: _pageCount,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            if (index != currentIndex) {
              ref.read(navigationProvider.notifier).state = index;
            }
          },
          itemBuilder: (context, index) => getScreen(index),
        ),
      ),
      bottomNavigationBar: TravlocBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }
          ref.read(navigationProvider.notifier).state = index;
        },
      ),
    );
  }
}
