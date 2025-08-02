// Model untuk Recipe sesuai dengan design
class Recipe {
  final int id;
  final String title;
  final String description;
  final String time;
  final int servings;
  final String difficulty;
  final String category;
  final Color tagColor;
  final String emoji;
  final List<String> ingredients;
  final List<String> instructions;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final String nutritionalInfo;
  final bool isFavorite;
  final String videoUrl;
  final List<String> tags;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.servings,
    required this.difficulty,
    required this.category,
    required this.tagColor,
    required this.emoji,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.nutritionalInfo,
    this.isFavorite = false,
    this.videoUrl = '',
    this.tags = const [],
  });

  Recipe copyWith({
    int? id,
    String? title,
    String? description,
    String? time,
    int? servings,
    String? difficulty,
    String? category,
    Color? tagColor,
    String? emoji,
    List<String>? ingredients,
    List<String>? instructions,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    String? nutritionalInfo,
    bool? isFavorite,
    String? videoUrl,
    List<String>? tags,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      tagColor: tagColor ?? this.tagColor,
      emoji: emoji ?? this.emoji,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      isFavorite: isFavorite ?? this.isFavorite,
      videoUrl: videoUrl ?? this.videoUrl,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'servings': servings,
      'difficulty': difficulty,
      'category': category,
      'emoji': emoji,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'nutritionalInfo': nutritionalInfo,
      'isFavorite': isFavorite,
      'videoUrl': videoUrl,
      'tags': tags,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: json['time'],
      servings: json['servings'],
      difficulty: json['difficulty'],
      category: json['category'],
      tagColor: _getDifficultyColor(json['difficulty']),
      emoji: json['emoji'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      nutritionalInfo: json['nutritionalInfo'],
      isFavorite: json['isFavorite'] ?? false,
      videoUrl: json['videoUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  static Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'mudah':
        return const Color(0xFF10B981); // Green
      case 'sedang':
        return const Color(0xFF8B5CF6); // Purple
      case 'sulit':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF8B5CF6);
    }
  }
}
