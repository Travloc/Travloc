import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum SafetyLevel { safe, moderate, risky }

class SafetyZone {
  final String name;
  final SafetyLevel level;
  final String description;
  final List<String> warnings;

  const SafetyZone({
    required this.name,
    required this.level,
    required this.description,
    required this.warnings,
  });
}

class LocationSafetyUI extends StatelessWidget {
  final SafetyZone currentZone;
  final List<SafetyZone> nearbySafeZones;
  final Function(SafetyZone) onZoneSelected;
  final VoidCallback onRefresh;

  const LocationSafetyUI({
    super.key,
    required this.currentZone,
    required this.nearbySafeZones,
    required this.onZoneSelected,
    required this.onRefresh,
  });

  Color _getSafetyColor(SafetyLevel level) {
    switch (level) {
      case SafetyLevel.safe:
        return Colors.green;
      case SafetyLevel.moderate:
        return Colors.orange;
      case SafetyLevel.risky:
        return Colors.red;
    }
  }

  IconData _getSafetyIcon(SafetyLevel level) {
    switch (level) {
      case SafetyLevel.safe:
        return Icons.verified_user;
      case SafetyLevel.moderate:
        return Icons.warning;
      case SafetyLevel.risky:
        return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Zone Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getSafetyColor(currentZone.level).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                      _getSafetyIcon(currentZone.level),
                      color: _getSafetyColor(currentZone.level),
                      size: 32,
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 2000.ms),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentZone.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        currentZone.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: onRefresh,
                ),
              ],
            ),
          ),

          // Warnings List
          if (currentZone.warnings.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Current Warnings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentZone.warnings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(currentZone.warnings[index]),
                );
              },
            ),
          ],

          const Divider(),

          // Nearby Safe Zones
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Nearby Safe Zones',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: nearbySafeZones.length,
            itemBuilder: (context, index) {
              final zone = nearbySafeZones[index];
              return ListTile(
                leading: Icon(
                  _getSafetyIcon(zone.level),
                  color: _getSafetyColor(zone.level),
                ),
                title: Text(zone.name),
                subtitle: Text(zone.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => onZoneSelected(zone),
              );
            },
          ),
        ],
      ),
    );
  }
}
