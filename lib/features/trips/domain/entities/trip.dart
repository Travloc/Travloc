import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

enum TripStatus { planned, ongoing, completed, cancelled }

/// A Trip entity representing a travel plan
@freezed
abstract class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String title,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required TripStatus status,
    String? description,
    String? imageUrl,
    List<String>? activities,
    List<String>? companions,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
