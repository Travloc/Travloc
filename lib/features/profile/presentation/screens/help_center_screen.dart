import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpCenterScreen extends ConsumerWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    'Help Center',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // FAQ Section
            _buildSection(context, 'Frequently Asked Questions', [
              _buildFAQItem(
                context,
                'How do I create a trip?',
                'To create a trip, go to the Trips section and tap the + button.',
                color: const Color(0xFFB7A6FF),
              ),
              _buildFAQItem(
                context,
                'How do I save a place?',
                'When viewing a place, tap the bookmark icon to save it.',
                color: const Color(0xFFBFFF2A),
              ),
              _buildFAQItem(
                context,
                'How do I update my profile?',
                'Go to Profile > Personal Information to update your details.',
                color: const Color(0xFFFFD6E0),
              ),
            ]),
            const SizedBox(height: 18),
            _buildSection(context, 'Troubleshooting', [
              _buildFAQItem(
                context,
                'App is not responding',
                'Try closing and reopening the app. If the issue persists, check your internet connection.',
                color: const Color(0xFFB7A6FF),
              ),
              _buildFAQItem(
                context,
                'Can\'t log in',
                'Make sure you\'re using the correct email and password. Try resetting your password if needed.',
                color: const Color(0xFFBFFF2A),
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
          padding: const EdgeInsets.only(left: 4, bottom: 10, top: 2),
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB7A6FF),
                  fontSize: 20,
                ) ??
                const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB7A6FF),
                  fontSize: 20,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildFAQItem(
    BuildContext context,
    String question,
    String answer, {
    required Color color,
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
      margin: const EdgeInsets.only(bottom: 10),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: color.withAlpha(40),
          highlightColor: color.withAlpha(30),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          title: Text(
            question,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ) ??
                const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: color,
          collapsedBackgroundColor: color,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                answer,
                style:
                    Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black) ??
                    const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
