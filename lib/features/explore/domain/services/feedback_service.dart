import 'package:flutter/foundation.dart';
import 'api_service.dart';

class FeedbackService {
  final ApiService _apiService;

  FeedbackService({required ApiService apiService}) : _apiService = apiService;

  Future<void> submitFeedback({
    required String feature,
    required double rating,
    required List<String> tags,
    required String comment,
  }) async {
    try {
      await _apiService.post('feedback', {
        'feature': feature,
        'rating': rating,
        'tags': tags,
        'comment': comment,
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print('Feedback submitted successfully:');
        print('Feature: $feature');
        print('Rating: $rating');
        print('Tags: $tags');
        print('Comment: $comment');
      }
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }
}
