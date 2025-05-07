import 'package:flutter/material.dart';

class InterestSelection extends StatelessWidget {
  final List<String> selectedInterests;
  final Function(String) onInterestSelected;
  final Function(BuildContext, List<Map<String, dynamic>>)
  onShowAdditionalInterests;

  const InterestSelection({
    super.key,
    required this.selectedInterests,
    required this.onInterestSelected,
    required this.onShowAdditionalInterests,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> interests = [
      {'icon': Icons.hiking, 'name': 'Adventure'},
      {'icon': Icons.explore, 'name': 'Exploration'},
      {'icon': Icons.landscape, 'name': 'Scenery'},
      {'icon': Icons.park, 'name': 'Nature'},
      {'icon': Icons.directions_walk, 'name': 'Trekking'},
      {'icon': Icons.museum, 'name': 'Cultural'},
      {'icon': Icons.restaurant, 'name': 'Food'},
      {'icon': Icons.shopping_bag, 'name': 'Shopping'},
    ];

    final List<Map<String, dynamic>> additionalInterests = [
      {'icon': Icons.beach_access, 'name': 'Beach'},
      {'icon': Icons.sports_basketball, 'name': 'Sports'},
      {'icon': Icons.local_bar, 'name': 'Nightlife'},
      {'icon': Icons.history_edu, 'name': 'History'},
      {'icon': Icons.architecture, 'name': 'Architecture'},
      {'icon': Icons.music_note, 'name': 'Music'},
      {'icon': Icons.photo_camera, 'name': 'Photography'},
      {'icon': Icons.spa, 'name': 'Wellness'},
      {'icon': Icons.family_restroom, 'name': 'Family'},
      {'icon': Icons.emoji_events, 'name': 'Events'},
      {'icon': Icons.local_airport, 'name': 'Air Travel'},
      {'icon': Icons.directions_car, 'name': 'Road Trips'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Interests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: interests.length + 1,
          itemBuilder: (context, index) {
            if (index == interests.length) {
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap:
                      () => onShowAdditionalInterests(
                        context,
                        additionalInterests,
                      ),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF2196F3),
                          size: 24,
                        ),
                        if (selectedInterests.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${selectedInterests.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }

            final interest = interests[index];
            final isSelected = selectedInterests.contains(interest['name']);

            return Material(
              color: isSelected ? const Color(0xFF2196F3) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => onInterestSelected(interest['name']!),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF2196F3)
                              : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        interest['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.black87,
                        size: 20,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        interest['name']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 11,
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
      ],
    );
  }
}
