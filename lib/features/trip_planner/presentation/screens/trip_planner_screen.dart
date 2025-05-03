import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'event_details_screen.dart';
import 'package_details_screen.dart';

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
final timelineProvider = StateNotifierProvider<TimelineNotifier, List<Event>>((ref) {
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

class _TripPlannerScreenState extends ConsumerState<TripPlannerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Timeline', 'Suggestions', 'Packages'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
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
        // Tab Bar
        TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
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
      ],
    );
  }

  Widget _buildTimelineTab() {
    final events = ref.watch(timelineProvider);
    final totalCost = events.fold(0.0, (sum, event) => sum + event.cost);
    final budget = 1000.0; // Example budget
    final progress = totalCost / budget;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Budget Summary Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress > 0.8 ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% of budget used (\$${totalCost.toStringAsFixed(2)} / \$${budget.toStringAsFixed(2)})',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Timeline Events
        ...events.map((event) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.event),
              ),
              title: Text(event.title),
              subtitle: Text('${event.location} • ${event.time} • \$${event.cost.toStringAsFixed(2)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _navigateToEventDetails(event.id),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSuggestionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AI Nearby Suggestions
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Nearby Suggestions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...List.generate(3, (index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.place),
                    ),
                    title: Text('Suggestion ${index + 1}'),
                    subtitle: const Text('Distance • Rating'),
                    trailing: const Icon(Icons.add),
                    onTap: () => _addToTimeline(index + 1),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPackagesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Pre-made Itineraries
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pre-made Itineraries',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(3, (index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image, size: 48),
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
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('Duration • Price'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _viewPackageDetails(index + 1),
                                child: const Text('View Details'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 