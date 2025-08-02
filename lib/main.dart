import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'firebase_options.dart';
import 'services/masak_api_service.dart';
import 'services/firebase_ai_service.dart';
import 'models/api_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize Firebase, but don't crash if it fails during development
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed (development mode): $e');
    // Continue without Firebase for now - app will work with API only
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hari Ini Masak Apa?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.light,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const AppContent(),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> with TickerProviderStateMixin {
  int _activeTab = 0;
  String? _selectedRecipeId;
  late AnimationController _backgroundController;

  final List<TabItem> tabs = [
    TabItem(
      id: 'home',
      icon: Icons.home,
      label: 'Beranda',
      gradient: [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)],
    ),
    TabItem(
      id: 'search',
      icon: Icons.search,
      label: 'Cari',
      gradient: [const Color(0xFF10B981), const Color(0xFF3B82F6)],
    ),
    TabItem(
      id: 'ai',
      icon: Icons.auto_awesome,
      label: 'AI',
      gradient: [const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
    ),
    TabItem(
      id: 'favorites',
      icon: Icons.favorite,
      label: 'Favorit',
      gradient: [const Color(0xFFEC4899), const Color(0xFFEF4444)],
    ),
    TabItem(
      id: 'profile',
      icon: Icons.person,
      label: 'Profil',
      gradient: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  Widget _renderContent() {
    if (_selectedRecipeId != null) {
      return RecipeDetailScreen(
        recipeId: _selectedRecipeId!,
        onBack: () => setState(() => _selectedRecipeId = null),
      );
    }

    switch (_activeTab) {
      case 0:
        return RecipeListScreen(
          onSelectRecipe: (id) => setState(() => _selectedRecipeId = id),
        );
      case 1:
        return RecipeSearchScreen(
          onSelectRecipe: (id) => setState(() => _selectedRecipeId = id),
        );
      case 2:
        return AIAssistantScreen(
          onSelectRecipe: (id) => setState(() => _selectedRecipeId = id),
        );
      case 3:
        return FavoriteRecipesScreen(
          onSelectRecipe: (id) => setState(() => _selectedRecipeId = id),
        );
      case 4:
        return const UserProfileScreen();
      default:
        return RecipeListScreen(
          onSelectRecipe: (id) => setState(() => _selectedRecipeId = id),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb),
              const Color(0xFFf5576c),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Liquid floating bubbles
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: 80 + (50 * _backgroundController.value),
                      left: MediaQuery.of(context).size.width * 0.1,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          MediaQuery.of(context).size.height * 0.4 +
                          (40 * (1 - _backgroundController.value)),
                      right: MediaQuery.of(context).size.width * 0.15,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom:
                          MediaQuery.of(context).size.height * 0.2 +
                          (30 * _backgroundController.value),
                      left: MediaQuery.of(context).size.width * 0.6,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.02),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Main Content
            Column(
              children: [
                // Glass Header
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        border: const Border(
                          bottom: BorderSide(color: Colors.white30, width: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hari Ini Masak Apa?',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  foreground: Paint()
                                    ..shader =
                                        LinearGradient(
                                          colors: [
                                            Colors.purple.shade600,
                                            Colors.blue.shade600,
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(
                                            0.0,
                                            0.0,
                                            200.0,
                                            70.0,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 100,
                    ), // Add bottom padding for navigation
                    child: _renderContent(),
                  ),
                ),
              ],
            ),

            // Floating Glass Bottom Navigation
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: tabs.asMap().entries.map((entry) {
                          final index = entry.key;
                          final tab = entry.value;
                          final isActive = _activeTab == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeTab = index;
                                _selectedRecipeId = null;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutBack,
                              width: isActive ? 55 : 45,
                              height: isActive ? 55 : 45,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background liquid effect
                                  if (isActive)
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: tab.gradient,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: tab.gradient[0].withOpacity(
                                              0.4,
                                            ),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.6,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, -2),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Icon
                                  Icon(
                                    tab.icon,
                                    size: isActive ? 24 : 20,
                                    color: isActive
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Models
class TabItem {
  final String id;
  final IconData icon;
  final String label;
  final List<Color> gradient;

  TabItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.gradient,
  });
}

class Recipe {
  final int id;
  final String title;
  final String description;
  final int cookingTime;
  final String servingSize;
  final String difficulty;
  final String category;
  final double rating;
  final int reviewCount;
  final List<String> ingredients;
  final List<String> instructions;
  final String image;
  final NutritionalInfo nutritionalInfo;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.cookingTime,
    required this.servingSize,
    required this.difficulty,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.ingredients,
    required this.instructions,
    required this.image,
    required this.nutritionalInfo,
  });
}

class NutritionalInfo {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

// Sample Data
final List<Recipe> recipeDatabase = [
  Recipe(
    id: 1,
    title: 'Nasi Goreng Spesial',
    description: 'Nasi goreng dengan bumbu rempah pilihan dan telur mata sapi',
    cookingTime: 20,
    servingSize: '2 porsi',
    difficulty: 'Mudah',
    category: 'Makanan Utama',
    rating: 4.5,
    reviewCount: 128,
    ingredients: [
      '2 piring nasi putih',
      '2 butir telur',
      '3 siung bawang putih',
      '2 buah cabai merah',
      '2 sdm kecap manis',
      'Garam secukupnya',
    ],
    instructions: [
      'Panaskan minyak dalam wajan',
      'Tumis bawang putih hingga harum',
      'Masukkan telur, orak-arik hingga matang',
      'Tambahkan nasi putih, aduk rata',
      'Bumbui dengan kecap manis dan garam',
      'Sajikan selagi hangat',
    ],
    image: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=300',
    nutritionalInfo: NutritionalInfo(
      calories: 350,
      protein: 12,
      carbs: 45,
      fat: 8,
    ),
  ),
  Recipe(
    id: 2,
    title: 'Soto Ayam Bening',
    description: 'Soto ayam segar dengan kuah bening dan sayuran',
    cookingTime: 45,
    servingSize: '4 porsi',
    difficulty: 'Sedang',
    category: 'Sup',
    rating: 4.8,
    reviewCount: 89,
    ingredients: [
      '500g daging ayam',
      '2 liter air',
      '3 siung bawang putih',
      '1 ruas jahe',
      'Daun bawang',
      'Seledri',
    ],
    instructions: [
      'Rebus ayam dengan air hingga empuk',
      'Angkat ayam, suwir-suwir dagingnya',
      'Tumis bumbu halus hingga harum',
      'Masukkan tumisan ke kuah ayam',
      'Tambahkan sayuran, masak hingga layu',
      'Sajikan dengan pelengkap',
    ],
    image: 'https://images.unsplash.com/photo-1585206066689-a1fafda1905b?w=300',
    nutritionalInfo: NutritionalInfo(
      calories: 280,
      protein: 25,
      carbs: 15,
      fat: 6,
    ),
  ),
  Recipe(
    id: 3,
    title: 'Ayam Geprek Sambal Matah',
    description: 'Ayam crispy dengan sambal matah khas Bali yang segar',
    cookingTime: 35,
    servingSize: '2 porsi',
    difficulty: 'Sedang',
    category: 'Makanan Utama',
    rating: 4.7,
    reviewCount: 156,
    ingredients: [
      '2 potong ayam fillet',
      '5 cabai rawit',
      '3 batang serai',
      '5 lembar daun jeruk',
      '2 buah jeruk nipis',
      'Minyak untuk menggoreng',
    ],
    instructions: [
      'Marinasi ayam dengan bumbu',
      'Goreng ayam hingga crispy',
      'Geprek ayam dengan ulekan',
      'Buat sambal matah',
      'Siram ayam dengan sambal matah',
      'Sajikan dengan nasi hangat',
    ],
    image: 'https://images.unsplash.com/photo-1562967916-eb82221dfb92?w=300',
    nutritionalInfo: NutritionalInfo(
      calories: 420,
      protein: 35,
      carbs: 12,
      fat: 18,
    ),
  ),
];

// Screens
class RecipeListScreen extends StatefulWidget {
  final Function(String) onSelectRecipe;

  const RecipeListScreen({super.key, required this.onSelectRecipe});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<ApiRecipe> recipes = [];
  List<String> aiRecommendations = [];
  bool isLoading = true;
  String selectedMood = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      print('Loading recipes from API...');

      // Test API connection first
      final isConnected = await MasakApiService.testConnection();
      print('API connection status: $isConnected');

      // Load recipes from API (with multiple endpoint attempts)
      final recipeData = await MasakApiService.getAllRecipes(page: 1);
      print('API returned ${recipeData.length} recipes');

      if (recipeData.isNotEmpty) {
        final loadedRecipes = recipeData.map((json) {
          try {
            return ApiRecipe.fromJson(json);
          } catch (e) {
            print('Error parsing recipe: $e');
            print('Recipe data: $json');
            // Return a fallback recipe if parsing fails
            return ApiRecipe(
              key:
                  json['key'] ??
                  'unknown-${DateTime.now().millisecondsSinceEpoch}',
              title: json['title'] ?? 'Unknown Recipe',
              thumb: json['thumb'] ?? 'https://via.placeholder.com/300',
              times: json['times'] ?? '30 Menit',
              serving: json['serving'] ?? '2 Porsi',
              difficulty: json['difficulty'] ?? 'Mudah',
            );
          }
        }).toList();

        print('Converted to ${loadedRecipes.length} ApiRecipe objects');

        // Get AI recommendations (fallback to simple recommendations if Firebase fails)
        List<String> recommendations = [];
        try {
          // Convert ApiRecipe objects back to Map for AI service
          List<Map<String, dynamic>> recipeMapList = loadedRecipes
              .map(
                (recipe) => {
                  'key': recipe.key,
                  'title': recipe.title,
                  'thumb': recipe.thumb,
                  'times': recipe.times,
                  'serving': recipe.serving,
                  'difficulty': recipe.difficulty,
                },
              )
              .toList();

          recommendations = await FirebaseAIService.getAIRecommendations(
            availableRecipes: recipeMapList,
            moodContext: selectedMood,
          );
          print('AI recommendations: ${recommendations.length} items');
        } catch (e) {
          print('AI recommendations failed, using fallback: $e');
          // Fallback: just use first few recipes as recommendations
          recommendations = loadedRecipes.take(3).map((r) => r.key).toList();
        }

        setState(() {
          recipes = loadedRecipes;
          aiRecommendations = recommendations;
          isLoading = false;
        });

        print('Final state: ${recipes.length} recipes loaded');

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil memuat ${recipes.length} resep'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        print('No recipes found');
        setState(() {
          recipes = [];
          aiRecommendations = [];
          isLoading = false;
        });

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal memuat resep. Menggunakan data contoh.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() => isLoading = false);

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _onMoodSelected(String mood) {
    setState(() => selectedMood = mood);
    _loadData(); // Reload with mood context
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Tidak ada resep tersedia',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        20,
      ), // Extra bottom padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Daily Recommendations Section
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.10),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade500,
                                  Colors.pink.shade500,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getTimeGreeting(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    foreground: Paint()
                                      ..shader =
                                          LinearGradient(
                                            colors: [
                                              Colors.purple.shade600,
                                              Colors.pink.shade600,
                                            ],
                                          ).createShader(
                                            const Rect.fromLTWH(
                                              0.0,
                                              0.0,
                                              200.0,
                                              70.0,
                                            ),
                                          ),
                                  ),
                                ),
                                Text(
                                  'AI merekomendasikan untuk Anda hari ini',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _loadData,
                            icon: const Icon(Icons.refresh),
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // AI Recommended recipes
                      ...aiRecommendations.take(2).map((recipeKey) {
                        final recipe = recipes.firstWhere(
                          (r) => r.key == recipeKey,
                          orElse: () => recipes.isNotEmpty
                              ? recipes.first
                              : ApiRecipe(
                                  key: '',
                                  title: 'No Recipe',
                                  thumb: '',
                                  times: '',
                                  serving: '',
                                  difficulty: '',
                                ),
                        );
                        return _buildAIRecommendationCard(recipe);
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Mood Section
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.10),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade500,
                                  Colors.pink.shade500,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.restaurant,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Bagaimana perasaan Anda hari ini?',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMoodCard('😊', 'Senang', [
                            Colors.yellow.shade400,
                            Colors.orange.shade500,
                          ], 'senang'),
                          _buildMoodCard('😢', 'Sedih', [
                            Colors.blue.shade400,
                            Colors.purple.shade500,
                          ], 'sedih'),
                          _buildMoodCard('😴', 'Lelah', [
                            Colors.grey.shade400,
                            Colors.blue.shade400,
                          ], 'lelah'),
                          _buildMoodCard('😑', 'Bosan', [
                            Colors.green.shade400,
                            Colors.teal.shade500,
                          ], 'bosan'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Trending Section
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.red.shade500, Colors.orange.shade500],
                  ),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Resep Trending',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recipes.take(10).map((recipe) => _buildRecipeCard(recipe)),
        ],
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 10) return '🌅 Selamat Pagi!';
    if (hour < 15) return '☀️ Selamat Siang!';
    if (hour < 19) return '🌤️ Selamat Sore!';
    return '🌙 Selamat Malam!';
  }

  Widget _buildAIRecommendationCard(ApiRecipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.10),
                ],
              ),
              border: Border.all(
                color: Colors.purple.withOpacity(0.2),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                FirebaseAIService.saveUserInteraction(
                  recipeId: recipe.key,
                  recipeTitle: recipe.title,
                  actionType: 'view',
                );
                widget.onSelectRecipe(recipe.key);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: recipe.thumb,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 64,
                          height: 64,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 64,
                          height: 64,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  recipe.title,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.shade500,
                                      Colors.pink.shade500,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  recipe.difficulty,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.psychology,
                                size: 12,
                                color: Colors.purple,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Direkomendasikan AI berdasarkan preferensi Anda',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.purple,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${recipe.times} • ${recipe.serving} • ${recipe.difficulty}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodCard(
    String emoji,
    String label,
    List<Color> gradient,
    String moodKey,
  ) {
    final isSelected = selectedMood == moodKey;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onMoodSelected(moodKey),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradient,
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.10),
                          ],
                        ),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white.withOpacity(0.2),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(ApiRecipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.10),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                FirebaseAIService.saveUserInteraction(
                  recipeId: recipe.key,
                  recipeTitle: recipe.title,
                  actionType: 'view',
                );
                widget.onSelectRecipe(recipe.key);
              },
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: recipe.thumb,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white.withOpacity(0.3),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      recipe.difficulty,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAIService.saveUserInteraction(
                                        recipeId: recipe.key,
                                        recipeTitle: recipe.title,
                                        actionType: 'like',
                                      );
                                    },
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                recipe.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    recipe.times,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.people,
                                    size: 12,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    recipe.serving,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add a content section for the recipe card
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  recipe.times,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.people,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  recipe.serving,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.green.shade100,
                              ),
                              child: Text(
                                recipe.difficulty,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder screens
class RecipeSearchScreen extends StatefulWidget {
  final Function(String) onSelectRecipe;

  const RecipeSearchScreen({super.key, required this.onSelectRecipe});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ApiRecipe> searchResults = [];
  bool isLoading = false;

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final results = await MasakApiService.searchByIngredient(query);
      setState(() {
        searchResults = results
            .map((json) => ApiRecipe.fromJson(json))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari berdasarkan bahan...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _search,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Results
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : searchResults.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Mulai pencarian dengan memasukkan nama bahan',
                      style: GoogleFonts.poppins(color: Colors.grey.shade600),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final recipe = searchResults[index];
                    return _buildSearchResultCard(recipe);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(ApiRecipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.10),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: recipe.thumb,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade300,
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              title: Text(
                recipe.title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '${recipe.times} • ${recipe.difficulty}',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              onTap: () => widget.onSelectRecipe(recipe.key),
            ),
          ),
        ),
      ),
    );
  }
}

