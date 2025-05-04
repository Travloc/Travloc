class Attraction {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final String description;
  final double latitude;
  final double longitude;

  Attraction({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
      rating: json['rating'] as double,
      reviewCount: json['reviewCount'] as int,
      category: json['category'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}

class AttractionList {
  final List<Attraction> attractions;
  final String location;

  AttractionList({required this.attractions, required this.location});

  factory AttractionList.fromJson(Map<String, dynamic> json) {
    return AttractionList(
      attractions:
          (json['attractions'] as List)
              .map(
                (attraction) =>
                    Attraction.fromJson(attraction as Map<String, dynamic>),
              )
              .toList(),
      location: json['location'] as String,
    );
  }
}
