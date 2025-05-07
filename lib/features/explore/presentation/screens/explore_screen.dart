import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travloc/features/explore/domain/models/trip_plan.dart';
import 'package:travloc/features/explore/domain/models/guide_list.dart';
import 'package:travloc/features/explore/domain/models/attraction_list.dart';
import 'package:travloc/features/explore/domain/services/voice_recognition_service.dart';
import 'package:travloc/features/explore/domain/services/ai_service.dart';
import 'package:travloc/features/explore/domain/services/api_service.dart';
import 'package:logger/logger.dart';
import 'package:travloc/core/widgets/ai_manual_toggle.dart';
import 'package:travloc/features/explore/presentation/widgets/trip_planner/location_search.dart';
import 'package:travloc/features/explore/presentation/widgets/trip_planner/interest_selection.dart';
import 'package:travloc/features/explore/presentation/widgets/trip_planner/budget_selection.dart';
import 'package:travloc/features/explore/presentation/widgets/trip_planner/confirm_button.dart';
import 'package:travloc/features/explore/presentation/widgets/trip_planner/group_size_selection.dart';

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

  // Trip planning form state
  final List<String> _selectedLocations = [];
  final List<String> _selectedInterests = [];
  String _selectedBudget = 'balanced';
  final TextEditingController _locationController = TextEditingController();
  int _adultCount = 1;
  int _childrenCount = 0;

  static const double _tripCardMinHeight =
      72 + 32; // 72 (child) + 16*2 (vertical padding)
  static const double _gap = 6; // gap between cards
  double? _mapMaxHeight;

  final List<Map<String, dynamic>> _locations = [];
  bool _showLocationsList = true;

  // Memoize commonly used values
  static const _defaultPadding = EdgeInsets.all(16);
  static const _defaultSizedBox = SizedBox(height: 16);
  static const _defaultIconColor = Color(0xFF2196F3);

  // Cache the date range picker theme
  ThemeData get _dateRangePickerTheme => Theme.of(context).copyWith(
    colorScheme: ColorScheme.light(
      primary: Color(0xFF2196F3),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

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
    _locationController.dispose();
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

  Future<void> _addLocation(String location) async {
    if (location.isEmpty) return;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (context, child) => Theme(data: _dateRangePickerTheme, child: child!),
    );
    if (picked != null) {
      setState(() {
        _locations.add({
          'name': location,
          'start': picked.start,
          'end': picked.end,
        });
        _locationController.clear();
      });
    }
  }

  void _removeLocation(int index) {
    setState(() {
      _locations.removeAt(index);
    });
  }

  Future<void> _editLocationDates(int index) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: _locations[index]['start'],
        end: _locations[index]['end'],
      ),
      builder:
          (context, child) => Theme(data: _dateRangePickerTheme, child: child!),
    );
    if (picked != null) {
      setState(() {
        _locations[index]['start'] = picked.start;
        _locations[index]['end'] = picked.end;
      });
    }
  }

  void _reorderLocations(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _locations.removeAt(oldIndex);
      _locations.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available height for map card
        final double eventCardHeight = 110; // estimate, or measure if needed
        final double availableHeight =
            constraints.maxHeight -
            _tripCardMinHeight -
            _gap -
            eventCardHeight -
            _gap -
            32; // 32 for SafeArea and padding fudge
        _mapMaxHeight = availableHeight > 0 ? availableHeight : 200;
        return Scaffold(
          backgroundColor: const Color(0xFF181A20),
          body: SafeArea(
            child: AnimatedBuilder(
              animation: _expandAnim,
              builder: (context, child) {
                final double tripCardHeight =
                    _tripCardMinHeight + (_mapMaxHeight! * _expandAnim.value);
                final double mapCardHeight =
                    _mapMaxHeight! * (1 - _expandAnim.value);
                return Column(
                  children: [
                    // AI Trip Planner Card (expanding)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                      child: TripPlannerCard(
                        height: tripCardHeight,
                        isVoiceMode: _isVoiceMode,
                        isListening: _isListening,
                        onMicTap:
                            _isListening
                                ? _stopVoiceRecognition
                                : _startVoiceRecognition,
                        onToggleMode: _onToggleMode,
                        child: Column(
                          children: [
                            // Content based on mode
                            Expanded(
                              child:
                                  _isVoiceMode
                                      ? _buildVoiceMode()
                                      : _buildManualMode(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: _gap),
                    // Map Card (collapsing)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 0,
                      ),
                      child: MapCard(
                        height: mapCardHeight,
                        compassHeading: _compassHeading,
                        onLocation: () => _handleLocationButtonPress(context),
                        onResetOrientation: _resetMapOrientation,
                      ),
                    ),
                    SizedBox(height: _gap),
                    // Event Card (unchanged)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                      child: EventCard(
                        nextEventTime: _nextEventTime,
                        eventProgress: _eventProgress,
                        onViewAll: _navigateToEvents,
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

  Widget _buildVoiceMode() {
    // Only the header mic is shown. No duplicate mic or animation here.
    return Container(
      height: 72, // Fixed height for voice mode
      constraints: const BoxConstraints(minHeight: 72, maxHeight: 72),
    );
  }

  Widget _buildManualMode() {
    return SingleChildScrollView(
      padding: _defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationSearch(
            locationController: _locationController,
            locations: _locations,
            showLocationsList: _showLocationsList,
            onAddLocation: _addLocation,
            onRemoveLocation: _removeLocation,
            onEditLocationDates: _editLocationDates,
            onReorderLocations: _reorderLocations,
            onToggleLocationsList:
                (value) => setState(() => _showLocationsList = value),
          ),
          _defaultSizedBox,
          GroupSizeSelection(
            adultCount: _adultCount,
            childrenCount: _childrenCount,
            onAdultCountChanged: (count) => setState(() => _adultCount = count),
            onChildrenCountChanged:
                (count) => setState(() => _childrenCount = count),
          ),
          _defaultSizedBox,
          InterestSelection(
            selectedInterests: _selectedInterests,
            onInterestSelected: (interest) {
              setState(() {
                if (_selectedInterests.contains(interest)) {
                  _selectedInterests.remove(interest);
                } else {
                  _selectedInterests.add(interest);
                }
              });
            },
            onShowAdditionalInterests: _showAdditionalInterests,
          ),
          _defaultSizedBox,
          BudgetSelection(
            selectedBudget: _selectedBudget,
            onBudgetChanged: (value) => setState(() => _selectedBudget = value),
          ),
          const SizedBox(height: 24),
          ConfirmButton(
            selectedLocations: _selectedLocations,
            selectedInterests: _selectedInterests,
            budgetCategory: _selectedBudget,
            adultCount: _adultCount,
            childrenCount: _childrenCount,
            onConfirm:
                (tripPlan) =>
                    _navigationService.navigateToTripPlanner(context, tripPlan),
          ),
        ],
      ),
    );
  }

  void _showAdditionalInterests(
    BuildContext context,
    List<Map<String, dynamic>> additionalInterests,
  ) {
    // Pass setState from parent to modal
    final parentSetState = setState;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.5,
                  maxChildSize: 0.9,
                  builder:
                      (context, scrollController) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Padding(
                              padding: _defaultPadding,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'More Interests',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (_selectedInterests.isNotEmpty) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2196F3),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            '${_selectedInterests.length} selected',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (_selectedInterests.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(
                                              () => _selectedInterests.clear(),
                                            );
                                            parentSetState(() {});
                                          },
                                          child: const Text(
                                            'Clear',
                                            style: TextStyle(
                                              color: Color(0xFF2196F3),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                controller: scrollController,
                                padding: _defaultPadding,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 1.0,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                itemCount: additionalInterests.length,
                                itemBuilder: (context, index) {
                                  final interest = additionalInterests[index];
                                  final isSelected = _selectedInterests
                                      .contains(interest['name']);

                                  return Material(
                                    color:
                                        isSelected
                                            ? _defaultIconColor
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedInterests.remove(
                                              interest['name'],
                                            );
                                          } else {
                                            _selectedInterests.add(
                                              interest['name']!,
                                            );
                                          }
                                        });
                                        parentSetState(() {});
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                isSelected
                                                    ? _defaultIconColor
                                                    : Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              interest['icon'] as IconData,
                                              color:
                                                  isSelected
                                                      ? Colors.white
                                                      : Colors.black87,
                                              size: 24,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              interest['name']!,
                                              style: TextStyle(
                                                color:
                                                    isSelected
                                                        ? Colors.white
                                                        : Colors.black87,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
          ),
    );
  }
}

// Extract EventCard widget
class EventCard extends StatelessWidget {
  final DateTime? nextEventTime;
  final double eventProgress;
  final VoidCallback onViewAll;
  const EventCard({
    super.key,
    required this.nextEventTime,
    required this.eventProgress,
    required this.onViewAll,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB7A6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.only(top: 14, left: 16, right: 16, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.event, color: Colors.black, size: 20),
                  const SizedBox(width: 6),
                  const Text(
                    'Next Event',
                    style: TextStyle(
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
                  color: const Color(0xFFBFFF2A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: onViewAll,
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
            nextEventTime != null
                ? 'Upcoming event in ${nextEventTime!.difference(DateTime.now()).inMinutes} minutes'
                : 'No upcoming events',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: eventProgress,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 5,
          ),
        ],
      ),
    );
  }
}

// Extract MapCard widget
class MapCard extends StatelessWidget {
  final double height;
  final double compassHeading;
  final VoidCallback onLocation;
  final VoidCallback onResetOrientation;
  const MapCard({
    super.key,
    required this.height,
    required this.compassHeading,
    required this.onLocation,
    required this.onResetOrientation,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                      icon: const Icon(
                        Icons.my_location,
                        color: Colors.blueAccent,
                        size: 22,
                      ),
                      onPressed: onLocation,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: const Color(0xFFD6E6FF),
                    shape: const CircleBorder(),
                    elevation: 1,
                    child: IconButton(
                      icon: Transform.rotate(
                        angle: compassHeading * (3.141592653589793 / 180),
                        child: const Icon(
                          Icons.explore,
                          color: Colors.blueAccent,
                          size: 22,
                        ),
                      ),
                      onPressed: onResetOrientation,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extract TripPlannerCard widget (AI Trip Planner Card)
class TripPlannerCard extends StatelessWidget {
  final double height;
  final bool isVoiceMode;
  final bool isListening;
  final VoidCallback onMicTap;
  final ValueChanged<bool> onToggleMode;
  final Widget child;
  const TripPlannerCard({
    super.key,
    required this.height,
    required this.isVoiceMode,
    required this.isListening,
    required this.onMicTap,
    required this.onToggleMode,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFBFFF2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: SizedBox(
              height: 56,
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width / 4.2 - 28,
                    top: 0,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 0,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onMicTap,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            isListening ? Icons.mic : Icons.mic_none,
                            size: 28,
                            color: const Color(0xFFFF4081),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 14,
                    child: VoiceManualToggle(
                      isVoiceMode: isVoiceMode,
                      onChanged: onToggleMode,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
