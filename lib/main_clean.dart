import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
  int? _selectedRecipeId;
  late AnimationController _backgroundController;

  final List<TabItem> tabs = [
    TabItem(id: 'home', icon: Icons.home, label: 'Beranda', gradient: [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)]),
    TabItem(id: 'search', icon: Icons.search, label: 'Cari', gradient: [const Color(0xFF10B981), const Color(0xFF3B82F6)]),
    TabItem(id: 'ai', icon: Icons.auto_awesome, label: 'AI', gradient: [const Color(0xFF8B5CF6), const Color(0xFFEC4899)]),
    TabItem(id: 'favorites', icon: Icons.favorite, label: 'Favorit', gradient: [const Color(0xFFEC4899), const Color(0xFFEF4444)]),
    TabItem(id: 'profile', icon: Icons.person, label: 'Profil', gradient: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]),
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
        return RecipeListScreen(onSelectRecipe: (id) => setState(() => _selectedRecipeId = id));
      case 1:
        return RecipeSearchScreen(onSelectRecipe: (id) => setState(() => _selectedRecipeId = id));
      case 2:
        return AIAssistantScreen(onSelectRecipe: (id) => setState(() => _selectedRecipeId = id));
      case 3:
        return FavoriteRecipesScreen(onSelectRecipe: (id) => setState(() => _selectedRecipeId = id));
      case 4:
        return const UserProfileScreen();
      default:
        return RecipeListScreen(onSelectRecipe: (id) => setState(() => _selectedRecipeId = id));
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
            // Animated Background Bubbles
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: 50 + (100 * _backgroundController.value),
                      left: MediaQuery.of(context).size.width * 0.25,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.blue.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.33 + (80 * (1 - _backgroundController.value)),
                      right: MediaQuery.of(context).size.width * 0.25,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.12),
                              Colors.purple.withOpacity(0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.25 + (60 * _backgroundController.value),
                      left: MediaQuery.of(context).size.width * 0.33,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.pink.withOpacity(0.06),
                              Colors.transparent,
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
                            Colors.white.withOpacity(0.15),
                          ],
                        ),
                        border: const Border(
                          bottom: BorderSide(
                            color: Colors.white30,
                            width: 0.5,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hari Ini Masak Apa?',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
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
                
                // Main Content
                Expanded(
                  child: _renderContent(),
                ),
              ],
            ),
            
            // Glass Bottom Navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.15),
                        ],
                      ),
                      border: const Border(
                        top: BorderSide(
                          color: Colors.white30,
                          width: 0.5,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
                                duration: const Duration(milliseconds: 300),
                                transform: Matrix4.identity()..scale(isActive ? 1.05 : 1.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: isActive 
                                        ? LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.4),
                                              Colors.white.withOpacity(0.2),
                                            ],
                                          )
                                        : null,
                                    border: isActive 
                                        ? Border.all(color: Colors.white.withOpacity(0.4), width: 0.5)
                                        : null,
                                    boxShadow: isActive 
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          gradient: isActive
                                              ? LinearGradient(colors: tab.gradient)
                                              : null,
                                          color: isActive ? null : Colors.transparent,
                                        ),
                                        child: Icon(
                                          tab.icon,
                                          size: 16,
                                          color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        tab.label,
                                        style: GoogleFonts.poppins(
                                          fontSize: 9,
                                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                          color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                                          shadows: isActive ? [
                                            Shadow(
                                              color: Colors.black.withOpacity(0.3),
                                              offset: const Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ] : null,
                                        ),
                                      ),
                                      if (isActive)
                                        Container(
                                          margin: const EdgeInsets.only(top: 1),
                                          width: 2,
                                          height: 2,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(colors: tab.gradient),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.6),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
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
    nutritionalInfo: NutritionalInfo(calories: 350, protein: 12, carbs: 45, fat: 8),
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
    nutritionalInfo: NutritionalInfo(calories: 280, protein: 25, carbs: 15, fat: 6),
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
    nutritionalInfo: NutritionalInfo(calories: 420, protein: 35, carbs: 12, fat: 18),
  ),
];

// Screens
class RecipeListScreen extends StatelessWidget {
  final Function(int) onSelectRecipe;

  const RecipeListScreen({super.key, required this.onSelectRecipe});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
                                colors: [Colors.purple.shade500, Colors.pink.shade500],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
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
                                      ..shader = LinearGradient(
                                        colors: [Colors.purple.shade600, Colors.pink.shade600],
                                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
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
                            onPressed: () {},
                            icon: const Icon(Icons.refresh),
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...recipeDatabase.take(2).map((recipe) => _buildAIRecommendationCard(recipe)),
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
                                colors: [Colors.orange.shade500, Colors.pink.shade500],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
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
                          _buildMoodCard('😊', 'Senang', [Colors.yellow.shade400, Colors.orange.shade500]),
                          _buildMoodCard('😢', 'Sedih', [Colors.blue.shade400, Colors.purple.shade500]),
                          _buildMoodCard('😴', 'Lelah', [Colors.grey.shade400, Colors.blue.shade400]),
                          _buildMoodCard('😑', 'Bosan', [Colors.green.shade400, Colors.teal.shade500]),
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
                child: const Icon(Icons.trending_up, color: Colors.white, size: 20),
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
          ...recipeDatabase.map((recipe) => _buildRecipeCard(recipe)),
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

  Widget _buildAIRecommendationCard(Recipe recipe) {
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
              onTap: () => onSelectRecipe(recipe.id),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(recipe.image),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
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
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: [Colors.purple.shade500, Colors.pink.shade500],
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
                              const Icon(Icons.psychology, size: 12, color: Colors.purple),
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
                            '${recipe.cookingTime}m • ${recipe.servingSize} • ${recipe.difficulty}',
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

  Widget _buildMoodCard(String emoji, String label, List<Color> gradient) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
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

  Widget _buildRecipeCard(Recipe recipe) {
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
              onTap: () => onSelectRecipe(recipe.id),
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
                      image: DecorationImage(
                        image: NetworkImage(recipe.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white.withOpacity(0.3),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                              const Icon(Icons.favorite_border, color: Colors.white, size: 20),
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
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 12, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.cookingTime}m',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.people, size: 12, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(
                                recipe.servingSize,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.star, size: 12, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                recipe.rating.toString(),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      recipe.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
class RecipeSearchScreen extends StatelessWidget {
  final Function(int) onSelectRecipe;

  const RecipeSearchScreen({super.key, required this.onSelectRecipe});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Recipe Search Screen - Coming Soon'),
    );
  }
}

class AIAssistantScreen extends StatelessWidget {
  final Function(int) onSelectRecipe;

  const AIAssistantScreen({super.key, required this.onSelectRecipe});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('AI Assistant Screen - Coming Soon'),
    );
  }
}

class FavoriteRecipesScreen extends StatelessWidget {
  final Function(int) onSelectRecipe;

  const FavoriteRecipesScreen({super.key, required this.onSelectRecipe});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Favorite Recipes Screen - Coming Soon'),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('User Profile Screen - Coming Soon'),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final int recipeId;
  final VoidCallback onBack;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final recipe = recipeDatabase.firstWhere((r) => r.id == recipeId);
    
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onBack,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(recipe.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Recipe Detail for:',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  recipe.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Coming Soon...',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
