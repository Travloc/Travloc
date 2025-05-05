import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/shared_filter_widgets.dart';

final travelBuddiesFiltersProvider =
    StateNotifierProvider<TravelBuddiesFilters, Map<String, dynamic>>((ref) {
      return TravelBuddiesFilters();
    });

class TravelBuddiesFilters extends StateNotifier<Map<String, dynamic>> {
  TravelBuddiesFilters()
    : super({
        'searchQuery': '',
        'travelDates': null, // Placeholder for date range or similar
        'interests': <String>{},
        'languages': <String>{},
      });

  void updateSearchQuery(String query) {
    state = {...state, 'searchQuery': query};
  }

  // Add methods for updating travelDates, interests, languages as needed
}

class TravelBuddiesScreen extends ConsumerStatefulWidget {
  const TravelBuddiesScreen({super.key});

  @override
  ConsumerState<TravelBuddiesScreen> createState() =>
      _TravelBuddiesScreenState();
}

class _TravelBuddiesScreenState extends ConsumerState<TravelBuddiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<bool> _favorites = List.generate(10, (_) => false);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF181A20),
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: SharedSearchBar(
                  controller: _searchController,
                  hintText: 'Search travel buddies...',
                  onChanged: (value) {
                    ref
                        .read(travelBuddiesFiltersProvider.notifier)
                        .updateSearchQuery(value);
                  },
                  backgroundColor: Colors.white,
                  iconColor: Colors.black54,
                  borderRadius: 16,
                ),
              ),
              // Buddy List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 10, // Placeholder count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                      child: _buildBuddyCard(context, index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Floating Filter Button
        Positioned(
          bottom: 70, // Adjust as needed to be above the selection tab
          right: 24,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFB7A6FF),
            foregroundColor: Colors.black,
            onPressed: () => _showFilterDialog(context),
            child: const Icon(Icons.filter_list),
          ),
        ),
      ],
    );
  }

  Widget _buildBuddyCard(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDFF), // pastel purple
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => Navigator.pushNamed(context, '/buddies/${index + 1}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFD1C4E9),
                child: const Text('🧑‍🤝‍🧑', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              // Main Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Travel Buddy Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            _favorites[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                _favorites[index] ? Colors.red : Colors.black26,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _favorites[index] = !_favorites[index];
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Barcelona, Spain',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Interested in adventure tours and cultural experiences.',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 13,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Available: June 2024',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Connect button
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 2),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(70, 32),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed:
                      () => Navigator.pushNamed(
                        context,
                        '/buddies/${index + 1}/connect',
                      ),
                  child: const Text('Connect', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => SharedFilterDialog(
            title: 'Filter Buddies',
            filterOptions: [
              ListTile(
                title: const Text('Travel Dates'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Implement date filter
                },
              ),
              ListTile(
                title: const Text('Interests'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Implement interests filter
                },
              ),
              ListTile(
                title: const Text('Languages'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Implement languages filter
                },
              ),
            ],
            onApply: () => Navigator.pop(context),
          ),
    );
  }
}
