import 'dart:convert';
import 'package:http/http.dart' as http;

class MasakApiService {
  // Multiple API endpoints to try (based on working unofficial Masak Apa Hari Ini APIs)
  static const List<String> apiBaseUrls = [
    'https://masak-apa-tomorisakura.vercel.app', // Original
    'https://masak-apa.vercel.app', // Alternative
    'https://api-resep-masakan.vercel.app', // Alternative
    'https://resep-masakan-api.vercel.app', // Alternative
  ];

  // Primary base URL - will be updated if we find a working one
  static String workingBaseUrl = 'https://masak-apa-tomorisakura.vercel.app';

  // Headers yang lebih lengkap
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'Flutter-App/1.0',
  };

  // Find working API endpoint
  static Future<String?> findWorkingEndpoint() async {
    final testEndpoints = [
      '/api/recipes',
      '/api/recipe/new',
      '/recipes',
      '/api',
    ];

    for (String baseUrl in apiBaseUrls) {
      for (String endpoint in testEndpoints) {
        try {
          final url = '$baseUrl$endpoint';
          print('Testing endpoint: $url');

          final response = await http
              .get(Uri.parse(url), headers: headers)
              .timeout(const Duration(seconds: 5));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            // Check if this looks like a valid recipe API response
            bool isValidResponse = false;

            if (data is Map<String, dynamic>) {
              if (data.containsKey('results') && data['results'] is List) {
                final results = data['results'] as List;
                if (results.isNotEmpty && results[0] is Map) {
                  final firstItem = results[0] as Map;
                  if (firstItem.containsKey('title') ||
                      firstItem.containsKey('key')) {
                    isValidResponse = true;
                  }
                }
              }
            } else if (data is List && data.isNotEmpty) {
              if (data[0] is Map) {
                final firstItem = data[0] as Map;
                if (firstItem.containsKey('title') ||
                    firstItem.containsKey('key')) {
                  isValidResponse = true;
                }
              }
            }

            if (isValidResponse) {
              print('✅ Found working endpoint: $url');
              workingBaseUrl = baseUrl;
              return url;
            }
          }
        } catch (e) {
          print('❌ Endpoint failed: $baseUrl$endpoint - $e');
        }
      }
    }

    print('⚠️ No working endpoints found, will use mock data');
    return null;
  }

  // Get new recipes (endpoint: /api/recipes)
  static Future<List<dynamic>> getNewRecipes() async {
    try {
      print('Fetching new recipes from: $workingBaseUrl/api/recipes');

      final response = await http
          .get(Uri.parse('$workingBaseUrl/api/recipes'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('New recipes response status: ${response.statusCode}');
      print('New recipes response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          if (data['method'] == 'GET' &&
              data['status'] == true &&
              data['results'] != null) {
            final results = data['results'] as List<dynamic>;
            print('Found ${results.length} new recipes');
            return results;
          } else if (data.containsKey('data') && data['data'] is List) {
            final results = data['data'] as List<dynamic>;
            print('Found ${results.length} recipes in data field');
            return results;
          } else if (data.containsKey('results') && data['results'] is List) {
            final results = data['results'] as List<dynamic>;
            print('Found ${results.length} recipes in results field');
            return results;
          }
        } else if (data is List) {
          print('Found ${data.length} recipes as direct list');
          return data;
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
      print(
        'Fetching recipes page $page from: $workingBaseUrl/api/recipes/$page',
      );

      final response = await http
          .get(Uri.parse('$workingBaseUrl/api/recipes/$page'), headers: headers)
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
        'Fetching limited recipes: $workingBaseUrl/api/recipes-length/?limit=$limit',
      );

      final response = await http
          .get(
            Uri.parse('$workingBaseUrl/api/recipes-length/?limit=$limit'),
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
        'Fetching recipes by category: $workingBaseUrl/api/category/recipes/$categoryKey',
      );

      final response = await http
          .get(
            Uri.parse('$workingBaseUrl/api/category/recipes/$categoryKey'),
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
      print('Fetching recipe categories: $workingBaseUrl/api/category/recipes');

      final response = await http
          .get(
            Uri.parse('$workingBaseUrl/api/category/recipes'),
            headers: headers,
          )
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
      // Try different detail endpoints across multiple base URLs
      final detailEndpoints = <String>[];
      for (String url in apiBaseUrls) {
        detailEndpoints.addAll([
          '$url/api/recipe/$key',
          '$url/recipe/$key',
          '$url/api/recipes/$key',
          '$url/recipes/$key',
        ]);
      }

      for (String endpoint in detailEndpoints) {
        try {
          print('Fetching recipe detail: $endpoint');

          final response = await http
              .get(Uri.parse(endpoint), headers: headers)
              .timeout(const Duration(seconds: 10));

          print('Recipe detail response status: ${response.statusCode}');

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            Map<String, dynamic>? result;

            if (data is Map<String, dynamic>) {
              if (data['method'] == 'GET' &&
                  data['status'] == true &&
                  data['results'] != null) {
                result = data['results'] as Map<String, dynamic>;
              } else if (data.containsKey('results') &&
                  data['results'] is Map) {
                result = data['results'] as Map<String, dynamic>;
              } else if (data.containsKey('data') && data['data'] is Map) {
                result = data['data'] as Map<String, dynamic>;
              } else if (data.containsKey('key') || data.containsKey('title')) {
                // Direct recipe data
                result = data;
              }
            }

            if (result != null) {
              print('Found recipe detail for $key');
              return result;
            }
          }
        } catch (e) {
          print('Detail endpoint failed: $endpoint - $e');
          continue;
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
      // Try different search endpoints across multiple base URLs
      final searchEndpoints = <String>[];
      for (String url in apiBaseUrls) {
        searchEndpoints.addAll([
          '$url/api/search/?q=${Uri.encodeComponent(query)}',
          '$url/api/search?q=${Uri.encodeComponent(query)}',
          '$url/search?q=${Uri.encodeComponent(query)}',
          '$url/api/recipes/search?query=${Uri.encodeComponent(query)}',
        ]);
      }

      for (String endpoint in searchEndpoints) {
        try {
          print('Searching recipes: $endpoint');

          final response = await http
              .get(Uri.parse(endpoint), headers: headers)
              .timeout(const Duration(seconds: 10));

          print('Search response status: ${response.statusCode}');

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            List<dynamic> results = [];

            if (data is Map<String, dynamic>) {
              if (data['method'] == 'GET' &&
                  data['status'] == true &&
                  data['results'] != null) {
                results = data['results'] as List<dynamic>;
              } else if (data.containsKey('results') &&
                  data['results'] is List) {
                results = data['results'] as List<dynamic>;
              } else if (data.containsKey('data') && data['data'] is List) {
                results = data['data'] as List<dynamic>;
              }
            } else if (data is List) {
              results = data;
            }

            if (results.isNotEmpty) {
              print('Found ${results.length} search results for "$query"');
              return results;
            }
          }
        } catch (e) {
          print('Search endpoint failed: $endpoint - $e');
          continue;
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
      print(
        'Fetching article categories: $workingBaseUrl/api/category/article',
      );

      final response = await http
          .get(
            Uri.parse('$workingBaseUrl/api/category/article'),
            headers: headers,
          )
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
        'Fetching articles by category: $workingBaseUrl/api/category/article/$categoryKey',
      );

      final response = await http
          .get(
            Uri.parse('$workingBaseUrl/api/category/article/$categoryKey'),
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
      print('Fetching new articles: $workingBaseUrl/api/articles/new');

      final response = await http
          .get(Uri.parse('$workingBaseUrl/api/articles/new'), headers: headers)
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
      print('🔍 Loading recipes from API...');

      // First, try to find a working endpoint
      final workingEndpoint = await findWorkingEndpoint();

      if (workingEndpoint != null) {
        try {
          final response = await http
              .get(Uri.parse(workingEndpoint), headers: headers)
              .timeout(const Duration(seconds: 10));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            List<dynamic> recipes = [];

            // Handle different response formats
            if (data is Map<String, dynamic>) {
              if (data.containsKey('results') && data['results'] is List) {
                recipes = data['results'] as List<dynamic>;
              } else if (data.containsKey('data') && data['data'] is List) {
                recipes = data['data'] as List<dynamic>;
              } else if (data.containsKey('recipes') &&
                  data['recipes'] is List) {
                recipes = data['recipes'] as List<dynamic>;
              }
            } else if (data is List) {
              recipes = data;
            }

            if (recipes.isNotEmpty) {
              print(
                '✅ Success: Got ${recipes.length} recipes from working endpoint',
              );
              return recipes;
            }
          }
        } catch (e) {
          print('❌ Error using working endpoint: $e');
        }
      }

      // Fallback: Try common endpoint patterns
      final fallbackEndpoints = [
        '$workingBaseUrl/api/recipes',
        '$workingBaseUrl/api/recipes/$page',
        '$workingBaseUrl/recipes',
        '$workingBaseUrl/api/recipe/new',
      ];

      for (String endpoint in fallbackEndpoints) {
        try {
          print('🔄 Trying fallback: $endpoint');

          final response = await http
              .get(Uri.parse(endpoint), headers: headers)
              .timeout(const Duration(seconds: 8));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            List<dynamic> recipes = [];

            if (data is Map<String, dynamic>) {
              if (data.containsKey('results') && data['results'] is List) {
                recipes = data['results'] as List<dynamic>;
              } else if (data.containsKey('data') && data['data'] is List) {
                recipes = data['data'] as List<dynamic>;
              }
            } else if (data is List) {
              recipes = data;
            }

            if (recipes.isNotEmpty) {
              print('✅ Fallback success: Got ${recipes.length} recipes');
              return recipes;
            }
          }
        } catch (e) {
          print('❌ Fallback failed: $endpoint - $e');
          continue;
        }
      }

      print('⚠️ All API endpoints failed, returning mock data');
      return _getMockData();
    } catch (e) {
      print('❌ Error in getAllRecipes: $e');
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
