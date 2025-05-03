import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';

// Map controller to handle map operations
class MapController {
  void centerOnLocation(Position position) {
    // Will be implemented when map widget is added
  }

  void resetOrientation() {
    // Will be implemented when map widget is added
  }
}

// Navigation service to handle screen navigation
class NavigationService {
  void navigateToEvents(BuildContext context) {
    // Will be implemented when events feature is added
  }
}

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  bool _isVoiceMode = true;
  bool _isListening = false;
  double _compassHeading = 0.0;
  bool _isLocationEnabled = false;
  DateTime? _nextEventTime;
  Position? _currentPosition;
  final MapController _mapController = MapController();
  final NavigationService _navigationService = NavigationService();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _startCompassUpdates();
    _simulateNextEvent();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() => _isLocationEnabled = false);
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() => _isLocationEnabled = false);
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() => _isLocationEnabled = false);
      }
      return;
    }

    if (mounted) {
      setState(() => _isLocationEnabled = true);
    }
  }

  void _startCompassUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      if (mounted) {
        setState(() {
          _compassHeading = position.heading;
          _currentPosition = position;
        });
      }
    });
  }

  void _simulateNextEvent() {
    setState(() {
      _nextEventTime = DateTime.now().add(const Duration(hours: 2));
    });
  }

  double get _eventProgress {
    if (_nextEventTime == null) return 0.0;
    final now = DateTime.now();
    final totalDuration = _nextEventTime!.difference(now).inMinutes;
    if (totalDuration <= 0) return 1.0;
    return 1.0 - (totalDuration / 120.0); // 120 minutes = 2 hours
  }

  Future<void> _centerMapOnLocation() async {
    if (_currentPosition != null) {
      _mapController.centerOnLocation(_currentPosition!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Centering on your location...')),
        );
      }
    }
  }

  void _resetMapOrientation() {
    _mapController.resetOrientation();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resetting map orientation...')),
    );
  }

  void _navigateToEvents() {
    _navigationService.navigateToEvents(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigating to events...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Section (20%)
        Expanded(
          flex: 2,
          child: _buildTopSection(),
        ),
        // Middle Section (60%)
        Expanded(
          flex: 6,
          child: _buildMapSection(),
        ),
        // Bottom Section (20%)
        Expanded(
          flex: 2,
          child: _buildBottomSection(),
        ),
      ],
    );
  }

  Widget _buildTopSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AI Trip Planner Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Voice Interaction Mode
                Expanded(
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 48,
                          color: _isListening ? Theme.of(context).colorScheme.primary : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isListening = !_isListening;
                          });
                        },
                      )
                      .animate(
                        target: _isListening ? 1 : 0,
                      )
                      .scale(
                        duration: 500.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .shimmer(
                        duration: 1000.ms,
                        color: Theme.of(context).colorScheme.primary.withAlpha(128),
                      ),
                      const Text(
                        'Speak to plan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle Switch
                Column(
                  children: [
                    const Text(
                      'Manual Mode',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Switch(
                      value: !_isVoiceMode,
                      onChanged: (value) {
                        setState(() {
                          _isVoiceMode = !value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Map View',
              style: TextStyle(fontSize: 24),
            ),
          ),
          // Map Controls
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'location',
                  onPressed: () async {
                    if (!_isLocationEnabled) {
                      await _checkLocationPermission();
                    }
                    if (_isLocationEnabled) {
                      await _centerMapOnLocation();
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enable location services')),
                      );
                    }
                  },
                  child: Icon(
                    _isLocationEnabled ? Icons.my_location : Icons.location_disabled,
                  ),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'compass',
                  onPressed: _resetMapOrientation,
                  child: Transform.rotate(
                    angle: _compassHeading * (3.141592653589793 / 180),
                    child: const Icon(Icons.explore),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Next Event',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _navigateToEvents,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _nextEventTime != null
                  ? 'Upcoming event in ${_nextEventTime!.difference(DateTime.now()).inMinutes} minutes'
                  : 'No upcoming events',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _eventProgress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 