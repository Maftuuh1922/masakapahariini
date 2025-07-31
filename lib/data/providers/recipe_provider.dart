import 'package:flutter/foundation.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeRepository _repository;
  
  RecipeProvider(this._repository);

  List<Recipe> _trendingRecipes = [];
  List<Recipe> _searchResults = [];
  List<Recipe> _favoriteRecipes = [];
  Recipe? _selectedRecipe;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Recipe> get trendingRecipes => _trendingRecipes;
  List<Recipe> get searchResults => _searchResults;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;
  Recipe? get selectedRecipe => _selectedRecipe;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load trending recipes
  Future<void> loadTrendingRecipes() async {
    _setLoading(true);
    try {
      _trendingRecipes = await _repository.getTrendingRecipes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Search recipes by ingredients
  Future<void> searchByIngredients(List<String> ingredients) async {
    _setLoading(true);
    try {
      _searchResults = await _repository.searchByIngredients(ingredients);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Get recipe detail
  Future<void> getRecipeDetail(String recipeId) async {
    _setLoading(true);
    try {
      _selectedRecipe = await _repository.getRecipeById(recipeId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String recipeId) async {
    try {
      await _repository.toggleFavorite(recipeId);
      await loadFavoriteRecipes();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load favorite recipes
  Future<void> loadFavoriteRecipes() async {
    _setLoading(true);
    try {
      _favoriteRecipes = await _repository.getFavoriteRecipes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
