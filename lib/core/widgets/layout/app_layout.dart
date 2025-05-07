import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _AppLayoutState extends ConsumerState<AppLayout>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animationController;
  static const int _pageCount = 5;
  final List<Widget> _pages = const [
    TripPlannerScreen(),
    GuidesScreen(),
    ExploreScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(navigationProvider);
    _pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: 1.0,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (index != ref.read(navigationProvider)) {
      ref.read(navigationProvider.notifier).state = index;
    }
  }

  void _onTabTapped(int index) {
    if (_pageController.hasClients) {
      final currentIndex = ref.read(navigationProvider);
      final isAdjacent = (index - currentIndex).abs() == 1;

      if (isAdjacent) {
        // For adjacent pages, use smooth animation
        _animationController.forward(from: 0);
        _pageController
            .animateToPage(
              index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            )
            .then((_) {
              _animationController.reverse();
            });
      } else {
        // For non-adjacent pages, jump directly
        _pageController.jumpToPage(index);
      }
      ref.read(navigationProvider.notifier).state = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationProvider);
    final currentPath = GoRouterState.of(context).uri.path;

    // Only show the main tab screens for exact matches
    final mainTabPaths = ['/', '/profile', '/settings'];
    if (!mainTabPaths.contains(currentPath)) {
      return RepaintBoundary(
        child: Scaffold(
          body: SafeArea(child: widget.child),
          bottomNavigationBar: TravlocBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: _onTabTapped,
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: Scaffold(
        body: SafeArea(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pageCount,
            physics:
                const NeverScrollableScrollPhysics(), // Disable manual scrolling
            onPageChanged: _onPageChanged,
            itemBuilder:
                (context, index) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    final isAdjacent = (index - currentIndex).abs() == 1;
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(isAdjacent ? 0.05 : 0.1, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve:
                                isAdjacent
                                    ? Curves.easeOutCubic
                                    : Curves.easeInOut,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(index),
                    child: _pages[index],
                  ),
                ),
          ),
        ),
        bottomNavigationBar: TravlocBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
