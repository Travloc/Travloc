import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/personal_info_screen.dart';
import '../../features/profile/presentation/screens/security_screen.dart';
import '../../features/profile/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/preferences_screen.dart';
import '../../features/profile/presentation/screens/trips_screen.dart';
import '../../features/profile/presentation/screens/saved_places_screen.dart';
import '../../features/profile/presentation/screens/help_center_screen.dart';
import '../../features/profile/presentation/screens/contact_support_screen.dart';
import '../../features/profile/presentation/screens/about_screen.dart';
import '../../core/widgets/layout/app_layout.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'personal-info',
                builder: (context, state) => const PersonalInfoScreen(),
              ),
              GoRoute(
                path: 'security',
                builder: (context, state) => const SecurityScreen(),
              ),
              GoRoute(
                path: 'notifications',
                builder: (context, state) => const NotificationsScreen(),
              ),
              GoRoute(
                path: 'trips',
                builder: (context, state) => const TripsScreen(),
              ),
              GoRoute(
                path: 'saved-places',
                builder: (context, state) => const SavedPlacesScreen(),
              ),
              GoRoute(
                path: 'preferences',
                builder: (context, state) => const PreferencesScreen(),
              ),
              GoRoute(
                path: 'help',
                builder: (context, state) => const HelpCenterScreen(),
              ),
              GoRoute(
                path: 'support',
                builder: (context, state) => const ContactSupportScreen(),
              ),
              GoRoute(
                path: 'about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
      // Auth routes
      GoRoute(
        path: '/auth',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'register',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
