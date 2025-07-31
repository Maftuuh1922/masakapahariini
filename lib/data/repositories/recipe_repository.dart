import '../models/recipe_model.dart';

class RecipeRepository {
  // Simulasi data, bisa diganti dengan database atau API
  final List<Recipe> _recipes = [];

  List<Recipe> getAllRecipes() {
    return _recipes;
  }

  Recipe? getRecipeById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Recipe>> getTrendingRecipes() async {
    // Simulasi: return semua resep sebagai trending
    await Future.delayed(const Duration(milliseconds: 300));
    return _recipes;
  }

  Future<List<Recipe>> searchByIngredients(List<String> ingredients) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _recipes.where((recipe) =>
      ingredients.every((ing) => recipe.ingredients.any((i) => i.name.toLowerCase().contains(ing.toLowerCase())))
    ).toList();
  }

  Future<void> toggleFavorite(String recipeId) async {
    // Simulasi: tidak ada implementasi, bisa ditambah logika favorit
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    // Simulasi: return kosong
    await Future.delayed(const Duration(milliseconds: 200));
    return [];
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
  }

  void updateRecipe(Recipe recipe) {
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe;
    }
  }

  void deleteRecipe(String id) {
    _recipes.removeWhere((r) => r.id == id);
  }
}
