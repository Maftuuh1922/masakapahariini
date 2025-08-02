class User {
  final int id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final List<String> preferences; // vegetarian, halal, dll
  final List<int> favoriteRecipes;
  final List<int> recentlyViewed;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.preferences = const [],
    this.favoriteRecipes = const [],
    this.recentlyViewed = const [],
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImageUrl,
    List<String>? preferences,
    List<int>? favoriteRecipes,
    List<int>? recentlyViewed,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'preferences': preferences,
      'favoriteRecipes': favoriteRecipes,
      'recentlyViewed': recentlyViewed,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      preferences: List<String>.from(json['preferences'] ?? []),
      favoriteRecipes: List<int>.from(json['favoriteRecipes'] ?? []),
      recentlyViewed: List<int>.from(json['recentlyViewed'] ?? []),
    );
  }
}
