import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/trip.dart';

final tripsProvider = Provider<AsyncValue<List<Trip>>>(
  (ref) => const AsyncValue.data([]),
);
