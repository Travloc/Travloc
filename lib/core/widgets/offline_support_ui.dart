import 'package:flutter/material.dart';
import '../services/offline_service.dart';
import 'preference_tile.dart';
import 'app_button.dart';
import 'preference_dialog.dart';

class OfflineSupportUI extends StatefulWidget {
  final OfflineService offlineService;

  const OfflineSupportUI({super.key, required this.offlineService});

  @override
  State<OfflineSupportUI> createState() => _OfflineSupportUIState();
}

class _OfflineSupportUIState extends State<OfflineSupportUI> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          if (_isExpanded) _buildExpandedContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isOffline = widget.offlineService.isOfflineMode;
    return PreferenceTile(
      icon: isOffline ? Icons.cloud_off : Icons.cloud_done,
      title: widget.offlineService.offlineStatus,
      subtitle: 'Storage: ${widget.offlineService.storageStatus}',
      iconBackgroundColor:
          isOffline ? const Color(0xFFFFE0B2) : const Color(0xFFC8E6C9),
      backgroundColor: const Color(0xFFF3EDFF),
      trailing: IconButton(
        icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
        onPressed: () => setState(() => _isExpanded = !_isExpanded),
      ),
      onTap: () => setState(() => _isExpanded = !_isExpanded),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTripPlanningSection(context),
          const Divider(),
          _buildUserDataSection(context),
          const Divider(),
          _buildOfflineDataSection(context),
          const Divider(),
          _buildManagementSection(context),
        ],
      ),
    );
  }

  Widget _buildTripPlanningSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trip Planning', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Download Trip Data',
                icon: Icons.download,
                isOutlined: true,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading trip data...')),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(
                text: 'Upload Changes',
                icon: Icons.upload,
                isOutlined: true,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await widget.offlineService.syncPendingChanges();
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Changes uploaded successfully'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserDataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Data', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Save Profile',
                icon: Icons.person,
                isOutlined: true,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile saved offline')),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(
                text: 'Sync Profile',
                icon: Icons.sync,
                isOutlined: true,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await widget.offlineService.syncPendingChanges();
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Profile synced successfully'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOfflineDataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Offline Data', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Manage Storage',
                icon: Icons.storage,
                isOutlined: true,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => PreferenceDialog<String>(
                          title: 'Storage Management',
                          options: ['Clear All Data', 'Close'],
                          selectedOption: '',
                          optionLabel: (opt) => opt,
                          onSelected: (opt) async {
                            if (opt == 'Clear All Data') {
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              await widget.offlineService.clearOfflineData();
                              if (!mounted) return;
                              navigator.pop();
                              if (!mounted) return;
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Offline data cleared'),
                                ),
                              );
                            } else {
                              if (!mounted) return;
                              Navigator.of(context).pop();
                            }
                          },
                          backgroundColor: const Color(0xFFF3EDFF),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManagementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Management', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Sync All Changes',
                icon: Icons.sync,
                isOutlined: true,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await widget.offlineService.syncPendingChanges();
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('All changes synced successfully'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(
                text: 'Settings',
                icon: Icons.settings,
                isOutlined: true,
                onPressed: () {
                  // Implement settings dialog
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
