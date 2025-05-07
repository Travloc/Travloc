class TripPlan {
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> activities;
  final List<String> accommodations;
  final double estimatedCost;
  final int adultCount;
  final int childrenCount;

  TripPlan({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.activities,
    required this.accommodations,
    required this.estimatedCost,
    this.adultCount = 1,
    this.childrenCount = 0,
  });

  int get totalGroupSize => adultCount + childrenCount;

  factory TripPlan.fromJson(Map<String, dynamic> json) {
    return TripPlan(
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      activities: List<String>.from(json['activities'] as List),
      accommodations: List<String>.from(json['accommodations'] as List),
      estimatedCost: json['estimatedCost'] as double,
    );
  }
}
