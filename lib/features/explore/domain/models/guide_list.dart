class Guide {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final int reviewCount;
  final List<String> languages;
  final List<String> specializations;

  Guide({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.rating,
    required this.reviewCount,
    required this.languages,
    required this.specializations,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
      rating: json['rating'] as double,
      reviewCount: json['reviewCount'] as int,
      languages: List<String>.from(json['languages'] as List),
      specializations: List<String>.from(json['specializations'] as List),
    );
  }
}

class GuideList {
  final List<Guide> guides;
  final String location;

  GuideList({required this.guides, required this.location});

  factory GuideList.fromJson(Map<String, dynamic> json) {
    return GuideList(
      guides:
          (json['guides'] as List)
              .map((guide) => Guide.fromJson(guide as Map<String, dynamic>))
              .toList(),
      location: json['location'] as String,
    );
  }
}