class AIAssistantScreen extends StatefulWidget {
  final Function(String) onSelectRecipe;

  const AIAssistantScreen({super.key, required this.onSelectRecipe});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  List<ApiRecipe> personalizedRecommendations = [];
  Map<String, dynamic> userPreferences = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAIRecommendations();
  }

  Future<void> _loadAIRecommendations() async {
    setState(() => isLoading = true);

    try {
      // Get user preferences
      userPreferences = await FirebaseAIService.getUserPreferences();

      // Get all recipes for AI processing
      final allRecipesRaw = await MasakApiService.getAllRecipes();
      final allRecipes = allRecipesRaw.cast<Map<String, dynamic>>();

      // Get AI recommendations
      final recommendations = await FirebaseAIService.getAIRecommendations(
        availableRecipes: allRecipes,
      );

      // Filter recipes based on recommendations
      final recommendedRecipes = allRecipes
          .where((recipe) => recommendations.contains(recipe['key']))
          .map((json) => ApiRecipe.fromJson(json))
          .toList();

      setState(() {
        personalizedRecommendations = recommendedRecipes;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading AI recommendations: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Assistant Header
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                        ),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Smart Assistant',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Rekomendasi personal berdasarkan preferensi Anda',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Recommendations List
          Text(
            'Rekomendasi untuk Anda',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Show recommendations or message
          isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: CircularProgressIndicator(),
                  ),
                )
              : personalizedRecommendations.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.psychology_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada rekomendasi',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mulai berinteraksi dengan resep untuk mendapatkan rekomendasi AI',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: personalizedRecommendations.map((recipe) {
                    return _buildAIRecommendationCard(recipe);
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendationCard(ApiRecipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.10),
                ],
              ),
              border: Border.all(
                color: Colors.purple.withOpacity(0.2),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                FirebaseAIService.saveUserInteraction(
                  recipeId: recipe.key,
                  recipeTitle: recipe.title,
                  actionType: 'view',
                );
                widget.onSelectRecipe(recipe.key);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: recipe.thumb,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 64,
                          height: 64,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 64,
                          height: 64,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  recipe.title,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.shade500,
                                      Colors.pink.shade500,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  'AI',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.psychology,
                                size: 12,
                                color: Colors.purple,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Rekomendasi AI berdasarkan preferensi Anda',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${recipe.times} • ${recipe.serving} • ${recipe.difficulty}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteRecipesScreen extends StatelessWidget {
  final Function(String) onSelectRecipe;

  const FavoriteRecipesScreen({super.key, required this.onSelectRecipe});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Favorite Recipes Screen - Coming Soon'));
  }
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('User Profile Screen - Coming Soon'));
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  final VoidCallback onBack;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    required this.onBack,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  ApiRecipeDetail? recipeDetail;
  bool isLoading = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadRecipeDetail();
  }

  Future<void> _loadRecipeDetail() async {
    setState(() => isLoading = true);

    try {
      final detail = await MasakApiService.getRecipeDetail(widget.recipeId);
      if (detail != null) {
        setState(() {
          recipeDetail = ApiRecipeDetail.fromJson(detail);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading recipe detail: $e');
      setState(() => isLoading = false);
    }
  }

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);

    if (recipeDetail != null) {
      FirebaseAIService.saveUserInteraction(
        recipeId: widget.recipeId,
        recipeTitle: recipeDetail!.title,
        actionType: isFavorite ? 'like' : 'dislike',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (recipeDetail == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              Text(
                'Resep tidak ditemukan',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: widget.onBack,
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb),
              const Color(0xFFf5576c),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Header with image
            Container(
              height: 300,
              child: Stack(
                children: [
                  // Background image
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: CachedNetworkImage(
                      imageUrl: recipeDetail!.thumb,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),

                  // Back button and favorite
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: widget.onBack,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleFavorite,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Recipe title and info
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipeDetail!.title,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(
                              Icons.access_time,
                              recipeDetail!.times,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              Icons.people,
                              recipeDetail!.servings,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              Icons.star,
                              recipeDetail!.difficulty,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          // Tab bar
                          Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              indicator: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tabs: const [
                                Tab(text: 'Bahan'),
                                Tab(text: 'Langkah'),
                                Tab(text: 'Nutrisi'),
                              ],
                            ),
                          ),

                          // Tab content
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildIngredientsTab(),
                                _buildInstructionsTab(),
                                _buildNutritionTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipeDetail!.ingredient.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  recipeDetail!.ingredient[index],
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipeDetail!.instructions.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    recipeDetail!.instructions[index],
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionTab() {
    if (recipeDetail!.nutrition == null) {
      return Center(
        child: Text(
          'Informasi nutrisi tidak tersedia',
          style: GoogleFonts.poppins(color: Colors.grey.shade600),
        ),
      );
    }

    final nutrition = recipeDetail!.nutrition!;
    final nutritionData = [
      {'label': 'Kalori', 'value': nutrition.calories, 'unit': 'kcal'},
      {'label': 'Protein', 'value': nutrition.protein, 'unit': 'g'},
      {'label': 'Karbohidrat', 'value': nutrition.carbohydrate, 'unit': 'g'},
      {'label': 'Lemak', 'value': nutrition.fat, 'unit': 'g'},
      {'label': 'Serat', 'value': nutrition.fiber, 'unit': 'g'},
      {'label': 'Gula', 'value': nutrition.sugar, 'unit': 'g'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: nutritionData.length,
      itemBuilder: (context, index) {
        final item = nutritionData[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['label'] as String,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              Text(
                '${item['value']} ${item['unit']}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
