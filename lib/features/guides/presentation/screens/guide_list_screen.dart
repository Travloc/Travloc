import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared_filter_widgets.dart';

final guideFiltersProvider =
    StateNotifierProvider<GuideFilters, Map<String, dynamic>>((ref) {
      return GuideFilters();
    });

class GuideFilters extends StateNotifier<Map<String, dynamic>> {
  GuideFilters()
    : super({
        'priceRange': const RangeValues(0, 1000),
        'minRating': 0.0,
        'languages': <String>{},
        'searchQuery': '',
      });

  void updatePriceRange(RangeValues range) {
    state = {...state, 'priceRange': range};
  }

  void updateRating(double rating) {
    state = {...state, 'minRating': rating};
  }

  void toggleLanguage(String language) {
    final languages = Set<String>.from(state['languages'] as Set<String>);
    if (languages.contains(language)) {
      languages.remove(language);
    } else {
      languages.add(language);
    }
    state = {...state, 'languages': languages};
  }

  void updateSearchQuery(String query) {
    state = {...state, 'searchQuery': query};
  }
}

class GuideListScreen extends ConsumerStatefulWidget {
  const GuideListScreen({super.key});

  @override
  ConsumerState<GuideListScreen> createState() => _GuideListScreenState();
}

class _GuideListScreenState extends ConsumerState<GuideListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<bool> _favorites = List.generate(10, (_) => false);
  final List<String> _availableLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Chinese',
    'Japanese',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showPriceRangePicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Price Range'),
            content: RangeSlider(
              values:
                  ref.read(guideFiltersProvider)['priceRange'] as RangeValues,
              min: 0,
              max: 1000,
              divisions: 20,
              labels: RangeLabels(
                '\$${ref.read(guideFiltersProvider)['priceRange'].start.round()}',
                '\$${ref.read(guideFiltersProvider)['priceRange'].end.round()}',
              ),
              onChanged: (RangeValues values) {
                ref
                    .read(guideFiltersProvider.notifier)
                    .updatePriceRange(values);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  void _showRatingFilter() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Minimum Rating'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: ref.read(guideFiltersProvider)['minRating'] as double,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: '${ref.read(guideFiltersProvider)['minRating']} stars',
                  onChanged: (double value) {
                    ref.read(guideFiltersProvider.notifier).updateRating(value);
                  },
                ),
                Text('${ref.read(guideFiltersProvider)['minRating']} stars'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  void _showLanguageFilter() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Languages'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    _availableLanguages.map((language) {
                      return CheckboxListTile(
                        title: Text(language),
                        value: (ref.read(guideFiltersProvider)['languages']
                                as Set<String>)
                            .contains(language),
                        onChanged: (bool? value) {
                          ref
                              .read(guideFiltersProvider.notifier)
                              .toggleLanguage(language);
                        },
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFF181A20),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: SharedSearchBar(
                  controller: _searchController,
                  hintText: 'Search guides...',
                  onChanged: (value) {
                    ref
                        .read(guideFiltersProvider.notifier)
                        .updateSearchQuery(value);
                  },
                  backgroundColor: Colors.white,
                  iconColor: Colors.black54,
                  borderRadius: 16,
                ),
              ),
              // Guide List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 10, // Placeholder count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                      child: _buildGuideCard(context, index),
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => SharedFilterDialog(
            title: 'Filter Guides',
            filterOptions: [
              ListTile(
                title: const Text('Price Range'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showPriceRangePicker();
                },
              ),
              ListTile(
                title: const Text('Rating'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showRatingFilter();
                },
              ),
              ListTile(
                title: const Text('Languages'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showLanguageFilter();
                },
              ),
            ],
            onApply: () => Navigator.pop(context),
          ),
    );
  }

  Widget _buildGuideCard(BuildContext context, int index) {
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
        onTap: () => context.push('/guides/${index + 1}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFD1C4E9),
                child: const Text('🧑‍🎤', style: TextStyle(fontSize: 24)),
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
                            'Guide Name',
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
                        const Icon(Icons.star, size: 15, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          '4.8',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '(120)',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Specializes in adventure tours and cultural experiences.',
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
                          Icons.location_on,
                          size: 13,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Barcelona, Spain',
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
              // Book button
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 2),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(56, 32),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => context.push('/guides/${index + 1}/book'),
                  child: const Text('Book', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
