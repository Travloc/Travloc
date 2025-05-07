import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/segmented_tab_control.dart';
import 'package:travloc/core/widgets/preference_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static const String _tabStorageKey = 'profile_tab_index';
  late TabController _tabController;
  final List<String> _tabs = ['Account', 'Travel', 'Support'];
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    int initialTab =
        PageStorage.of(context).readState(context, identifier: _tabStorageKey)
            as int? ??
        0;
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: initialTab,
    );
    _tabController.addListener(_handleTabChangeSetState);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging ||
        _tabController.index !=
            (PageStorage.of(
                      context,
                    ).readState(context, identifier: _tabStorageKey)
                    as int? ??
                0)) {
      PageStorage.of(
        context,
      ).writeState(context, _tabController.index, identifier: _tabStorageKey);
    }
  }

  void _handleTabChangeSetState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChangeSetState);
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: PageStorage(
        bucket: _bucket,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                  children: [
                    // Header
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.08 * 255).toInt()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: const Color(0xFFB7A6FF),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'John Doe',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'john.doe@example.com',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F8FA),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(
                                    (0.08 * 255).toInt(),
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                              onPressed: () => context.go('/settings'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Stats/Progress Card (optional, placeholder)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFFF2A),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.08 * 255).toInt()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.black,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Profile Progress',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Complete your profile to unlock more features!',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: const Text(
                              '78%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TabBarView for animated tab switching
                    SizedBox(
                      height: 320, // Adjust height as needed for your cards
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTabSection(context, 0),
                          _buildTabSection(context, 1),
                          _buildTabSection(context, 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SegmentedTabControl(
                    tabs: _tabs,
                    currentIndex: _tabController.index,
                    currentPosition:
                        _tabController.animation?.value ??
                        _tabController.index.toDouble(),
                    onTabSelected: (index) {
                      setState(() {
                        _tabController.index = index;
                        PageStorage.of(context).writeState(
                          context,
                          index,
                          identifier: _tabStorageKey,
                        );
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSection(BuildContext context, int tab) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6, top: 2),
          child: Text(
            _tabs[tab],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        if (tab == 0) ..._buildAccountSection(context),
        if (tab == 1) ..._buildTravelSection(context),
        if (tab == 2) ..._buildSupportSection(context),
      ],
    );
  }

  List<Widget> _buildAccountSection(BuildContext context) {
    return [
      _profileCard(
        context,
        'Personal Information',
        Icons.person_outline,
        () => context.go('/profile/personal-info'),
        color: const Color(0xFFB7A6FF),
      ),
      _profileCard(
        context,
        'Security',
        Icons.security,
        () => context.go('/profile/security'),
        color: const Color(0xFFFFD6E0),
      ),
      _profileCard(
        context,
        'Notifications',
        Icons.notifications_outlined,
        () => context.go('/profile/notifications'),
        color: const Color(0xFFBFFF2A),
      ),
    ];
  }

  List<Widget> _buildTravelSection(BuildContext context) {
    return [
      _profileCard(
        context,
        'My Trips',
        Icons.card_travel,
        () => context.go('/profile/trips'),
        color: const Color(0xFFB7A6FF),
      ),
      _profileCard(
        context,
        'Saved Places',
        Icons.bookmark_border,
        () => context.go('/profile/saved-places'),
        color: const Color(0xFFFFD6E0),
      ),
      _profileCard(
        context,
        'Travel Preferences',
        Icons.settings,
        () => context.go('/profile/preferences'),
        color: const Color(0xFFBFFF2A),
      ),
    ];
  }

  List<Widget> _buildSupportSection(BuildContext context) {
    return [
      _profileCard(
        context,
        'Help Center',
        Icons.help_outline,
        () => context.go('/profile/help'),
        color: const Color(0xFFB7A6FF),
      ),
      _profileCard(
        context,
        'Contact Support',
        Icons.support_agent,
        () => context.go('/profile/support'),
        color: const Color(0xFFFFD6E0),
      ),
      _profileCard(
        context,
        'About',
        Icons.info_outline,
        () => context.go('/profile/about'),
        color: const Color(0xFFBFFF2A),
      ),
    ];
  }

  Widget _profileCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    required Color color,
  }) {
    return PreferenceTile(
      icon: icon,
      title: title,
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      backgroundColor: color,
      iconBackgroundColor: Colors.white,
    );
  }
}
