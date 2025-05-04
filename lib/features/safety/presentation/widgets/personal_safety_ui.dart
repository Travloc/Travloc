import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SafetyStatus {
  final double trustScore;
  final bool isVerified;
  final List<String> verifiedItems;
  final List<String> pendingItems;
  final List<String> safetyGuidelines;

  const SafetyStatus({
    required this.trustScore,
    required this.isVerified,
    required this.verifiedItems,
    required this.pendingItems,
    required this.safetyGuidelines,
  });
}

class PersonalSafetyUI extends StatelessWidget {
  final SafetyStatus status;
  final VoidCallback onVerificationRequest;
  final Function(String) onGuidelineAction;

  const PersonalSafetyUI({
    super.key,
    required this.status,
    required this.onVerificationRequest,
    required this.onGuidelineAction,
  });

  Color _getTrustScoreColor(double score) {
    if (score >= 4.0) return Colors.green;
    if (score >= 3.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trust Score Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getTrustScoreColor(
                status.trustScore,
              ).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getTrustScoreColor(status.trustScore),
                      ),
                      child: Center(
                        child: Text(
                          status.trustScore.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.easeOut)
                    .then()
                    .shimmer(duration: 1000.ms),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trust Score',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        status.isVerified
                            ? 'Verified Account'
                            : 'Verification Pending',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              status.isVerified ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Verification Status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                // Verified Items
                ...status.verifiedItems.map(
                  (item) => ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text(item),
                    dense: true,
                  ),
                ),
                // Pending Items
                ...status.pendingItems.map(
                  (item) => ListTile(
                    leading: const Icon(Icons.pending, color: Colors.orange),
                    title: Text(item),
                    trailing: TextButton(
                      onPressed: onVerificationRequest,
                      child: const Text('Verify'),
                    ),
                    dense: true,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Safety Guidelines
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Guidelines',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...status.safetyGuidelines.map(
                  (guideline) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(guideline),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => onGuidelineAction(guideline),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
