import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travloc/core/theme/app_theme.dart';
import 'package:travloc/core/router/app_router.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:travloc/core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Mapbox with access token
  MapboxOptions.setAccessToken(AppConfig.mapboxAccessToken);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF181A20),
      systemNavigationBarColor: Color(0xFF181A20),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: TravlocApp()));
}

class TravlocApp extends ConsumerWidget {
  const TravlocApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Travloc',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
