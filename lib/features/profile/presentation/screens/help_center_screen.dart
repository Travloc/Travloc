import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpCenterScreen extends ConsumerWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, 'Frequently Asked Questions', [
            _buildFAQItem(
              context,
              'How do I create a trip?',
              'To create a trip, go to the Trips section and tap the + button.',
            ),
            _buildFAQItem(
              context,
              'How do I save a place?',
              'When viewing a place, tap the bookmark icon to save it.',
            ),
            _buildFAQItem(
              context,
              'How do I update my profile?',
              'Go to Profile > Personal Information to update your details.',
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Troubleshooting', [
            _buildFAQItem(
              context,
              'App is not responding',
              'Try closing and reopening the app. If the issue persists, check your internet connection.',
            ),
            _buildFAQItem(
              context,
              'Can\'t log in',
              'Make sure you\'re using the correct email and password. Try resetting your password if needed.',
            ),
          ]),
        ],
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(question),
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(answer)),
        ],
      ),
    );
  }
}
