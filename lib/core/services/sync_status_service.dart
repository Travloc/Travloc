import 'package:connectivity_plus/connectivity_plus.dart';

enum SyncStatus { online, syncing, offline, error }

class SyncStatusService {
  final Connectivity _connectivity = Connectivity();
  SyncStatus _currentStatus = SyncStatus.online;
  String? _errorMessage;
  int _pendingChanges = 0;
  DateTime? _lastSynced;

  // Getters
  SyncStatus get currentStatus => _currentStatus;
  String? get errorMessage => _errorMessage;
  int get pendingChanges => _pendingChanges;
  DateTime? get lastSynced => _lastSynced;

  // Initialize sync monitoring
  Future<void> initialize() async {
    // Monitor connectivity changes
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.contains(ConnectivityResult.none)) {
        _setStatus(SyncStatus.offline);
      } else {
        _setStatus(SyncStatus.online);
      }
    });

    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      _setStatus(SyncStatus.offline);
    }
  }

  // Status management
  void _setStatus(SyncStatus status, {String? error}) {
    _currentStatus = status;
    _errorMessage = error;
  }

  void startSyncing() {
    _setStatus(SyncStatus.syncing);
  }

  void completeSync() {
    _setStatus(SyncStatus.online);
    _lastSynced = DateTime.now();
    _pendingChanges = 0;
  }

  void setError(String message) {
    _setStatus(SyncStatus.error, error: message);
  }

  // Change tracking
  void addPendingChange() {
    _pendingChanges++;
    if (_currentStatus == SyncStatus.online) {
      startSyncing();
    }
  }

  void removePendingChange() {
    if (_pendingChanges > 0) {
      _pendingChanges--;
    }
    if (_pendingChanges == 0 && _currentStatus == SyncStatus.syncing) {
      completeSync();
    }
  }

  // Status checks
  bool get isOnline => _currentStatus == SyncStatus.online;
  bool get isSyncing => _currentStatus == SyncStatus.syncing;
  bool get isOffline => _currentStatus == SyncStatus.offline;
  bool get hasError => _currentStatus == SyncStatus.error;

  // Status descriptions
  String get statusDescription {
    switch (_currentStatus) {
      case SyncStatus.online:
        return 'All changes saved';
      case SyncStatus.syncing:
        return 'Syncing changes...';
      case SyncStatus.offline:
        return 'Working offline';
      case SyncStatus.error:
        return 'Error: $_errorMessage';
    }
  }

  // Retry mechanism
  Future<void> retrySync() async {
    if (_currentStatus == SyncStatus.error) {
      startSyncing();
      try {
        // Implement retry logic here
        await Future.delayed(const Duration(seconds: 2));
        completeSync();
      } catch (e) {
        setError('Failed to sync: $e');
      }
    }
  }
}
