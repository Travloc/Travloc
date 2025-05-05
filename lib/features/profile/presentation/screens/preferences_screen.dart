import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final preferencesProvider =
    StateNotifierProvider<PreferencesState, Map<String, dynamic>>((ref) {
      return PreferencesState();
    });

class PreferencesState extends StateNotifier<Map<String, dynamic>> {
  PreferencesState()
    : super({
        'language': 'English',
        'currency': 'USD',
        'distanceUnit': 'km',
        'temperatureUnit': 'Celsius',
        'darkMode': false,
        'notifications': true,
        'locationServices': true,
      });

  void updatePreference(String key, dynamic value) {
    state = {...state, key: value};
  }
}

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);

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
                    'Preferences',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // General Preferences Card
            _preferenceCard(
              context,
              color: const Color(0xFFB7A6FF),
              icon: Icons.settings,
              title: 'General',
              children: [
                _preferenceTile(
                  context,
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: preferences['language'] as String,
                  onTap: () => _showLanguageDialog(context, ref),
                ),
                _preferenceTile(
                  context,
                  icon: Icons.attach_money,
                  title: 'Currency',
                  subtitle: preferences['currency'] as String,
                  onTap: () => _showCurrencyDialog(context, ref),
                ),
              ],
            ),
            // Units Preferences Card
            _preferenceCard(
              context,
              color: const Color(0xFFBFFF2A),
              icon: Icons.straighten,
              title: 'Units',
              children: [
                _preferenceTile(
                  context,
                  icon: Icons.straighten,
                  title: 'Distance Unit',
                  subtitle: preferences['distanceUnit'] as String,
                  onTap: () => _showDistanceUnitDialog(context, ref),
                ),
                _preferenceTile(
                  context,
                  icon: Icons.thermostat,
                  title: 'Temperature Unit',
                  subtitle: preferences['temperatureUnit'] as String,
                  onTap: () => _showTemperatureUnitDialog(context, ref),
                ),
              ],
            ),
            // App Settings Card
            _preferenceCard(
              context,
              color: const Color(0xFFFFD6E0),
              icon: Icons.app_settings_alt,
              title: 'App Settings',
              children: [
                _switchTile(
                  context,
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  value: preferences['darkMode'] as bool,
                  onChanged:
                      (value) => ref
                          .read(preferencesProvider.notifier)
                          .updatePreference('darkMode', value),
                ),
                _switchTile(
                  context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  value: preferences['notifications'] as bool,
                  onChanged:
                      (value) => ref
                          .read(preferencesProvider.notifier)
                          .updatePreference('notifications', value),
                ),
                _switchTile(
                  context,
                  icon: Icons.location_on,
                  title: 'Location Services',
                  value: preferences['locationServices'] as bool,
                  onChanged:
                      (value) => ref
                          .read(preferencesProvider.notifier)
                          .updatePreference('locationServices', value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _preferenceCard(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String title,
    required List<Widget> children,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.black, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _preferenceTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: Colors.transparent,
    );
  }

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.black,
          activeTrackColor: Colors.white,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.black26,
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Italian'];
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  languages.map((language) {
                    return ListTile(
                      title: Text(language),
                      onTap: () {
                        ref
                            .read(preferencesProvider.notifier)
                            .updatePreference('language', language);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showCurrencyDialog(BuildContext context, WidgetRef ref) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD'];
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Currency'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  currencies.map((currency) {
                    return ListTile(
                      title: Text(currency),
                      onTap: () {
                        ref
                            .read(preferencesProvider.notifier)
                            .updatePreference('currency', currency);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showDistanceUnitDialog(BuildContext context, WidgetRef ref) {
    final units = ['km', 'miles'];
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Distance Unit'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  units.map((unit) {
                    return ListTile(
                      title: Text(unit),
                      onTap: () {
                        ref
                            .read(preferencesProvider.notifier)
                            .updatePreference('distanceUnit', unit);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showTemperatureUnitDialog(BuildContext context, WidgetRef ref) {
    final units = ['Celsius', 'Fahrenheit'];
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Temperature Unit'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  units.map((unit) {
                    return ListTile(
                      title: Text(unit),
                      onTap: () {
                        ref
                            .read(preferencesProvider.notifier)
                            .updatePreference('temperatureUnit', unit);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }
}
