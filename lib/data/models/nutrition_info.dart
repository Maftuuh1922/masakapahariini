class NutritionInfo {
  final int calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final double sugar;
  final double sodium;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: json['calories'],
      protein: (json['protein'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fiber: (json['fiber'] ?? 0.0).toDouble(),
      sugar: (json['sugar'] ?? 0.0).toDouble(),
      sodium: (json['sodium'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
    };
  }
}
