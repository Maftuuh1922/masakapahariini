import 'package:flutter/foundation.dart';
import '../models/ingredient.dart';

class IngredientProvider with ChangeNotifier {
  List<String> _selectedIngredients = [];
  List<Ingredient> _availableIngredients = [];
  
  List<String> get selectedIngredients => _selectedIngredients;
  List<Ingredient> get availableIngredients => _availableIngredients;

  void addIngredient(String ingredient) {
    if (!_selectedIngredients.contains(ingredient.toLowerCase())) {
      _selectedIngredients.add(ingredient.toLowerCase());
      notifyListeners();
    }
  }

  void removeIngredient(String ingredient) {
    _selectedIngredients.remove(ingredient.toLowerCase());
    notifyListeners();
  }

  void clearIngredients() {
    _selectedIngredients.clear();
    notifyListeners();
  }

  void toggleIngredient(String ingredient) {
    if (_selectedIngredients.contains(ingredient.toLowerCase())) {
      removeIngredient(ingredient);
    } else {
      addIngredient(ingredient);
    }
  }

  // Mock data for available ingredients
  void loadAvailableIngredients() {
    _availableIngredients = [
      Ingredient(
        id: 1,
        name: 'Bawang Putih',
        category: 'Bumbu',
        unit: 'siung',
      ),
      Ingredient(
        id: 2,
        name: 'Bawang Merah',
        category: 'Bumbu',
        unit: 'buah',
      ),
      Ingredient(
        id: 3,
        name: 'Cabai',
        category: 'Sayuran',
        unit: 'buah',
      ),
      Ingredient(
        id: 4,
        name: 'Tomat',
        category: 'Sayuran',
        unit: 'buah',
      ),
      Ingredient(
        id: 5,
        name: 'Telur',
        category: 'Protein',
        unit: 'butir',
      ),
      Ingredient(
        id: 6,
        name: 'Ayam',
        category: 'Protein',
        unit: 'gram',
      ),
      Ingredient(
        id: 7,
        name: 'Nasi',
        category: 'Karbohidrat',
        unit: 'piring',
      ),
      Ingredient(
        id: 8,
        name: 'Mie',
        category: 'Karbohidrat',
        unit: 'bungkus',
      ),
    ];
    notifyListeners();
  }

  List<Ingredient> searchIngredients(String query) {
    if (query.isEmpty) return _availableIngredients;
    
    return _availableIngredients
        .where((ingredient) =>
            ingredient.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
