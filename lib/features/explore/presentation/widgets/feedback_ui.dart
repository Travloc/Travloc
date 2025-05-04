import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FeedbackUI extends StatefulWidget {
  final String title;
  final String description;
  final double rating;
  final Function(double) onRatingChanged;
  final Function(String) onCommentSubmitted;
  final List<String> tags;
  final Function(List<String>) onTagsChanged;

  const FeedbackUI({
    super.key,
    required this.title,
    required this.description,
    required this.rating,
    required this.onRatingChanged,
    required this.onCommentSubmitted,
    required this.tags,
    required this.onTagsChanged,
  });

  @override
  State<FeedbackUI> createState() => _FeedbackUIState();
}

class _FeedbackUIState extends State<FeedbackUI> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _availableTags = [
    'Helpful',
    'Accurate',
    'Fast',
    'User-friendly',
    'Detailed',
    'Creative',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Rating Section
            Row(
              children: [
                const Text('Rating:'),
                const SizedBox(width: 8),
                ...List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < widget.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => widget.onRatingChanged(index + 1.0),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Tags Section
            Wrap(
              spacing: 8,
              children:
                  _availableTags.map((tag) {
                    final isSelected = widget.tags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        final newTags = List<String>.from(widget.tags);
                        if (selected) {
                          newTags.add(tag);
                        } else {
                          newTags.remove(tag);
                        }
                        widget.onTagsChanged(newTags);
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Comment Section
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Additional Comments',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                widget.onCommentSubmitted(_commentController.text);
                _commentController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Feedback submitted successfully!'),
                  ),
                );
              },
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0);
  }
}
