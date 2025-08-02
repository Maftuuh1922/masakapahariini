class ApiRecipe {
  final String key;
  final String title;
  final String thumb;
  final String times;
  final String serving;
  final String difficulty;

  ApiRecipe({
    required this.key,
    required this.title,
    required this.thumb,
    required this.times,
    required this.serving,
    required this.difficulty,
  });

  factory ApiRecipe.fromJson(Map<String, dynamic> json) {
    return ApiRecipe(
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      thumb: json['thumb'] ?? '',
      times: json['times'] ?? '',
      serving: json['serving'] ?? '',
      difficulty: json['difficulty'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'thumb': thumb,
      'times': times,
      'serving': serving,
      'difficulty': difficulty,
    };
  }
}

class ApiRecipeDetail {
  final String title;
  final String thumb;
  final String servings;
  final String times;
  final String difficulty;
  final String author;
  final String datePublished;
  final String description;
  final List<String> ingredient;
  final List<String> instructions;
  final NutritionalInfo? nutrition;

  ApiRecipeDetail({
    required this.title,
    required this.thumb,
    required this.servings,
    required this.times,
    required this.difficulty,
    required this.author,
    required this.datePublished,
    required this.description,
    required this.ingredient,
    required this.instructions,
    this.nutrition,
  });

  factory ApiRecipeDetail.fromJson(Map<String, dynamic> json) {
    return ApiRecipeDetail(
      title: json['title'] ?? '',
      thumb: json['thumb'] ?? '',
      servings: json['servings'] ?? '',
      times: json['times'] ?? '',
      difficulty: json['difficulty'] ?? '',
      author: json['author']?['user'] ?? '',
      datePublished: json['author']?['datePublished'] ?? '',
      description: json['desc'] ?? '',
      ingredient: List<String>.from(json['ingredient'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      nutrition: json['nutrition'] != null 
          ? NutritionalInfo.fromJson(json['nutrition'])
          : null,
    );
  }
}

class NutritionalInfo {
  final String calories;
  final String fat;
  final String saturatedFat;
  final String cholesterol;
  final String sodium;
  final String carbohydrate;
  final String fiber;
  final String sugar;
  final String protein;

  NutritionalInfo({
    required this.calories,
    required this.fat,
    required this.saturatedFat,
    required this.cholesterol,
    required this.sodium,
    required this.carbohydrate,
    required this.fiber,
    required this.sugar,
    required this.protein,
  });

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      calories: json['calories'] ?? '0',
      fat: json['fatContent'] ?? '0',
      saturatedFat: json['saturatedFatContent'] ?? '0',
      cholesterol: json['cholesterolContent'] ?? '0',
      sodium: json['sodiumContent'] ?? '0',
      carbohydrate: json['carbohydrateContent'] ?? '0',
      fiber: json['fiberContent'] ?? '0',
      sugar: json['sugarContent'] ?? '0',
      protein: json['proteinContent'] ?? '0',
    );
  }
}

class ApiCategory {
  final String category;
  final String key;

  ApiCategory({
    required this.category,
    required this.key,
  });

  factory ApiCategory.fromJson(Map<String, dynamic> json) {
    return ApiCategory(
      category: json['category'] ?? '',
      key: json['key'] ?? '',
    );
  }
}

class ApiArticle {
  final String key;
  final String title;
  final String thumb;
  final String tags;
  final String url;

  ApiArticle({
    required this.key,
    required this.title,
    required this.thumb,
    required this.tags,
    required this.url,
  });

  factory ApiArticle.fromJson(Map<String, dynamic> json) {
    return ApiArticle(
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      thumb: json['thumb'] ?? '',
      tags: json['tags'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class ApiArticleDetail {
  final String title;
  final String thumb;
  final String description;
  final String author;
  final String datePublished;
  final String content;

  ApiArticleDetail({
    required this.title,
    required this.thumb,
    required this.description,
    required this.author,
    required this.datePublished,
    required this.content,
  });

  factory ApiArticleDetail.fromJson(Map<String, dynamic> json) {
    return ApiArticleDetail(
      title: json['title'] ?? '',
      thumb: json['thumb'] ?? '',
      description: json['description'] ?? '',
      author: json['author']?['user'] ?? '',
      datePublished: json['author']?['datePublished'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
