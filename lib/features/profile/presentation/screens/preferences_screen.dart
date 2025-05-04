import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final preferencesProvider = StateNotifierProvider<PreferencesState, Map<String, dynamic>>((ref) {
  return PreferencesState();
});

class PreferencesState extends StateNotifier<Map<String, dynamic>> {
  PreferencesState() : super({
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
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'General',
            [
              _buildLanguagePreference(context, ref, preferences),
              _buildCurrencyPreference(context, ref, preferences),
            ],
          ),
          _buildSection(
            context,
            'Units',
            [
              _buildDistanceUnitPreference(context, ref, preferences),
              _buildTemperatureUnitPreference(context, ref, preferences),
            ],
          ),
          _buildSection(
            context,
            'App Settings',
            [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: preferences['darkMode'] as bool,
                onChanged: (value) {
                  ref.read(preferencesProvider.notifier).updatePreference('darkMode', value);
                },
              ),
              SwitchListTile(
                title: const Text('Notifications'),
                value: preferences['notifications'] as bool,
                onChanged: (value) {
                  ref.read(preferencesProvider.notifier).updatePreference('notifications', value);
                },
              ),
              SwitchListTile(
                title: const Text('Location Services'),
                value: preferences['locationServices'] as bool,
                onChanged: (value) {
                  ref.read(preferencesProvider.notifier).updatePreference('locationServices', value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildLanguagePreference(BuildContext context, WidgetRef ref, Map<String, dynamic> preferences) {
    return ListTile(
      title: const Text('Language'),
      subtitle: Text(preferences['language'] as String),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showLanguageDialog(context, ref),
    );
  }

  Widget _buildCurrencyPreference(BuildContext context, WidgetRef ref, Map<String, dynamic> preferences) {
    return ListTile(
      title: const Text('Currency'),
      subtitle: Text(preferences['currency'] as String),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showCurrencyDialog(context, ref),
    );
  }

  Widget _buildDistanceUnitPreference(BuildContext context, WidgetRef ref, Map<String, dynamic> preferences) {
    return ListTile(
      title: const Text('Distance Unit'),
      subtitle: Text(preferences['distanceUnit'] as String),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showDistanceUnitDialog(context, ref),
    );
  }

  Widget _buildTemperatureUnitPreference(BuildContext context, WidgetRef ref, Map<String, dynamic> preferences) {
    return ListTile(
      title: const Text('Temperature Unit'),
      subtitle: Text(preferences['temperatureUnit'] as String),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showTemperatureUnitDialog(context, ref),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Italian'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            return ListTile(
              title: Text(language),
              onTap: () {
                ref.read(preferencesProvider.notifier).updatePreference('language', language);
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
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) {
            return ListTile(
              title: Text(currency),
              onTap: () {
                ref.read(preferencesProvider.notifier).updatePreference('currency', currency);
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
      builder: (context) => AlertDialog(
        title: const Text('Select Distance Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: units.map((unit) {
            return ListTile(
              title: Text(unit),
              onTap: () {
                ref.read(preferencesProvider.notifier).updatePreference('distanceUnit', unit);
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
      builder: (context) => AlertDialog(
        title: const Text('Select Temperature Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: units.map((unit) {
            return ListTile(
              title: Text(unit),
              onTap: () {
                ref.read(preferencesProvider.notifier).updatePreference('temperatureUnit', unit);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
} 