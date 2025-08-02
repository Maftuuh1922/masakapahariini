import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAIService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // User preference model
  static Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('user_preferences')
            .doc(user.uid)
            .set(preferences, SetOptions(merge: true));
      } else {
        // Save locally if not logged in
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_preferences', json.encode(preferences));
      }
    } catch (e) {
      print('Error saving user preferences: $e');
    }
  }
  
  // Get user preferences
  static Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('user_preferences')
            .doc(user.uid)
            .get();
        
        if (doc.exists) {
          return doc.data() ?? {};
        }
      } else {
        // Get from local storage
        final prefs = await SharedPreferences.getInstance();
        final prefString = prefs.getString('user_preferences');
        if (prefString != null) {
          return json.decode(prefString);
        }
      }
      
      // Default preferences
      return {
        'dietary_restrictions': [],
        'favorite_cuisines': [],
        'cooking_skill': 'beginner',
        'preferred_cooking_time': 30,
        'allergens': [],
        'liked_recipes': [],
        'disliked_recipes': [],
      };
    } catch (e) {
      print('Error getting user preferences: $e');
      return {};
    }
  }
  
  // Save user interaction (like, dislike, view, cook)
  static Future<void> saveUserInteraction({
    required String recipeId,
    required String recipeTitle,
    required String actionType, // 'like', 'dislike', 'view', 'cook', 'save'
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final user = _auth.currentUser;
      final userId = user?.uid ?? 'anonymous';
      
      final interaction = {
        'user_id': userId,
        'recipe_id': recipeId,
        'recipe_title': recipeTitle,
        'action_type': actionType,
        'timestamp': FieldValue.serverTimestamp(),
        'metadata': metadata ?? {},
      };
      
      await _firestore
          .collection('user_interactions')
          .add(interaction);
      
      // Update user preferences based on interaction
      if (actionType == 'like' || actionType == 'cook') {
        await _updateUserPreferencesFromInteraction(recipeId, recipeTitle, true);
      } else if (actionType == 'dislike') {
        await _updateUserPreferencesFromInteraction(recipeId, recipeTitle, false);
      }
    } catch (e) {
      print('Error saving user interaction: $e');
    }
  }
  
  // Update user preferences based on interactions
  static Future<void> _updateUserPreferencesFromInteraction(
    String recipeId,
    String recipeTitle,
    bool isPositive,
  ) async {
    try {
      final preferences = await getUserPreferences();
      
      if (isPositive) {
        // Add to liked recipes
        final likedRecipes = List<String>.from(preferences['liked_recipes'] ?? []);
        if (!likedRecipes.contains(recipeId)) {
          likedRecipes.add(recipeId);
        }
        
        // Remove from disliked if present
        final dislikedRecipes = List<String>.from(preferences['disliked_recipes'] ?? []);
        dislikedRecipes.remove(recipeId);
        
        preferences['liked_recipes'] = likedRecipes;
        preferences['disliked_recipes'] = dislikedRecipes;
      } else {
        // Add to disliked recipes
        final dislikedRecipes = List<String>.from(preferences['disliked_recipes'] ?? []);
        if (!dislikedRecipes.contains(recipeId)) {
          dislikedRecipes.add(recipeId);
        }
        
        // Remove from liked if present
        final likedRecipes = List<String>.from(preferences['liked_recipes'] ?? []);
        likedRecipes.remove(recipeId);
        
        preferences['liked_recipes'] = likedRecipes;
        preferences['disliked_recipes'] = dislikedRecipes;
      }
      
      await saveUserPreferences(preferences);
    } catch (e) {
      print('Error updating preferences from interaction: $e');
    }
  }
  
  // Get AI recommendations based on user preferences and interactions
  static Future<List<String>> getAIRecommendations({
    List<Map<String, dynamic>>? availableRecipes,
    String? moodContext,
    List<String>? availableIngredients,
  }) async {
    try {
      final preferences = await getUserPreferences();
      final likedRecipes = List<String>.from(preferences['liked_recipes'] ?? []);
      final dislikedRecipes = List<String>.from(preferences['disliked_recipes'] ?? []);
      final allergens = List<String>.from(preferences['allergens'] ?? []);
      final preferredTime = preferences['preferred_cooking_time'] ?? 30;
      
      // Simple AI recommendation algorithm
      List<Map<String, dynamic>> scoredRecipes = [];
      
      if (availableRecipes != null) {
        for (var recipe in availableRecipes) {
          double score = 0.0;
          final recipeId = recipe['key'] ?? '';
          final title = recipe['title'] ?? '';
          final difficulty = recipe['difficulty'] ?? '';
          
          // Skip disliked recipes
          if (dislikedRecipes.contains(recipeId)) continue;
          
          // Boost liked recipes
          if (likedRecipes.contains(recipeId)) {
            score += 50.0;
          }
          
          // Consider cooking time preference
          final cookingTime = _extractCookingTime(recipe['times'] ?? '');
          if (cookingTime <= preferredTime) {
            score += 20.0;
          } else {
            score -= (cookingTime - preferredTime) * 0.5;
          }
          
          // Consider difficulty based on user skill
          final userSkill = preferences['cooking_skill'] ?? 'beginner';
          score += _getDifficultyScore(difficulty, userSkill);
          
          // Mood-based scoring
          if (moodContext != null) {
            score += _getMoodScore(title, moodContext);
          }
          
          // Ingredient availability bonus
          if (availableIngredients != null) {
            score += _getIngredientAvailabilityScore(recipe, availableIngredients);
          }
          
          // Random factor for diversity
          score += (DateTime.now().millisecondsSinceEpoch % 100) / 10.0;
          
          scoredRecipes.add({
            'recipe': recipe,
            'score': score,
            'recipe_id': recipeId,
          });
        }
      }
      
      // Sort by score and return top recommendations
      scoredRecipes.sort((a, b) => b['score'].compareTo(a['score']));
      
      return scoredRecipes
          .take(10)
          .map((item) => item['recipe_id'] as String)
          .toList();
    } catch (e) {
      print('Error getting AI recommendations: $e');
      return [];
    }
  }
  
  // Helper function to extract cooking time from text
  static int _extractCookingTime(String timeText) {
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(timeText);
    return match != null ? int.parse(match.group(1)!) : 30;
  }
  
  // Helper function to score based on difficulty and user skill
  static double _getDifficultyScore(String difficulty, String userSkill) {
    const difficultyMap = {
      'mudah': 1,
      'sedang': 2,
      'sulit': 3,
    };
    
    const skillMap = {
      'beginner': 1,
      'intermediate': 2,
      'advanced': 3,
    };
    
    final diffScore = difficultyMap[difficulty.toLowerCase()] ?? 2;
    final skillScore = skillMap[userSkill] ?? 1;
    
    // Perfect match gets highest score
    if (diffScore == skillScore) return 30.0;
    // Close match gets good score
    if ((diffScore - skillScore).abs() == 1) return 15.0;
    // Mismatch gets penalty
    return -10.0;
  }
  
  // Helper function to score based on mood
  static double _getMoodScore(String title, String mood) {
    final moodKeywords = {
      'senang': ['goreng', 'manis', 'kue', 'dessert', 'cake'],
      'sedih': ['sup', 'hangat', 'bubur', 'comfort'],
      'lelah': ['praktis', 'mudah', 'cepat', 'instant'],
      'bosan': ['unik', 'fusion', 'kreatif', 'spesial'],
    };
    
    final keywords = moodKeywords[mood.toLowerCase()] ?? [];
    final titleLower = title.toLowerCase();
    
    double score = 0.0;
    for (var keyword in keywords) {
      if (titleLower.contains(keyword)) {
        score += 15.0;
      }
    }
    
    return score;
  }
  
  // Helper function to score based on ingredient availability
  static double _getIngredientAvailabilityScore(
    Map<String, dynamic> recipe,
    List<String> availableIngredients,
  ) {
    // This would require parsing ingredients from recipe
    // For now, return a base score
    return 5.0;
  }
  
  // Save user's cooking session
  static Future<void> saveCookingSession({
    required String recipeId,
    required String recipeTitle,
    required DateTime startTime,
    DateTime? endTime,
    int? rating,
    String? notes,
    List<String>? modifications,
  }) async {
    try {
      final user = _auth.currentUser;
      final userId = user?.uid ?? 'anonymous';
      
      final session = {
        'user_id': userId,
        'recipe_id': recipeId,
        'recipe_title': recipeTitle,
        'start_time': startTime,
        'end_time': endTime,
        'rating': rating,
        'notes': notes,
        'modifications': modifications ?? [],
        'created_at': FieldValue.serverTimestamp(),
      };
      
      await _firestore
          .collection('cooking_sessions')
          .add(session);
    } catch (e) {
      print('Error saving cooking session: $e');
    }
  }
  
  // Get user's cooking history
  static Future<List<Map<String, dynamic>>> getCookingHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];
      
      final query = await _firestore
          .collection('cooking_sessions')
          .where('user_id', isEqualTo: user.uid)
          .orderBy('created_at', descending: true)
          .limit(50)
          .get();
      
      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting cooking history: $e');
      return [];
    }
  }
}
