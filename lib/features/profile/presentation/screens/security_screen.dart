import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final securityProvider =
    StateNotifierProvider<SecurityState, Map<String, dynamic>>((ref) {
      return SecurityState();
    });

class SecurityState extends StateNotifier<Map<String, dynamic>> {
  SecurityState()
    : super({
        'isLoading': false,
        'error': null,
        'success': false,
        'connectedDevices': [
          {
            'id': '1',
            'name': 'iPhone 13',
            'lastActive': '2024-03-15 14:30',
            'location': 'New York, USA',
          },
          {
            'id': '2',
            'name': 'MacBook Pro',
            'lastActive': '2024-03-15 15:45',
            'location': 'New York, USA',
          },
        ],
      });

  void setLoading(bool isLoading) {
    state = {...state, 'isLoading': isLoading, 'error': null, 'success': false};
  }

  void setError(String error) {
    state = {...state, 'isLoading': false, 'error': error, 'success': false};
  }

  void setSuccess() {
    state = {...state, 'isLoading': false, 'error': null, 'success': true};
  }

  void removeDevice(String deviceId) {
    final devices = List<Map<String, dynamic>>.from(
      state['connectedDevices'] as List,
    );
    devices.removeWhere((device) => device['id'] == deviceId);
    state = {...state, 'connectedDevices': devices};
  }
}

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse(
          '${const String.fromEnvironment('API_URL')}/auth/change-password',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Failed to change password';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception(
        'Failed to connect to the server. Please try again later.',
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    hintText: 'Enter your current password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    hintText: 'Confirm your new password',
                  ),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final security = ref.watch(securityProvider);
                  return TextButton(
                    onPressed:
                        security['isLoading']
                            ? null
                            : () async {
                              if (newPasswordController.text !=
                                  confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('New passwords do not match'),
                                  ),
                                );
                                return;
                              }

                              ref
                                  .read(securityProvider.notifier)
                                  .setLoading(true);
                              try {
                                await changePassword(
                                  currentPasswordController.text,
                                  newPasswordController.text,
                                );
                                ref
                                    .read(securityProvider.notifier)
                                    .setSuccess();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Password changed successfully',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ref
                                    .read(securityProvider.notifier)
                                    .setError(e.toString());
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            },
                    child:
                        security['isLoading']
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Change'),
                  );
                },
              ),
            ],
          ),
    );
  }

  void _showConnectedDevices(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(securityProvider)['connectedDevices'] as List;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Connected Devices'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  devices.map((device) {
                    return ListTile(
                      leading: const Icon(Icons.devices),
                      title: Text(device['name'] as String),
                      subtitle: Text(
                        'Last active: ${device['lastActive']}\nLocation: ${device['location']}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          ref
                              .read(securityProvider.notifier)
                              .removeDevice(device['id'] as String);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${device['name']} logged out successfully',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

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
                    'Security',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Change Password Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFD6E0),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD6E0).withAlpha(30),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: ListTile(
                leading: const Icon(Icons.lock, color: Colors.black),
                title: const Text(
                  'Change Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
                onTap: () => _showChangePasswordDialog(context, ref),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tileColor: Colors.transparent,
              ),
            ),
            // Connected Devices Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB7A6FF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB7A6FF).withAlpha(30),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: ListTile(
                leading: const Icon(Icons.devices, color: Colors.black),
                title: const Text(
                  'Connected Devices',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
                onTap: () => _showConnectedDevices(context, ref),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tileColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
