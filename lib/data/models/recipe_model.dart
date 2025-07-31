import 'ingredient_model.dart';
import 'nutrition_info.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final int cookingTime;
  final String difficulty;
  final int servings;
  final double rating;
  final int reviewCount;
  final NutritionInfo nutrition;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  
  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.cookingTime,
    required this.difficulty,
    required this.servings,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.nutrition,
    required this.category,
    this.tags = const [],
    required this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      ingredients: (json['ingredients'] as List)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      steps: List<String>.from(json['steps']),
      cookingTime: json['cookingTime'],
      difficulty: json['difficulty'],
      servings: json['servings'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      nutrition: NutritionInfo.fromJson(json['nutrition']),
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps,
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'servings': servings,
      'rating': rating,
      'reviewCount': reviewCount,
      'nutrition': nutrition.toJson(),
      'category': category,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
