import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettings, Map<String, bool>>((ref) {
      return NotificationSettings();
    });

class NotificationSettings extends StateNotifier<Map<String, bool>> {
  NotificationSettings()
    : super({
        'push': true,
        'tripUpdates': true,
        'guideMessages': true,
        'buddyRequests': true,
        'promotions': false,
        'email': true,
      });

  void toggleSetting(String key) {
    state = {...state, key: !state[key]!};
  }
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
          children: [
            // Custom header
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Push Notifications Card
            _notificationCard(
              context,
              icon: Icons.notifications,
              color: const Color(0xFFB7A6FF),
              title: 'Push Notifications',
              subtitle: 'Enable all notifications',
              switchValue: settings['push']!,
              onChanged:
                  (value) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggleSetting('push'),
            ),
            _notificationCard(
              context,
              icon: Icons.update,
              color: const Color(0xFFBFFF2A),
              title: 'Trip Updates',
              subtitle: 'Get notified about your trips',
              switchValue: settings['tripUpdates']!,
              onChanged:
                  (value) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggleSetting('tripUpdates'),
            ),
            _notificationCard(
              context,
              icon: Icons.message,
              color: const Color(0xFFFFD6E0),
              title: 'Guide Messages',
              subtitle: 'Notifications from your guides',
              switchValue: settings['guideMessages']!,
              onChanged:
                  (value) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggleSetting('guideMessages'),
            ),
            _notificationCard(
              context,
              icon: Icons.group,
              color: const Color(0xFFB7A6FF),
              title: 'Travel Buddy Requests',
              subtitle: 'New travel buddy requests',
              switchValue: settings['buddyRequests']!,
              onChanged:
                  (value) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggleSetting('buddyRequests'),
            ),
            _notificationCard(
              context,
              icon: Icons.local_offer,
              color: const Color(0xFFBFFF2A),
              title: 'Promotions',
              subtitle: 'Special offers and discounts',
              switchValue: settings['promotions']!,
              onChanged:
                  (value) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggleSetting('promotions'),
            ),
            _notificationCard(
              context,
              icon: Icons.email,
              color: const Color(0xFFFFD6E0),
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              switchValue: settings['email']!,
              onChanged:
                  (value) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggleSetting('email'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool switchValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.black, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: switchValue,
            onChanged: onChanged,
            activeColor: Colors.black,
            activeTrackColor: Colors.white,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black26,
          ),
        ],
      ),
    );
  }
}
