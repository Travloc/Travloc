import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/offline_service.dart';

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
    return Card(
      margin: const EdgeInsets.all(16),
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
    return ListTile(
      leading: Icon(
            widget.offlineService.isOfflineMode
                ? Icons.cloud_off
                : Icons.cloud_done,
            color:
                widget.offlineService.isOfflineMode
                    ? Colors.orange
                    : Colors.green,
          )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: const Duration(seconds: 2),
            color:
                widget.offlineService.isOfflineMode
                    ? Colors.orange.withValues(alpha: 128)
                    : Colors.green.withValues(alpha: 128),
          ),
      title: Text(
        widget.offlineService.offlineStatus,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'Storage: ${widget.offlineService.storageStatus}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
        onPressed: () => setState(() => _isExpanded = !_isExpanded),
      ),
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
              child: OutlinedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download Trip Data'),
                onPressed: () {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  // Implement trip data download
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Downloading trip data...')),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('Upload Changes'),
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  await widget.offlineService.syncPendingChanges();
                  if (!mounted) return;
                  scaffoldMessenger.showSnackBar(
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
              child: OutlinedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('Save Profile'),
                onPressed: () {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  // Implement profile save
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Profile saved offline')),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.sync),
                label: const Text('Sync Profile'),
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  await widget.offlineService.syncPendingChanges();
                  if (!mounted) return;
                  scaffoldMessenger.showSnackBar(
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
              child: OutlinedButton.icon(
                icon: const Icon(Icons.storage),
                label: const Text('Manage Storage'),
                onPressed: () {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Storage Management'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Current Usage: ${widget.offlineService.storageStatus}',
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value:
                                    widget.offlineService.storageStatus
                                            .contains('MB')
                                        ? 0.8
                                        : widget.offlineService.storageStatus
                                            .contains('KB')
                                        ? 0.4
                                        : 0.1,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await widget.offlineService.clearOfflineData();
                                if (!mounted) return;
                                navigator.pop();
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Offline data cleared'),
                                  ),
                                );
                              },
                              child: const Text('Clear All Data'),
                            ),
                            TextButton(
                              onPressed: () => navigator.pop(),
                              child: const Text('Close'),
                            ),
                          ],
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
              child: OutlinedButton.icon(
                icon: const Icon(Icons.sync),
                label: const Text('Sync All Changes'),
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  await widget.offlineService.syncPendingChanges();
                  if (!mounted) return;
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('All changes synced successfully'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
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
