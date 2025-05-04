import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/accessibility_service.dart';

class AccessibilitySettingsUI extends StatefulWidget {
  final AccessibilityService accessibilityService;

  const AccessibilitySettingsUI({
    super.key,
    required this.accessibilityService,
  });

  @override
  State<AccessibilitySettingsUI> createState() =>
      _AccessibilitySettingsUIState();
}

class _AccessibilitySettingsUIState extends State<AccessibilitySettingsUI> {
  bool _isHighContrastMode = false;
  bool _isScreenReaderEnabled = false;
  double _textScaleFactor = 1.0;
  bool _isVoiceCommandsEnabled = false;
  bool _isGestureAlternativesEnabled = false;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _isHighContrastMode = widget.accessibilityService.isHighContrastMode;
      _isScreenReaderEnabled =
          widget.accessibilityService.isScreenReaderEnabled;
      _textScaleFactor = widget.accessibilityService.textScaleFactor;
      _isVoiceCommandsEnabled =
          widget.accessibilityService.isVoiceCommandsEnabled;
      _isGestureAlternativesEnabled =
          widget.accessibilityService.isGestureAlternativesEnabled;
      _currentLanguage = widget.accessibilityService.currentLanguage;
    });
  }

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
              children: [
                const Icon(Icons.accessibility_new, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: const Duration(seconds: 2)),
                const SizedBox(width: 8),
                Text(
                  'Accessibility Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('High Contrast Mode'),
              subtitle: const Text(
                'Enhance visibility with high contrast colors',
              ),
              value: _isHighContrastMode,
              onChanged: (value) {
                setState(() {
                  _isHighContrastMode = value;
                });
                widget.accessibilityService.setHighContrastMode(value);
              },
            ),
            SwitchListTile(
              title: const Text('Screen Reader'),
              subtitle: const Text('Enable screen reader support'),
              value: _isScreenReaderEnabled,
              onChanged: (value) {
                setState(() {
                  _isScreenReaderEnabled = value;
                });
                widget.accessibilityService.setScreenReaderEnabled(value);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Text Size'),
              subtitle: Slider(
                value: _textScaleFactor,
                min: 0.8,
                max: 2.0,
                divisions: 12,
                label: '${(_textScaleFactor * 100).round()}%',
                onChanged: (value) {
                  setState(() {
                    _textScaleFactor = value;
                  });
                  widget.accessibilityService.setTextScaleFactor(value);
                },
              ),
            ),
            SwitchListTile(
              title: const Text('Voice Commands'),
              subtitle: const Text('Enable voice command support'),
              value: _isVoiceCommandsEnabled,
              onChanged: (value) {
                setState(() {
                  _isVoiceCommandsEnabled = value;
                });
                widget.accessibilityService.setVoiceCommandsEnabled(value);
              },
            ),
            SwitchListTile(
              title: const Text('Gesture Alternatives'),
              subtitle: const Text('Provide alternative input methods'),
              value: _isGestureAlternativesEnabled,
              onChanged: (value) {
                setState(() {
                  _isGestureAlternativesEnabled = value;
                });
                widget.accessibilityService.setGestureAlternativesEnabled(
                  value,
                );
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              value: _currentLanguage,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'es', child: Text('Spanish')),
                DropdownMenuItem(value: 'fr', child: Text('French')),
                DropdownMenuItem(value: 'de', child: Text('German')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentLanguage = value;
                  });
                  widget.accessibilityService.setLanguage(value);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Test accessibility features
                widget.accessibilityService.speak(
                  'Testing accessibility features',
                );
                widget.accessibilityService.provideHapticFeedback();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Testing accessibility features'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.accessibility),
              label: const Text('Test Accessibility'),
            ),
          ],
        ),
      ),
    );
  }
}
