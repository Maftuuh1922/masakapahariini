import 'dart:convert';
import 'package:http/http.dart' as http;

class MasakApiService {
  // Base URL yang benar sesuai GitHub documentation
  static const String baseUrl = 'https://masak-apa.tomorisakura.vercel.app';

  // Headers yang lebih lengkap
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'Flutter-App/1.0',
  };

  // Test endpoint connectivity
  static Future<bool> testConnection() async {
    try {
      print('Testing connection to: $baseUrl/api');

      final response = await http
          .get(Uri.parse('$baseUrl/api'), headers: headers)
          .timeout(const Duration(seconds: 10));

      print('Connection test - Status: ${response.statusCode}');
      print('Connection test - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == "On Progress 🚀";
      }
      return false;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Get new recipes (endpoint: /api/recipes)
  static Future<List<dynamic>> getNewRecipes() async {
    try {
      print('Fetching new recipes from: $baseUrl/api/recipes');

      final response = await http
          .get(Uri.parse('$baseUrl/api/recipes'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('New recipes response status: ${response.statusCode}');
      print('New recipes response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} new recipes');
          return results;
        }
      }

      print('Failed to get new recipes, trying with pagination...');
      return await getRecipesByPage(1);
    } catch (e) {
      print('Error in getNewRecipes: $e');
      return await getRecipesByPage(1);
    }
  }

  // Get new recipes by page (endpoint: /api/recipes/:page)
  static Future<List<dynamic>> getRecipesByPage(int page) async {
    try {
      print('Fetching recipes page $page from: $baseUrl/api/recipes/$page');

      final response = await http
          .get(Uri.parse('$baseUrl/api/recipes/$page'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('Recipes page $page response status: ${response.statusCode}');
      print('Recipes page $page response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} recipes on page $page');
          return results;
        }
      }

      return _getMockData();
    } catch (e) {
      print('Error in getRecipesByPage: $e');
      return _getMockData();
    }
  }

  // Get limited recipes (endpoint: /api/recipes-length/?limit=size)
  static Future<List<dynamic>> getLimitedRecipes(int limit) async {
    try {
      print(
        'Fetching limited recipes: $baseUrl/api/recipes-length/?limit=$limit',
      );

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/recipes-length/?limit=$limit'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      print('Limited recipes response status: ${response.statusCode}');
      print('Limited recipes response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} limited recipes');
          return results;
        }
      }

      return _getMockData().take(limit).toList();
    } catch (e) {
      print('Error in getLimitedRecipes: $e');
      return _getMockData().take(limit).toList();
    }
  }

  // Get recipes by category (endpoint: /api/category/recipes/:key)
  static Future<List<dynamic>> getRecipesByCategory(String categoryKey) async {
    try {
      print(
        'Fetching recipes by category: $baseUrl/api/category/recipes/$categoryKey',
      );

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/category/recipes/$categoryKey'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      print('Category recipes response status: ${response.statusCode}');
      print('Category recipes response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} recipes in category $categoryKey');
          return results;
        }
      }

      return _getMockData();
    } catch (e) {
      print('Error in getRecipesByCategory: $e');
      return _getMockData();
    }
  }

  // Get recipe categories (endpoint: /api/category/recipes)
  static Future<List<dynamic>> getRecipeCategories() async {
    try {
      print('Fetching recipe categories: $baseUrl/api/category/recipes');

      final response = await http
          .get(Uri.parse('$baseUrl/api/category/recipes'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('Categories response status: ${response.statusCode}');
      print('Categories response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} categories');
          return results;
        }
      }

      return _getMockCategories();
    } catch (e) {
      print('Error in getRecipeCategories: $e');
      return _getMockCategories();
    }
  }

  // Get recipe detail (endpoint: /api/recipe/:key)
  static Future<Map<String, dynamic>?> getRecipeDetail(String key) async {
    try {
      print('Fetching recipe detail: $baseUrl/api/recipe/$key');

      final response = await http
          .get(Uri.parse('$baseUrl/api/recipe/$key'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('Recipe detail response status: ${response.statusCode}');
      print('Recipe detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          print('Found recipe detail for $key');
          return data['results'] as Map<String, dynamic>;
        }
      }

      return _getMockRecipeDetail(key);
    } catch (e) {
      print('Error in getRecipeDetail: $e');
      return _getMockRecipeDetail(key);
    }
  }

  // Search recipes (endpoint: /api/search/?q=parameter)
  static Future<List<dynamic>> searchRecipes(String query) async {
    try {
      print(
        'Searching recipes: $baseUrl/api/search/?q=${Uri.encodeComponent(query)}',
      );

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/search/?q=${Uri.encodeComponent(query)}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      print('Search response status: ${response.statusCode}');
      print('Search response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} search results for "$query"');
          return results;
        }
      }

      // Return filtered mock data as fallback
      return _getMockData()
          .where(
            (recipe) => recipe['title'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    } catch (e) {
      print('Error in searchRecipes: $e');
      return _getMockData()
          .where(
            (recipe) => recipe['title'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  // Get article categories (endpoint: /api/category/article)
  static Future<List<dynamic>> getArticleCategories() async {
    try {
      print('Fetching article categories: $baseUrl/api/category/article');

      final response = await http
          .get(Uri.parse('$baseUrl/api/category/article'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('Article categories response status: ${response.statusCode}');
      print('Article categories response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} article categories');
          return results;
        }
      }

      return [];
    } catch (e) {
      print('Error in getArticleCategories: $e');
      return [];
    }
  }

  // Get articles by category (endpoint: /api/category/article/:key)
  static Future<List<dynamic>> getArticlesByCategory(String categoryKey) async {
    try {
      print(
        'Fetching articles by category: $baseUrl/api/category/article/$categoryKey',
      );

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/category/article/$categoryKey'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      print('Articles by category response status: ${response.statusCode}');
      print('Articles by category response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} articles in category $categoryKey');
          return results;
        }
      }

      return [];
    } catch (e) {
      print('Error in getArticlesByCategory: $e');
      return [];
    }
  }

  // Get new articles (endpoint: /api/articles/new)
  static Future<List<dynamic>> getNewArticles() async {
    try {
      print('Fetching new articles: $baseUrl/api/articles/new');

      final response = await http
          .get(Uri.parse('$baseUrl/api/articles/new'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('New articles response status: ${response.statusCode}');
      print('New articles response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['method'] == 'GET' &&
            data['status'] == true &&
            data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          print('Found ${results.length} new articles');
          return results;
        }
      }

      return [];
    } catch (e) {
      print('Error in getNewArticles: $e');
      return [];
    }
  }

  // Main method for getting all recipes (tries multiple endpoints)
  static Future<List<dynamic>> getAllRecipes({int page = 1}) async {
    try {
      print('Loading recipes from API...');

      // Test API connection first
      final isConnected = await testConnection();
      print('API connection status: $isConnected');

      if (!isConnected) {
        print('API not accessible, returning mock data');
        return _getMockData();
      }

      // Try multiple endpoints in order of preference
      List<dynamic> recipeData = [];

      // 1. Try new recipes endpoint
      try {
        print('Trying new recipes endpoint...');
        recipeData = await getNewRecipes();
        if (recipeData.isNotEmpty) {
          print(
            'Success: Got ${recipeData.length} recipes from new recipes endpoint',
          );
          return recipeData;
        }
      } catch (e) {
        print('New recipes endpoint failed: $e');
      }

      // 2. Try recipes by page endpoint
      try {
        print('Trying recipes by page endpoint...');
        recipeData = await getRecipesByPage(page);
        if (recipeData.isNotEmpty) {
          print('Success: Got ${recipeData.length} recipes from page $page');
          return recipeData;
        }
      } catch (e) {
        print('Recipes by page endpoint failed: $e');
      }

      // 3. Try limited recipes endpoint
      try {
        print('Trying limited recipes endpoint...');
        recipeData = await getLimitedRecipes(10);
        if (recipeData.isNotEmpty) {
          print('Success: Got ${recipeData.length} limited recipes');
          return recipeData;
        }
      } catch (e) {
        print('Limited recipes endpoint failed: $e');
      }

      // 4. Try getting recipes from first category
      try {
        print('Trying to get recipes from categories...');
        final categories = await getRecipeCategories();
        if (categories.isNotEmpty) {
          final firstCategory = categories.first;
          if (firstCategory['key'] != null) {
            recipeData = await getRecipesByCategory(firstCategory['key']);
            if (recipeData.isNotEmpty) {
              print(
                'Success: Got ${recipeData.length} recipes from category ${firstCategory['key']}',
              );
              return recipeData;
            }
          }
        }
      } catch (e) {
        print('Category recipes endpoint failed: $e');
      }

      print('All API endpoints failed, returning mock data');
      return _getMockData();
    } catch (e) {
      print('Error in getAllRecipes: $e');
      return _getMockData();
    }
  }

  // Alias for backwards compatibility
  static Future<List<dynamic>> searchByIngredient(String ingredient) async {
    return await searchRecipes(ingredient);
  }

  // Mock data untuk fallback
  static List<dynamic> _getMockData() {
    return [
      {
        'key': 'nasi-goreng-spesial',
        'title': 'Nasi Goreng Spesial',
        'thumb':
            'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=300',
        'times': '20 Menit',
        'serving': '2 Porsi',
        'difficulty': 'Mudah',
      },
      {
        'key': 'soto-ayam-bening',
        'title': 'Soto Ayam Bening',
        'thumb':
            'https://images.unsplash.com/photo-1585206066689-a1fafda1905b?w=300',
        'times': '45 Menit',
        'serving': '4 Porsi',
        'difficulty': 'Sedang',
      },
      {
        'key': 'ayam-geprek-sambal-matah',
        'title': 'Ayam Geprek Sambal Matah',
        'thumb':
            'https://images.unsplash.com/photo-1562967916-eb82221dfb92?w=300',
        'times': '35 Menit',
        'serving': '2 Porsi',
        'difficulty': 'Sedang',
      },
      {
        'key': 'rendang-daging-sapi',
        'title': 'Rendang Daging Sapi',
        'thumb':
            'https://images.unsplash.com/photo-1544025162-d76694265947?w=300',
        'times': '2 Jam',
        'serving': '6 Porsi',
        'difficulty': 'Sulit',
      },
      {
        'key': 'gado-gado-betawi',
        'title': 'Gado-Gado Betawi',
        'thumb':
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300',
        'times': '30 Menit',
        'serving': '3 Porsi',
        'difficulty': 'Mudah',
      },
      {
        'key': 'martabak-manis',
        'title': 'Martabak Manis',
        'thumb':
            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=300',
        'times': '25 Menit',
        'serving': '4 Porsi',
        'difficulty': 'Sedang',
      },
      {
        'key': 'bakso-malang',
        'title': 'Bakso Malang',
        'thumb':
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300',
        'times': '60 Menit',
        'serving': '3 Porsi',
        'difficulty': 'Sulit',
      },
      {
        'key': 'es-cendol',
        'title': 'Es Cendol',
        'thumb':
            'https://images.unsplash.com/photo-1563379091339-03246963d51a?w=300',
        'times': '15 Menit',
        'serving': '2 Porsi',
        'difficulty': 'Mudah',
      },
    ];
  }

  static List<dynamic> _getMockCategories() {
    return [
      {'key': 'makanan-utama', 'title': 'Makanan Utama'},
      {'key': 'makanan-ringan', 'title': 'Makanan Ringan'},
      {'key': 'minuman', 'title': 'Minuman'},
      {'key': 'dessert', 'title': 'Dessert'},
      {'key': 'sup-dan-soto', 'title': 'Sup dan Soto'},
    ];
  }

  static Map<String, dynamic> _getMockRecipeDetail(String key) {
    return {
      'title': 'Nasi Goreng Spesial',
      'thumb':
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=300',
      'times': '20 Menit',
      'servings': '2 Porsi',
      'difficulty': 'Mudah',
      'ingredient': [
        '2 piring nasi putih',
        '2 butir telur',
        '3 siung bawang putih',
        '2 buah cabai merah',
        '2 sdm kecap manis',
        'Garam secukupnya',
      ],
      'instructions': [
        'Panaskan minyak dalam wajan',
        'Tumis bawang putih hingga harum',
        'Masukkan telur, orak-arik hingga matang',
        'Tambahkan nasi putih, aduk rata',
        'Bumbui dengan kecap manis dan garam',
        'Sajikan selagi hangat',
      ],
      'nutrition': {
        'calories': '350',
        'protein': '12',
        'carbohydrate': '45',
        'fat': '8',
        'fiber': '3',
        'sugar': '5',
      },
    };
  }
}
