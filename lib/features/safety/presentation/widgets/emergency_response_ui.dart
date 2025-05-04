import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';

class EmergencyResponseUI extends StatefulWidget {
  final Function(Position) onLocationShare;
  final Function() onEmergencyCall;
  final Function() onContactNotification;
  final List<String> emergencyContacts;

  const EmergencyResponseUI({
    super.key,
    required this.onLocationShare,
    required this.onEmergencyCall,
    required this.onContactNotification,
    required this.emergencyContacts,
  });

  @override
  State<EmergencyResponseUI> createState() => _EmergencyResponseUIState();
}

class _EmergencyResponseUIState extends State<EmergencyResponseUI> {
  bool _isExpanded = false;
  bool _isSharing = false;
  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );
      setState(() => _currentPosition = position);
      widget.onLocationShare(position);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }

  void _toggleLocationSharing() {
    setState(() => _isSharing = !_isSharing);
    if (_isSharing) {
      _getCurrentPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isExpanded ? 300 : 100,
        child: Column(
          children: [
            // SOS Button
            ListTile(
              leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                      ),
                      onPressed: widget.onEmergencyCall,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 1000.ms,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
              title: const Text('Emergency SOS'),
              subtitle: const Text('Tap for immediate assistance'),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
              ),
            ),

            // Expanded Section
            if (_isExpanded) ...[
              const Divider(),

              // Location Sharing
              ListTile(
                leading: Icon(
                  _isSharing ? Icons.location_on : Icons.location_off,
                  color: _isSharing ? Colors.green : Colors.grey,
                ),
                title: const Text('Share Location'),
                subtitle: Text(
                  _currentPosition != null
                      ? 'Lat: ${_currentPosition!.latitude}, Long: ${_currentPosition!.longitude}'
                      : 'Not sharing location',
                ),
                trailing: Switch(
                  value: _isSharing,
                  onChanged: (value) => _toggleLocationSharing(),
                ),
              ),

              // Emergency Contacts
              Expanded(
                child: ListView.builder(
                  itemCount: widget.emergencyContacts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.contact_phone),
                      title: Text(widget.emergencyContacts[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.notifications_active),
                        onPressed: widget.onContactNotification,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
