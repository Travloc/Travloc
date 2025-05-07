import 'package:flutter/material.dart';

class LocationSearch extends StatelessWidget {
  final TextEditingController locationController;
  final List<Map<String, dynamic>> locations;
  final bool showLocationsList;
  final Function(String) onAddLocation;
  final Function(int) onRemoveLocation;
  final Function(int) onEditLocationDates;
  final Function(int, int) onReorderLocations;
  final Function(bool) onToggleLocationsList;

  const LocationSearch({
    super.key,
    required this.locationController,
    required this.locations,
    required this.showLocationsList,
    required this.onAddLocation,
    required this.onRemoveLocation,
    required this.onEditLocationDates,
    required this.onReorderLocations,
    required this.onToggleLocationsList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Where do you want to go?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: 'Search locations...',
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: onAddLocation,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Color(0xFF2196F3),
                size: 32,
              ),
              onPressed: () => onAddLocation(locationController.text),
              tooltip: 'Add location',
            ),
            IconButton(
              icon: Icon(
                showLocationsList ? Icons.list_alt : Icons.list,
                color: Colors.black54,
              ),
              onPressed: () => onToggleLocationsList(!showLocationsList),
              tooltip: showLocationsList ? 'Hide list' : 'Show list',
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (showLocationsList && locations.isNotEmpty)
          SizedBox(
            height: 64.0 * locations.length.clamp(1, 3),
            child: ReorderableListView(
              onReorder: onReorderLocations,
              buildDefaultDragHandles: false,
              children: [
                for (int i = 0; i < locations.length; i++)
                  Card(
                    key: ValueKey(
                      locations[i]['name'] + locations[i]['start'].toString(),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: ReorderableDragStartListener(
                        index: i,
                        child: const Icon(Icons.drag_handle),
                      ),
                      title: Text(
                        locations[i]['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: GestureDetector(
                        onTap: () => onEditLocationDates(i),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${locations[i]['start'].month}/${locations[i]['start'].day} - ${locations[i]['end'].month}/${locations[i]['end'].day}',
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '(edit)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => onRemoveLocation(i),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
