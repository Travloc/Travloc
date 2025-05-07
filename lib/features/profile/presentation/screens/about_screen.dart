import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travloc/core/widgets/preference_tile.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFB7A6FF),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'About Travloc',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // App Info Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB7A6FF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.08 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.travel_explore,
                      size: 38,
                      color: Color(0xFFB7A6FF),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Travloc',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version ${_packageInfo?.version ?? '1.0.0'}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            // Description Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFD6E0),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.08 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text(
                'Travloc is your ultimate travel companion app, helping you plan, organize, and enjoy your trips with ease.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Contact Section
            _buildSectionCard(
              context,
              title: 'Contact Us',
              color: const Color(0xFFBFFF2A),
              children: [
                _buildContactItem(
                  context,
                  'Email',
                  'support@travloc.com',
                  Icons.email,
                  () => _launchUrl('mailto:support@travloc.com'),
                ),
                _buildContactItem(
                  context,
                  'Website',
                  'www.travloc.com',
                  Icons.language,
                  () => _launchUrl('https://www.travloc.com'),
                ),
              ],
            ),
            // Legal Section
            _buildSectionCard(
              context,
              title: 'Legal',
              color: const Color(0xFFB7A6FF),
              children: [
                _buildLegalItem(
                  context,
                  'Privacy Policy',
                  () => _launchUrl('https://www.travloc.com/privacy'),
                ),
                _buildLegalItem(
                  context,
                  'Terms of Service',
                  () => _launchUrl('https://www.travloc.com/terms'),
                ),
                _buildLegalItem(
                  context,
                  'Open Source Licenses',
                  () => showLicensePage(
                    context: context,
                    applicationName: 'Travloc',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Color color,
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
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return PreferenceTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      backgroundColor: const Color(0xFFF3EDFF),
      iconBackgroundColor: const Color(0xFFD1C4E9),
    );
  }

  Widget _buildLegalItem(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return PreferenceTile(
      icon: Icons.gavel,
      title: title,
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      backgroundColor: const Color(0xFFF3EDFF),
      iconBackgroundColor: const Color(0xFFD1C4E9),
    );
  }
}
