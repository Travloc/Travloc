import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TrustScoreCard extends StatelessWidget {
  final double score;
  final List<String> trustFactors;
  final Map<String, double> factorScores;

  const TrustScoreCard({
    super.key,
    required this.score,
    required this.trustFactors,
    required this.factorScores,
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
            Text(
              'Trust Score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: score,
                      backgroundColor: Colors.grey[200],
                      strokeWidth: 12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getScoreColor(score),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(score * 100).toInt()}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(score),
                        ),
                      ),
                      Text(
                        'Trust Score',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Trust Factors',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...trustFactors.map((factor) => _buildTrustFactorItem(
              context,
              factor,
              factorScores[factor] ?? 0.0,
            )),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildTrustFactorItem(
    BuildContext context,
    String factor,
    double factorScore,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                factor,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${(factorScore * 100).toInt()}%',
                style: TextStyle(
                  color: _getScoreColor(factorScore),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: factorScore,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getScoreColor(factorScore),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
  }

  Color _getScoreColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.lightGreen;
    if (score >= 0.4) return Colors.orange;
    if (score >= 0.2) return Colors.deepOrange;
    return Colors.red;
  }
} 