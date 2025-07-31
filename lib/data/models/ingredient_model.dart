class Ingredient {
  final String id;
  final String name;
  final String amount;
  final String unit;
  final String? imageUrl;
  final String category;
  final bool isOptional;
  final List<String>? alternatives;
  
  Ingredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    this.imageUrl,
    required this.category,
    this.isOptional = false,
    this.alternatives,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      unit: json['unit'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      isOptional: json['isOptional'] ?? false,
      alternatives: json['alternatives'] != null
          ? List<String>.from(json['alternatives'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'unit': unit,
      'imageUrl': imageUrl,
      'category': category,
      'isOptional': isOptional,
      'alternatives': alternatives,
    };
  }
}
