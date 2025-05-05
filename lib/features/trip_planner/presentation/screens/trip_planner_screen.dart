import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'event_details_screen.dart';
import 'package_details_screen.dart';
import '../../../../core/widgets/segmented_tab_control.dart';

// Event model
class Event {
  final int id;
  final String title;
  final String location;
  final String time;
  final double cost;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.time,
    required this.cost,
  });
}

// Timeline state provider
final timelineProvider = StateNotifierProvider<TimelineNotifier, List<Event>>((
  ref,
) {
  return TimelineNotifier();
});

class TimelineNotifier extends StateNotifier<List<Event>> {
  TimelineNotifier() : super([]);

  void addEvent(Event event) {
    state = [...state, event];
  }

  void removeEvent(int eventId) {
    state = state.where((event) => event.id != eventId).toList();
  }
}

class TripPlannerScreen extends ConsumerStatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  ConsumerState<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends ConsumerState<TripPlannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Timeline', 'Suggestions', 'Packages'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToEventDetails(int eventId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(eventId: eventId),
      ),
    );
  }

  void _addToTimeline(int suggestionId) {
    final event = Event(
      id: suggestionId,
      title: 'Suggestion $suggestionId',
      location: 'Location $suggestionId',
      time: 'Time $suggestionId',
      cost: 50.0 * suggestionId,
    );
    ref.read(timelineProvider.notifier).addEvent(event);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${event.title} to timeline'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _viewPackageDetails(int packageId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PackageDetailsScreen(packageId: packageId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTimelineTab(),
              _buildSuggestionsTab(),
              _buildPackagesTab(),
            ],
          ),
        ),
        // Custom Segmented Control at Bottom
        SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedTabControl(
              tabs: _tabs,
              currentIndex: _tabController.index,
              currentPosition:
                  _tabController.animation?.value ??
                  _tabController.index.toDouble(),
              onTabSelected: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTab() {
    final events = ref.watch(timelineProvider);
    final totalCost = events.fold(0.0, (sum, event) => sum + event.cost);
    final budget = 1000.0; // Example budget
    final progress = totalCost / budget;

    return Container(
      color: const Color(0xFF181A20),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        children: [
          // Budget Summary Card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFBFFF2A), // vibrant lime
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.08 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFFB7A6FF), // purple
                  ),
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% of budget used (24${totalCost.toStringAsFixed(2)} / 24${budget.toStringAsFixed(2)})',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
          // Timeline Events
          ...events.map((event) {
            return Container(
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
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7A6FF), // purple
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.event,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${event.location} • ${event.time} • 24${event.cost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _navigateToEventDetails(event.id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFFF2A), // lime
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuggestionsTab() {
    return Container(
      color: const Color(0xFF181A20),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // AI Nearby Suggestions
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
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFFB7A6FF)),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Nearby Suggestions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...List.generate(3, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7A6FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.place, color: Colors.black),
                      ),
                      title: Text(
                        'Suggestion ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: const Text(
                        'Distance • Rating',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: const Icon(Icons.add, color: Colors.black),
                      onTap: () => _addToTimeline(index + 1),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesTab() {
    return Container(
      color: const Color(0xFF181A20),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(6, 8, 6, 6),
            child: Text(
              'Pre-made Itineraries',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // First card: full width
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: _packageCard(index: 0),
          ),
          // Next two cards: side by side
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Row(
              children: [
                Expanded(child: _packageCard(index: 1)),
                const SizedBox(width: 6),
                Expanded(child: _packageCard(index: 2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _packageCard({required int index}) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              color: const Color(0xFFB7A6FF), // purple image bg
              height: 100,
              width: double.infinity,
              child: const Center(
                child: Icon(Icons.image, size: 48, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Package ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Duration • Price',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _viewPackageDetails(index + 1),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
