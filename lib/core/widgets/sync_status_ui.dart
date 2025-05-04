import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/sync_status_service.dart';

class SyncStatusUI extends StatelessWidget {
  final SyncStatusService syncService;

  const SyncStatusUI({super.key, required this.syncService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SyncStatus>(
      stream: Stream.periodic(
        const Duration(milliseconds: 100),
        (_) => syncService.currentStatus,
      ),
      builder: (context, snapshot) {
        final status = snapshot.data ?? SyncStatus.online;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusIcon(status),
              const SizedBox(width: 8),
              _buildStatusText(context, status),
              if (status == SyncStatus.error) ...[
                const SizedBox(width: 8),
                _buildRetryButton(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(SyncStatus status) {
    IconData icon;
    Color color = _getStatusColor(status);

    switch (status) {
      case SyncStatus.online:
        icon = Icons.check_circle;
        break;
      case SyncStatus.syncing:
        return SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: const Duration(seconds: 2));
      case SyncStatus.offline:
        icon = Icons.cloud_off;
        break;
      case SyncStatus.error:
        icon = Icons.error;
        break;
    }

    return Icon(icon, size: 20, color: color);
  }

  Widget _buildStatusText(BuildContext context, SyncStatus status) {
    return Text(
      syncService.statusDescription,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: _getStatusColor(status)),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.refresh, size: 20),
      color: _getStatusColor(SyncStatus.error),
      onPressed: () => syncService.retrySync(),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: 'Retry sync',
    );
  }

  Color _getStatusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.online:
        return Colors.green;
      case SyncStatus.syncing:
        return Colors.blue;
      case SyncStatus.offline:
        return Colors.orange;
      case SyncStatus.error:
        return Colors.red;
    }
  }
}
