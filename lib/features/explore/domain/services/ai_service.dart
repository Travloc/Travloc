import 'package:travloc/features/explore/domain/models/trip_plan.dart';
import 'package:travloc/features/explore/domain/models/guide_list.dart';
import 'package:travloc/features/explore/domain/models/attraction_list.dart';
import 'api_service.dart';

class AIService {
  final ApiService _apiService;

  AIService({required ApiService apiService}) : _apiService = apiService;

  Future<dynamic> processVoiceInput(String input) async {
    try {
      final response = await _apiService.post('ai/process-voice', {
        'input': input,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Parse the response based on the type of request
      if (response['type'] == 'trip_plan') {
        return TripPlan.fromJson(response['data']);
      } else if (response['type'] == 'guide_list') {
        return GuideList.fromJson(response['data']);
      } else if (response['type'] == 'attraction_list') {
        return AttractionList.fromJson(response['data']);
      }

      throw Exception('Unknown response type: ${response['type']}');
    } catch (e) {
      // Fallback to mock implementation if API fails
      return _fallbackToMockImplementation(input);
    }
  }

  // Keep the mock implementation as fallback
  dynamic _fallbackToMockImplementation(String input) {
    final normalizedInput = input.toLowerCase().trim();

    if (normalizedInput.contains('plan a trip')) {
      final destination = _extractDestination(normalizedInput);
      return _generateTripPlan(destination);
    } else if (normalizedInput.contains('find guides')) {
      final location = _extractLocation(normalizedInput);
      return _generateGuideList(location);
    } else if (normalizedInput.contains('show me attractions') ||
        normalizedInput.contains('what to see') ||
        normalizedInput.contains('places to visit')) {
      final location = _extractLocation(normalizedInput);
      return _generateAttractionList(location);
    }

    throw Exception('Could not understand the request. Please try rephrasing.');
  }

  String _extractDestination(String input) {
    // Simple extraction logic - can be enhanced with NLP
    final parts = input.split('plan a trip to');
    if (parts.length > 1) {
      return parts[1].trim();
    }
    return 'Paris'; // Default destination
  }

  String _extractLocation(String input) {
    // Simple extraction logic - can be enhanced with NLP
    if (input.contains('in')) {
      final parts = input.split('in');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    return 'Tokyo'; // Default location
  }

  TripPlan _generateTripPlan(String destination) {
    return TripPlan(
      destination: destination,
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 37)),
      activities: _getActivitiesForDestination(destination),
      accommodations: _getAccommodationsForDestination(destination),
      estimatedCost: _calculateEstimatedCost(destination),
    );
  }

  GuideList _generateGuideList(String location) {
    return GuideList(
      location: location,
      guides: _getGuidesForLocation(location),
    );
  }

  AttractionList _generateAttractionList(String location) {
    return AttractionList(
      location: location,
      attractions: _getAttractionsForLocation(location),
    );
  }

  List<String> _getActivitiesForDestination(String destination) {
    // Mock data - can be replaced with actual data from a database
    final activities = {
      'paris': [
        'Eiffel Tower',
        'Louvre Museum',
        'Notre-Dame',
        'Champs-Élysées',
      ],
      'tokyo': [
        'Shibuya Crossing',
        'Senso-ji Temple',
        'Meiji Shrine',
        'Akihabara',
      ],
      'new york': [
        'Statue of Liberty',
        'Central Park',
        'Times Square',
        'Empire State Building',
      ],
    };
    return activities[destination.toLowerCase()] ??
        ['Local attractions', 'Cultural experiences'];
  }

  List<String> _getAccommodationsForDestination(String destination) {
    // Mock data - can be replaced with actual data from a database
    final accommodations = {
      'paris': ['Hotel Paris', 'Airbnb Montmartre', 'Boutique Hotel Marais'],
      'tokyo': [
        'Traditional Ryokan',
        'Business Hotel Shinjuku',
        'Capsule Hotel',
      ],
      'new york': [
        'Times Square Hotel',
        'Brooklyn Loft',
        'Manhattan Apartment',
      ],
    };
    return accommodations[destination.toLowerCase()] ??
        ['Local hotels', 'Vacation rentals'];
  }

  double _calculateEstimatedCost(String destination) {
    // Mock cost calculation - can be replaced with actual pricing data
    final costs = {'paris': 1500.0, 'tokyo': 2000.0, 'new york': 1800.0};
    return costs[destination.toLowerCase()] ?? 1500.0;
  }

  List<Guide> _getGuidesForLocation(String location) {
    // Mock data - can be replaced with actual data from a database
    final guides = {
      'tokyo': [
        Guide(
          id: '1',
          name: 'Yuki Tanaka',
          photoUrl: 'https://example.com/yuki.jpg',
          rating: 4.8,
          reviewCount: 150,
          languages: ['Japanese', 'English'],
          specializations: ['History', 'Food'],
        ),
        Guide(
          id: '2',
          name: 'Hiroshi Sato',
          photoUrl: 'https://example.com/hiroshi.jpg',
          rating: 4.9,
          reviewCount: 200,
          languages: ['Japanese', 'English', 'Chinese'],
          specializations: ['Art', 'Architecture'],
        ),
      ],
    };
    return guides[location.toLowerCase()] ??
        [
          Guide(
            id: '1',
            name: 'Local Guide',
            photoUrl: 'https://example.com/guide.jpg',
            rating: 4.5,
            reviewCount: 100,
            languages: ['English'],
            specializations: ['General'],
          ),
        ];
  }

  List<Attraction> _getAttractionsForLocation(String location) {
    // Mock data - can be replaced with actual data from a database
    final attractions = {
      'new york': [
        Attraction(
          id: '1',
          name: 'Statue of Liberty',
          photoUrl: 'https://example.com/statue.jpg',
          rating: 4.7,
          reviewCount: 5000,
          category: 'Landmark',
          description: 'Iconic symbol of freedom',
          latitude: 40.6892,
          longitude: -74.0445,
        ),
        Attraction(
          id: '2',
          name: 'Central Park',
          photoUrl: 'https://example.com/park.jpg',
          rating: 4.8,
          reviewCount: 4500,
          category: 'Park',
          description: 'Urban oasis in the heart of Manhattan',
          latitude: 40.7829,
          longitude: -73.9654,
        ),
      ],
    };
    return attractions[location.toLowerCase()] ??
        [
          Attraction(
            id: '1',
            name: 'Local Attraction',
            photoUrl: 'https://example.com/attraction.jpg',
            rating: 4.5,
            reviewCount: 100,
            category: 'General',
            description: 'Popular local attraction',
            latitude: 0.0,
            longitude: 0.0,
          ),
        ];
  }
}
