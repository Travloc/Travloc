import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john.doe@example.com',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Profile Sections
            _buildSection(context, 'Account', [
              _buildListTile(
                context,
                'Personal Information',
                Icons.person_outline,
                () => context.go('/profile/personal-info'),
              ),
              _buildListTile(
                context,
                'Security',
                Icons.security,
                () => context.go('/profile/security'),
              ),
              _buildListTile(
                context,
                'Notifications',
                Icons.notifications_outlined,
                () => context.go('/profile/notifications'),
              ),
            ]),
            _buildSection(context, 'Travel', [
              _buildListTile(
                context,
                'My Trips',
                Icons.card_travel,
                () => context.go('/profile/trips'),
              ),
              _buildListTile(
                context,
                'Saved Places',
                Icons.bookmark_border,
                () => context.go('/profile/saved-places'),
              ),
              _buildListTile(
                context,
                'Travel Preferences',
                Icons.settings,
                () => context.go('/profile/preferences'),
              ),
            ]),
            _buildSection(context, 'Support', [
              _buildListTile(
                context,
                'Help Center',
                Icons.help_outline,
                () => context.go('/profile/help'),
              ),
              _buildListTile(
                context,
                'Contact Support',
                Icons.support_agent,
                () => context.go('/profile/support'),
              ),
              _buildListTile(
                context,
                'About',
                Icons.info_outline,
                () => context.go('/profile/about'),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
