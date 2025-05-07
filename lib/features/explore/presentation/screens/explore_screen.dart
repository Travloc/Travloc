import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travloc/features/explore/domain/models/trip_plan.dart';
import 'package:travloc/features/explore/domain/models/guide_list.dart';
import 'package:travloc/features/explore/domain/models/attraction_list.dart';
import 'package:travloc/features/explore/domain/services/voice_recognition_service.dart';
import 'package:travloc/features/explore/domain/services/ai_service.dart';
import 'package:travloc/features/explore/domain/services/api_service.dart';
import 'package:travloc/core/widgets/ai_manual_toggle.dart';
import 'package:logger/logger.dart';

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

  void navigateToTripPlanner(BuildContext context, TripPlan tripPlan) {
    // Will be implemented when trip planner feature is added
  }

  void navigateToGuides(BuildContext context, GuideList guideList) {
    // Will be implemented when guides feature is added
  }

  void navigateToAttractions(
    BuildContext context,
    AttractionList attractionList,
  ) {
    // Will be implemented when attractions feature is added
  }
}

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  double _compassHeading = 0.0;
  bool _isLocationEnabled = false;
  DateTime? _nextEventTime;
  Position? _currentPosition;
  final MapController _mapController = MapController();
  final NavigationService _navigationService = NavigationService();
  final ApiService _apiService = ApiService(
    baseUrl: 'https://api.travloc.com/v1',
  );
  final VoiceRecognitionService _voiceRecognitionService =
      VoiceRecognitionService();
  late final AIService _aiService;
  bool _isVoiceMode = true;
  final Logger _logger = Logger();
  late final AnimationController _expandController;
  late final Animation<double> _expandAnim;

  static const double _tripCardMinHeight = 72 + 32; // 72 (child) + 16*2 (vertical padding)
  static const double _gap = 6; // gap between cards
  double? _mapMaxHeight;

  @override
  void initState() {
    super.initState();
    _aiService = AIService(apiService: _apiService);
    _checkLocationPermission();
    _startCompassUpdates();
    _simulateNextEvent();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    if (!mounted) return;
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
    if (!mounted) return;
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
    if (!mounted) return;
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

  Future<void> _centerMapOnLocation(ScaffoldMessengerState messenger) async {
    if (_currentPosition != null) {
      _mapController.centerOnLocation(_currentPosition!);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Centering on your location...')),
      );
    }
  }

  void _resetMapOrientation() {
    if (!mounted) return;
    _mapController.resetOrientation();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resetting map orientation...')),
    );
  }

  void _navigateToEvents() {
    if (!mounted) return;
    _navigationService.navigateToEvents(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigating to events...')));
  }

  void _handleVoiceInput() {
    if (!mounted) return;
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      _startVoiceRecognition();
    } else {
      _stopVoiceRecognition();
    }
  }

  Future<void> _startVoiceRecognition() async {
    if (!mounted) return;
    try {
      // Start voice recognition
      await _voiceRecognitionService.startListening();

      // Show listening state
      setState(() {
        _isListening = true;
      });
    } catch (e) {
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _stopVoiceRecognition() async {
    if (!mounted) return;
    try {
      // Stop voice recognition and process result
      final result = await _voiceRecognitionService.stopListening();

      // Process the voice input
      await _processVoiceInput(result);
    } catch (e) {
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _processVoiceInput(String input) async {
    if (!mounted) return;
    try {
      final response = await _aiService.processVoiceInput(input);
      if (!mounted) return;
      // Inline navigation logic here
      if (response is TripPlan) {
        _navigationService.navigateToTripPlanner(context, response);
      } else if (response is GuideList) {
        _navigationService.navigateToGuides(context, response);
      } else if (response is AttractionList) {
        _navigationService.navigateToAttractions(context, response);
      }
    } catch (e) {
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _handleLocationButtonPress(BuildContext ctx) async {
    final messenger = ScaffoldMessenger.of(ctx);

    if (!_isLocationEnabled) {
      await _checkLocationPermission();
      if (!mounted) return;

      if (!_isLocationEnabled) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Please enable location services')),
        );
        return;
      }
    }

    await _centerMapOnLocation(messenger);
  }

  void _onToggleMode(bool voiceMode) {
    setState(() {
      _isVoiceMode = voiceMode;
    });
    if (voiceMode) {
      _expandController.reverse();
    } else {
      _expandController.forward();
    }
    _logger.i('Mode: ${voiceMode ? 'Voice' : 'Manual'}');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available height for map card
        final double eventCardHeight = 110; // estimate, or measure if needed
        final double availableHeight = constraints.maxHeight - _tripCardMinHeight - _gap - eventCardHeight - _gap - 32; // 32 for SafeArea and padding fudge
        _mapMaxHeight = availableHeight > 0 ? availableHeight : 200;
        return Scaffold(
          backgroundColor: const Color(0xFF181A20),
          body: SafeArea(
            child: AnimatedBuilder(
              animation: _expandAnim,
              builder: (context, child) {
                final double tripCardHeight = _tripCardMinHeight + (_mapMaxHeight! * _expandAnim.value);
                final double mapCardHeight = _mapMaxHeight! * (1 - _expandAnim.value);
                return Column(
                  children: [
                    // AI Trip Planner Card (expanding)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear,
                        height: tripCardHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFFBFFF2A),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.08 * 255).toInt()),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Stack(
                          children: [
                            // The expanding background
                            Positioned.fill(child: SizedBox()),
                            // The fixed mic and toggle row
                            Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                height: _tripCardMinHeight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_isVoiceMode)
                                      Material(
                                        color: Colors.white,
                                        shape: const CircleBorder(),
                                        elevation: 2,
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: _handleVoiceInput,
                                          child: Padding(
                                            padding: const EdgeInsets.all(14),
                                            child: Icon(
                                              Icons.mic,
                                              color: Colors.teal[400],
                                              size: 36,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Spacer(flex: 1),
                                    VoiceManualToggle(
                                      isVoiceMode: _isVoiceMode,
                                      onChanged: _onToggleMode,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: _gap),
                    // Map Card (collapsing)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear,
                        height: mapCardHeight,
                        child: Container(
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
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Map View',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 18,
                                bottom: 18,
                                child: Row(
                                  children: [
                                    Material(
                                      color: const Color(0xFFD6E6FF),
                                      shape: const CircleBorder(),
                                      elevation: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.my_location,
                                          color: Colors.blueAccent,
                                          size: 22,
                                        ),
                                        onPressed: () => _handleLocationButtonPress(context),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Material(
                                      color: const Color(0xFFD6E6FF),
                                      shape: const CircleBorder(),
                                      elevation: 1,
                                      child: IconButton(
                                        icon: Transform.rotate(
                                          angle: _compassHeading * (3.141592653589793 / 180),
                                          child: const Icon(
                                            Icons.explore,
                                            color: Colors.blueAccent,
                                            size: 22,
                                          ),
                                        ),
                                        onPressed: _resetMapOrientation,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _gap),
                    // Event Card (unchanged)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                      child: Container(
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
                        padding: const EdgeInsets.only(
                          top: 14,
                          left: 16,
                          right: 16,
                          bottom: 40, // Increased bottom padding
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.event,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Next Event',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFBFFF2A),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: GestureDetector(
                                    onTap: _navigateToEvents,
                                    child: const Text(
                                      'View All',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _nextEventTime != null
                                  ? 'Upcoming event in ${_nextEventTime!.difference(DateTime.now()).inMinutes} minutes'
                                  : 'No upcoming events',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _eventProgress,
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.amber[700]!,
                              ),
                              minHeight: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
