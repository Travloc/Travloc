import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class OfflineService {
  final SharedPreferences _prefs;
  final Connectivity _connectivity = Connectivity();
  bool _isOfflineMode = false;
  final Map<String, dynamic> _offlineData = {};
  final List<Map<String, dynamic>> _pendingChanges = [];

  OfflineService(this._prefs);

  // Offline mode management
  bool get isOfflineMode => _isOfflineMode;
  List<Map<String, dynamic>> get pendingChanges =>
      List.unmodifiable(_pendingChanges);

  Future<void> initialize() async {
    // Load offline data from storage
    await _loadOfflineData();

    // Monitor connectivity
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _isOfflineMode = results.contains(ConnectivityResult.none);
    });

    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isOfflineMode = result.contains(ConnectivityResult.none);
  }

  // Data management
  Future<void> _loadOfflineData() async {
    final offlineDataJson = _prefs.getString('offline_data');
    if (offlineDataJson != null) {
      _offlineData.addAll(json.decode(offlineDataJson));
    }
  }

  Future<void> _saveOfflineData() async {
    await _prefs.setString('offline_data', json.encode(_offlineData));
  }

  // Trip planning offline support
  Future<void> saveTripPlan(Map<String, dynamic> tripPlan) async {
    _offlineData['trip_plan'] = tripPlan;
    _pendingChanges.add({
      'type': 'trip_plan',
      'data': tripPlan,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _saveOfflineData();
  }

  Future<Map<String, dynamic>?> getTripPlan() async {
    return _offlineData['trip_plan'];
  }

  // User data offline support
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    _offlineData['user_data'] = userData;
    _pendingChanges.add({
      'type': 'user_data',
      'data': userData,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _saveOfflineData();
  }

  Future<Map<String, dynamic>?> getUserData() async {
    return _offlineData['user_data'];
  }

  // Offline data management
  Future<void> saveOfflineData(String key, dynamic data) async {
    _offlineData[key] = data;
    _pendingChanges.add({
      'type': 'custom_data',
      'key': key,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _saveOfflineData();
  }

  Future<dynamic> getOfflineData(String key) async {
    return _offlineData[key];
  }

  // Sync management
  Future<void> syncPendingChanges() async {
    if (_isOfflineMode) return;

    for (final change in List.from(_pendingChanges)) {
      try {
        // Implement sync logic here
        await Future.delayed(const Duration(milliseconds: 500));
        _pendingChanges.remove(change);
      } catch (e) {
        // Handle sync error
        debugPrint('Failed to sync change: $e');
      }
    }
  }

  // Storage management
  Future<int> getOfflineStorageUsage() async {
    final offlineDataJson = _prefs.getString('offline_data') ?? '';
    return offlineDataJson.length;
  }

  Future<void> clearOfflineData() async {
    _offlineData.clear();
    _pendingChanges.clear();
    await _prefs.remove('offline_data');
  }

  // Status information
  String get offlineStatus {
    if (_isOfflineMode) {
      return 'Offline Mode Active';
    }
    if (_pendingChanges.isNotEmpty) {
      return '${_pendingChanges.length} changes pending sync';
    }
    return 'Online Mode';
  }

  String get storageStatus {
    final usage = _offlineData.toString().length;
    if (usage > 1024 * 1024) {
      return '${(usage / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (usage > 1024) {
      return '${(usage / 1024).toStringAsFixed(1)} KB';
    }
    return '$usage bytes';
  }
}
