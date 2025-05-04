import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GuideVerification {
  final bool isVerified;
  final bool hasBackgroundCheck;
  final bool hasInsurance;
  final bool hasSafetyTraining;
  final List<String> certifications;
  final List<String> equipmentChecklist;
  final List<String> emergencyProtocols;

  const GuideVerification({
    required this.isVerified,
    required this.hasBackgroundCheck,
    required this.hasInsurance,
    required this.hasSafetyTraining,
    required this.certifications,
    required this.equipmentChecklist,
    required this.emergencyProtocols,
  });
}

class GuideSafetyUI extends StatefulWidget {
  final GuideVerification verification;
  final VoidCallback onVerificationRequest;
  final VoidCallback onEquipmentCheck;
  final Function(String) onProtocolAction;

  const GuideSafetyUI({
    super.key,
    required this.verification,
    required this.onVerificationRequest,
    required this.onEquipmentCheck,
    required this.onProtocolAction,
  });

  @override
  State<GuideSafetyUI> createState() => _GuideSafetyUIState();
}

class _GuideSafetyUIState extends State<GuideSafetyUI> {
  bool _showEquipmentList = false;
  bool _showProtocols = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verification Status Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  widget.verification.isVerified
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                      widget.verification.isVerified
                          ? Icons.verified_user
                          : Icons.pending,
                      color:
                          widget.verification.isVerified
                              ? Colors.green
                              : Colors.orange,
                      size: 32,
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 2000.ms),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guide Verification Status',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        widget.verification.isVerified
                            ? 'Fully Verified Guide'
                            : 'Verification In Progress',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              widget.verification.isVerified
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.verification.isVerified)
                  TextButton(
                    onPressed: widget.onVerificationRequest,
                    child: const Text('Complete Verification'),
                  ),
              ],
            ),
          ),

          // Verification Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVerificationItem(
                  'Background Check',
                  widget.verification.hasBackgroundCheck,
                ),
                _buildVerificationItem(
                  'Insurance Coverage',
                  widget.verification.hasInsurance,
                ),
                _buildVerificationItem(
                  'Safety Training',
                  widget.verification.hasSafetyTraining,
                ),
              ],
            ),
          ),

          const Divider(),

          // Certifications
          if (widget.verification.certifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Certifications',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        widget.verification.certifications
                            .map(
                              (cert) => Chip(
                                avatar: const Icon(Icons.verified, size: 18),
                                label: Text(cert),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

          // Equipment Checklist
          ListTile(
            title: const Text('Equipment Checklist'),
            trailing: IconButton(
              icon: Icon(
                _showEquipmentList ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed:
                  () =>
                      setState(() => _showEquipmentList = !_showEquipmentList),
            ),
          ),
          if (_showEquipmentList)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ...widget.verification.equipmentChecklist.map(
                    (item) => CheckboxListTile(
                      value: true,
                      onChanged: null,
                      title: Text(item),
                      dense: true,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Equipment Check'),
                    onPressed: widget.onEquipmentCheck,
                  ),
                ],
              ),
            ),

          // Emergency Protocols
          ListTile(
            title: const Text('Emergency Protocols'),
            trailing: IconButton(
              icon: Icon(
                _showProtocols ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () => setState(() => _showProtocols = !_showProtocols),
            ),
          ),
          if (_showProtocols)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children:
                    widget.verification.emergencyProtocols
                        .map(
                          (protocol) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(protocol),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed:
                                    () => widget.onProtocolAction(protocol),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerificationItem(String title, bool isVerified) {
    return ListTile(
      leading: Icon(
        isVerified ? Icons.check_circle : Icons.pending,
        color: isVerified ? Colors.green : Colors.orange,
      ),
      title: Text(title),
      trailing:
          isVerified
              ? const Text('Verified', style: TextStyle(color: Colors.green))
              : TextButton(
                onPressed: widget.onVerificationRequest,
                child: const Text('Verify'),
              ),
      dense: true,
    );
  }
}
