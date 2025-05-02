class AppConfig {
  static const String appName = 'Travloc';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.travloc.com'; // Replace with your actual API URL
  
  // Map Configuration
  static const String mapboxAccessToken = ''; // Add your Mapbox access token here
  
  // Firebase Configuration
  static const bool enableFirebase = true;
  
  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableVoiceNavigation = true;
  static const bool enableARFeatures = true;
  
  // Cache Configuration
  static const int cacheDuration = 7; // in days
  static const int maxCacheSize = 100; // in MB
} 