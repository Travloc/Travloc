import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:travloc/core/widgets/preference_tile.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Support Options
                _buildSection(context, 'Support Options', [
                  _supportOptionCard(
                    context,
                    title: 'Live Chat',
                    icon: Icons.chat,
                    subtitle: 'Chat with our support team',
                    color: const Color(0xFFB7A6FF),
                    onTap: () async {
                      if (context.mounted) {
                        Navigator.pushNamed(context, '/chat');
                      }
                    },
                  ),
                  _supportOptionCard(
                    context,
                    title: 'Email Support',
                    icon: Icons.email,
                    subtitle: 'support@travloc.com',
                    color: const Color(0xFFBFFF2A),
                    onTap: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'support@travloc.com',
                        queryParameters: {'subject': 'Travloc Support Request'},
                      );
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not launch email client'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  _supportOptionCard(
                    context,
                    title: 'Phone Support',
                    icon: Icons.phone,
                    subtitle: '+1 (555) 123-4567',
                    color: const Color(0xFFFFD6E0),
                    onTap: () async {
                      final Uri phoneLaunchUri = Uri(
                        scheme: 'tel',
                        path: '+15551234567',
                      );
                      if (await canLaunchUrl(phoneLaunchUri)) {
                        await launchUrl(phoneLaunchUri);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not launch phone dialer'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ]),
                const SizedBox(height: 24),
                // Contact Form
                _buildSection(context, 'Send us a Message', [
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
                      vertical: 20,
                      horizontal: 18,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _subjectController,
                            decoration: const InputDecoration(
                              labelText: 'Subject',
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFFB7A6FF),
                                  width: 2,
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.black87),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a subject';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _messageController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              labelText: 'Message',
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFFB7A6FF),
                                  width: 2,
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.black87),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a message';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 80,
                          ), // For floating button space
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
            // Floating Send Button
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFB7A6FF),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await _sendSupportMessage(
                        _subjectController.text,
                        _messageController.text,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Message sent successfully!'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error sending message: $e')),
                        );
                      }
                    }
                    _subjectController.clear();
                    _messageController.clear();
                  }
                },
                child: const Icon(Icons.send, color: Colors.black),
              ),
            ),
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _supportOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return PreferenceTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      backgroundColor: color,
      iconBackgroundColor: Colors.white,
    );
  }

  Future<void> _sendSupportMessage(String subject, String message) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_BASE_URL']}/support/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode({
          'subject': subject,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<String> _getAuthToken() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No authentication token found');
    }
    return token;
  }
}
