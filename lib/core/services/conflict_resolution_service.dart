import 'package:flutter/foundation.dart';

enum ConflictType {
  dataMismatch,
  versionConflict,
  concurrentModification,
  syncConflict,
  mergeConflict,
}

class Conflict {
  final String id;
  final ConflictType type;
  final String entityId;
  final String entityType;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final DateTime timestamp;
  final String? description;
  bool isResolved;

  Conflict({
    required this.id,
    required this.type,
    required this.entityId,
    required this.entityType,
    required this.localData,
    required this.remoteData,
    required this.timestamp,
    this.description,
    this.isResolved = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'entityId': entityId,
    'entityType': entityType,
    'localData': localData,
    'remoteData': remoteData,
    'timestamp': timestamp.toIso8601String(),
    'description': description,
    'isResolved': isResolved,
  };

  factory Conflict.fromJson(Map<String, dynamic> json) => Conflict(
    id: json['id'],
    type: ConflictType.values.firstWhere((e) => e.toString() == json['type']),
    entityId: json['entityId'],
    entityType: json['entityType'],
    localData: json['localData'],
    remoteData: json['remoteData'],
    timestamp: DateTime.parse(json['timestamp']),
    description: json['description'],
    isResolved: json['isResolved'],
  );
}

class ConflictResolutionService {
  final List<Conflict> _conflicts = [];
  final Map<String, Conflict> _resolvedConflicts = {};

  // Getters
  List<Conflict> get activeConflicts => List.unmodifiable(_conflicts);
  List<Conflict> get resolvedConflicts =>
      List.unmodifiable(_resolvedConflicts.values);
  bool get hasConflicts => _conflicts.isNotEmpty;

  // Conflict detection
  void detectConflict({
    required String entityId,
    required String entityType,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    ConflictType type = ConflictType.dataMismatch,
    String? description,
  }) {
    final conflict = Conflict(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      entityId: entityId,
      entityType: entityType,
      localData: localData,
      remoteData: remoteData,
      timestamp: DateTime.now(),
      description: description,
    );

    if (!_conflicts.any((c) => c.entityId == entityId)) {
      _conflicts.add(conflict);
      debugPrint('Conflict detected: ${conflict.type} for $entityType');
    }
  }

  // Conflict resolution
  Future<void> resolveConflict(
    String conflictId, {
    required Map<String, dynamic> resolution,
    String? resolutionNotes,
  }) async {
    final conflict = _conflicts.firstWhere(
      (c) => c.id == conflictId,
      orElse: () => throw Exception('Conflict not found'),
    );

    conflict.isResolved = true;
    _conflicts.remove(conflict);
    _resolvedConflicts[conflictId] = conflict;

    // Implement resolution logic here
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Conflict resolved: $conflictId');
  }

  // Conflict management
  void clearResolvedConflicts() {
    _resolvedConflicts.clear();
  }

  void clearAllConflicts() {
    _conflicts.clear();
    _resolvedConflicts.clear();
  }

  // Conflict information
  String getConflictDescription(Conflict conflict) {
    switch (conflict.type) {
      case ConflictType.dataMismatch:
        return 'Data mismatch between local and remote versions';
      case ConflictType.versionConflict:
        return 'Version conflict detected';
      case ConflictType.concurrentModification:
        return 'Concurrent modifications detected';
      case ConflictType.syncConflict:
        return 'Sync conflict during data synchronization';
      case ConflictType.mergeConflict:
        return 'Merge conflict during data integration';
    }
  }

  Map<String, dynamic> getConflictDetails(Conflict conflict) {
    return {
      'id': conflict.id,
      'type': conflict.type.toString(),
      'entityId': conflict.entityId,
      'entityType': conflict.entityType,
      'timestamp': conflict.timestamp.toIso8601String(),
      'description': conflict.description ?? getConflictDescription(conflict),
      'localData': conflict.localData,
      'remoteData': conflict.remoteData,
    };
  }

  // Conflict statistics
  Map<ConflictType, int> getConflictStatistics() {
    final stats = <ConflictType, int>{};
    for (final conflict in _conflicts) {
      stats[conflict.type] = (stats[conflict.type] ?? 0) + 1;
    }
    return stats;
  }

  int getConflictCountByType(ConflictType type) {
    return _conflicts.where((c) => c.type == type).length;
  }
}
