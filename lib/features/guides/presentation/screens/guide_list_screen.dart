import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final guideFiltersProvider = StateNotifierProvider<GuideFilters, Map<String, dynamic>>((ref) {
  return GuideFilters();
});

class GuideFilters extends StateNotifier<Map<String, dynamic>> {
  GuideFilters() : super({
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
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Adventure', 'Cultural', 'Food', 'Nature'];
  final List<bool> _favorites = List.generate(10, (_) => false);
  final List<String> _availableLanguages = ['English', 'Spanish', 'French', 'German', 'Italian', 'Chinese', 'Japanese'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showPriceRangePicker() {
    final filters = ref.read(guideFiltersProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Price Range'),
        content: RangeSlider(
          values: filters['priceRange'] as RangeValues,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '\$${filters['priceRange'].start.round()}',
            '\$${filters['priceRange'].end.round()}',
          ),
          onChanged: (RangeValues values) {
            ref.read(guideFiltersProvider.notifier).updatePriceRange(values);
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
    final filters = ref.read(guideFiltersProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Minimum Rating'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: filters['minRating'] as double,
              min: 0,
              max: 5,
              divisions: 10,
              label: '${filters['minRating']} stars',
              onChanged: (double value) {
                ref.read(guideFiltersProvider.notifier).updateRating(value);
              },
            ),
            Text('${filters['minRating']} stars'),
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
    final filters = ref.read(guideFiltersProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Languages'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _availableLanguages.map((language) {
              return CheckboxListTile(
                title: Text(language),
                value: (filters['languages'] as Set<String>).contains(language),
                onChanged: (bool? value) {
                  ref.read(guideFiltersProvider.notifier).toggleLanguage(language);
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Guides'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Range
            ListTile(
              title: const Text('Price Range'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                _showPriceRangePicker();
              },
            ),
            // Rating
            ListTile(
              title: const Text('Rating'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                _showRatingFilter();
              },
            ),
            // Languages
            ListTile(
              title: const Text('Languages'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                _showLanguageFilter();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Apply filters and refresh the guide list
              ref.read(guideFiltersProvider.notifier).updateSearchQuery(_searchController.text);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guides'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search guides...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                ref.read(guideFiltersProvider.notifier).updateSearchQuery(value);
              },
            ),
          ),
          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          // Guide List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Placeholder count
              itemBuilder: (context, index) {
                return _buildGuideCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/guides/${index + 1}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guide Name',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.8 (120 reviews)',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _favorites[index] ? Icons.favorite : Icons.favorite_border,
                      color: _favorites[index] ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        _favorites[index] = !_favorites[index];
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Specializes in adventure tours and cultural experiences. Fluent in English and Spanish.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Barcelona, Spain',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => context.push('/guides/${index + 1}/book'),
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 