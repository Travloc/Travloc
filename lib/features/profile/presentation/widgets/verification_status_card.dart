import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VerificationStatusCard extends StatelessWidget {
  final String status;
  final double progress;
  final List<String> requiredDocuments;
  final List<String> uploadedDocuments;
  final Function(String) onUploadDocument;
  final bool isUploading;

  const VerificationStatusCard({
    super.key,
    required this.status,
    required this.progress,
    required this.requiredDocuments,
    required this.uploadedDocuments,
    required this.onUploadDocument,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Verification Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                _buildStatusBadge(context),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(progress),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Required Documents',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...requiredDocuments.map((doc) => _buildDocumentItem(
              context,
              doc,
              uploadedDocuments.contains(doc),
            )),
            if (isUploading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color badgeColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'verified':
        badgeColor = Colors.green;
        statusText = 'Verified';
        break;
      case 'pending':
        badgeColor = Colors.orange;
        statusText = 'Pending';
        break;
      case 'rejected':
        badgeColor = Colors.red;
        statusText = 'Rejected';
        break;
      default:
        badgeColor = Colors.grey;
        statusText = 'Not Started';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDocumentItem(
    BuildContext context,
    String document,
    bool isUploaded,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          isUploaded ? Icons.check_circle : Icons.upload_file,
          color: isUploaded ? Colors.green : Colors.grey,
        ),
        title: Text(document),
        trailing: isUploaded
            ? const Icon(Icons.check, color: Colors.green)
            : TextButton(
                onPressed: () => onUploadDocument(document),
                child: const Text('Upload'),
              ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.4) return Colors.orange;
    return Colors.red;
  }
} 