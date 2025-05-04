import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/performance_service.dart';

class PerformanceOptimizationUI extends StatefulWidget {
  final PerformanceService performanceService;

  const PerformanceOptimizationUI({
    super.key,
    required this.performanceService,
  });

  @override
  State<PerformanceOptimizationUI> createState() =>
      _PerformanceOptimizationUIState();
}

class _PerformanceOptimizationUIState extends State<PerformanceOptimizationUI> {
  bool _enableBatteryOptimization = true;
  bool _enableDataOptimization = true;
  Duration _cacheDuration = const Duration(hours: 1);
  int _maxConcurrentOperations = 3;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _enableBatteryOptimization = true;
      _enableDataOptimization = true;
      _cacheDuration = const Duration(hours: 1);
      _maxConcurrentOperations = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.speed, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: const Duration(seconds: 2)),
                const SizedBox(width: 8),
                Text(
                  'Performance Optimization',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Battery Optimization'),
              subtitle: const Text(
                'Reduce power consumption when battery is low',
              ),
              value: _enableBatteryOptimization,
              onChanged: (value) {
                setState(() {
                  _enableBatteryOptimization = value;
                });
                widget.performanceService.setBatteryOptimization(value);
              },
            ),
            SwitchListTile(
              title: const Text('Data Optimization'),
              subtitle: const Text('Optimize data usage on slow connections'),
              value: _enableDataOptimization,
              onChanged: (value) {
                setState(() {
                  _enableDataOptimization = value;
                });
                widget.performanceService.setDataOptimization(value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Duration>(
              decoration: const InputDecoration(
                labelText: 'Cache Duration',
                border: OutlineInputBorder(),
              ),
              value: _cacheDuration,
              items: const [
                DropdownMenuItem(
                  value: Duration(minutes: 15),
                  child: Text('15 minutes'),
                ),
                DropdownMenuItem(
                  value: Duration(hours: 1),
                  child: Text('1 hour'),
                ),
                DropdownMenuItem(
                  value: Duration(hours: 6),
                  child: Text('6 hours'),
                ),
                DropdownMenuItem(
                  value: Duration(days: 1),
                  child: Text('1 day'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _cacheDuration = value;
                  });
                  widget.performanceService.setCacheDuration(value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Max Concurrent Operations',
                border: OutlineInputBorder(),
              ),
              value: _maxConcurrentOperations,
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 operation')),
                DropdownMenuItem(value: 2, child: Text('2 operations')),
                DropdownMenuItem(value: 3, child: Text('3 operations')),
                DropdownMenuItem(value: 5, child: Text('5 operations')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _maxConcurrentOperations = value;
                  });
                  widget.performanceService.setMaxConcurrentOperations(value);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                widget.performanceService.clearCache();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Clear Cache'),
            ),
          ],
        ),
      ),
    );
  }
}
