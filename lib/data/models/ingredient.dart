import 'package:flutter/material.dart';

class Ingredient {
  final int id;
  final String name;
  final String category; // Sayuran, Protein, Bumbu, dll
  final String? imageUrl;
  final bool isAvailable;
  final String unit; // gram, buah, sendok, dll

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
    this.imageUrl,
    this.isAvailable = false,
    this.unit = 'buah',
  });

  Ingredient copyWith({
    int? id,
    String? name,
    String? category,
    String? imageUrl,
    bool? isAvailable,
    String? unit,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'unit': unit,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      isAvailable: json['isAvailable'] ?? false,
      unit: json['unit'] ?? 'buah',
    );
  }
}
