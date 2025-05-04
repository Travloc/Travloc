import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';
import '../services/conflict_resolution_service.dart';

class ConflictResolutionUI extends StatefulWidget {
  final ConflictResolutionService conflictService;

  const ConflictResolutionUI({super.key, required this.conflictService});

  @override
  State<ConflictResolutionUI> createState() => _ConflictResolutionUIState();
}

class _ConflictResolutionUIState extends State<ConflictResolutionUI> {
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
            widget.conflictService.hasConflicts
                ? Icons.warning_amber_rounded
                : Icons.check_circle,
            color:
                widget.conflictService.hasConflicts
                    ? Colors.orange
                    : Colors.green,
          )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: const Duration(seconds: 2),
            color:
                widget.conflictService.hasConflicts
                    ? Colors.orange.withValues(alpha: 128)
                    : Colors.green.withValues(alpha: 128),
          ),
      title: Text(
        widget.conflictService.hasConflicts
            ? '${widget.conflictService.activeConflicts.length} Conflicts Found'
            : 'No Conflicts',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        widget.conflictService.hasConflicts
            ? 'Tap to view and resolve conflicts'
            : 'All data is synchronized',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
        onPressed: () => setState(() => _isExpanded = !_isExpanded),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    if (!widget.conflictService.hasConflicts) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('No conflicts to resolve')),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConflictList(context),
          const Divider(),
          _buildStatistics(context),
          const Divider(),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildConflictList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Active Conflicts', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.conflictService.activeConflicts.length,
          itemBuilder: (context, index) {
            final conflict = widget.conflictService.activeConflicts[index];
            return _buildConflictItem(context, conflict);
          },
        ),
      ],
    );
  }

  Widget _buildConflictItem(BuildContext context, Conflict conflict) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          '${conflict.entityType} - ${conflict.type.toString().split('.').last}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          conflict.description ??
              widget.conflictService.getConflictDescription(conflict),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Local Version',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  jsonEncode(conflict.localData),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Remote Version',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  jsonEncode(conflict.remoteData),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Use Local'),
                        onPressed:
                            () => _resolveConflict(
                              context,
                              conflict,
                              conflict.localData,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.cloud_download),
                        label: const Text('Use Remote'),
                        onPressed:
                            () => _resolveConflict(
                              context,
                              conflict,
                              conflict.remoteData,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    final stats = widget.conflictService.getConflictStatistics();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conflict Statistics',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...stats.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Text(
                  '${entry.key.toString().split('.').last}:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  entry.value.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear All'),
            onPressed: () {
              widget.conflictService.clearAllConflicts();
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            onPressed: () => setState(() {}),
          ),
        ),
      ],
    );
  }

  Future<void> _resolveConflict(
    BuildContext context,
    Conflict conflict,
    Map<String, dynamic> resolution,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await widget.conflictService.resolveConflict(
        conflict.id,
        resolution: resolution,
      );
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Conflict resolved successfully')),
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error resolving conflict: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
