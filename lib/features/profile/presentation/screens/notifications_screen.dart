import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationSettingsProvider = StateNotifierProvider<NotificationSettings, Map<String, bool>>((ref) {
  return NotificationSettings();
});

class NotificationSettings extends StateNotifier<Map<String, bool>> {
  NotificationSettings() : super({
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
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Push Notifications'),
            subtitle: const Text('Enable all notifications'),
            value: settings['push']!,
            onChanged: (value) {
              ref.read(notificationSettingsProvider.notifier).toggleSetting('push');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Trip Updates'),
            subtitle: const Text('Get notified about your trips'),
            trailing: Switch(
              value: settings['tripUpdates']!,
              onChanged: (value) {
                ref.read(notificationSettingsProvider.notifier).toggleSetting('tripUpdates');
              },
            ),
          ),
          ListTile(
            title: const Text('Guide Messages'),
            subtitle: const Text('Notifications from your guides'),
            trailing: Switch(
              value: settings['guideMessages']!,
              onChanged: (value) {
                ref.read(notificationSettingsProvider.notifier).toggleSetting('guideMessages');
              },
            ),
          ),
          ListTile(
            title: const Text('Travel Buddy Requests'),
            subtitle: const Text('New travel buddy requests'),
            trailing: Switch(
              value: settings['buddyRequests']!,
              onChanged: (value) {
                ref.read(notificationSettingsProvider.notifier).toggleSetting('buddyRequests');
              },
            ),
          ),
          ListTile(
            title: const Text('Promotions'),
            subtitle: const Text('Special offers and discounts'),
            trailing: Switch(
              value: settings['promotions']!,
              onChanged: (value) {
                ref.read(notificationSettingsProvider.notifier).toggleSetting('promotions');
              },
            ),
          ),
          ListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            trailing: Switch(
              value: settings['email']!,
              onChanged: (value) {
                ref.read(notificationSettingsProvider.notifier).toggleSetting('email');
              },
            ),
          ),
        ],
      ),
    );
  }
} 