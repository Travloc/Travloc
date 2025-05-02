import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travloc/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TravlocApp(),
    ),
  );
}

class TravlocApp extends StatelessWidget {
  const TravlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travloc',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Travloc'),
        ),
      ),
    );
  }
} 