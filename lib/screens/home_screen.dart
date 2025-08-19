import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/api_models.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<ApiRecipe> recipes = [];
  List<String> categories = [
    'Semua',
    'Nasi',
    'Ayam',
    'Sup',
    'Minuman',
    'Dessert',
  ];
  String selectedCategory = 'Semua';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      final mockData = _getMockRecipeData();
      setState(() {
        recipes = mockData.map((json) => ApiRecipe.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading recipes: $e');
      setState(() => isLoading = false);
    }
  }

  List<Map<String, dynamic>> _getMockRecipeData() {
    return [
      {
        'key': 'nasi-goreng-spesial',
        'title': 'Nasi Goreng Spesial',
        'thumb':
            'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
        'times': '20 Menit',
        'serving': '2 Porsi',
        'difficulty': 'Mudah',
      },
      {
        'key': 'soto-ayam-bening',
        'title': 'Soto Ayam Bening',
        'thumb':
            'https://images.unsplash.com/photo-1585206066689-a1fafda1905b?w=400',
        'times': '45 Menit',
        'serving': '4 Porsi',
        'difficulty': 'Sedang',
      },
      {
        'key': 'ayam-geprek-sambal-matah',
        'title': 'Ayam Geprek Sambal Matah',
        'thumb':
            'https://images.unsplash.com/photo-1562967916-eb82221dfb92?w=400',
        'times': '35 Menit',
        'serving': '2 Porsi',
        'difficulty': 'Sedang',
      },
      {
        'key': 'rendang-daging-sapi',
        'title': 'Rendang Daging Sapi',
        'thumb':
            'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
        'times': '2 Jam',
        'serving': '6 Porsi',
        'difficulty': 'Sulit',
      },
      {
        'key': 'gado-gado-betawi',
        'title': 'Gado-Gado Betawi',
        'thumb':
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
        'times': '30 Menit',
        'serving': '3 Porsi',
        'difficulty': 'Mudah',
      },
      {
        'key': 'martabak-manis',
        'title': 'Martabak Manis',
        'thumb':
            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
        'times': '25 Menit',
        'serving': '4 Porsi',
        'difficulty': 'Sedang',
      },
      {
        'key': 'bakso-malang',
        'title': 'Bakso Malang',
        'thumb':
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
        'times': '60 Menit',
        'serving': '3 Porsi',
        'difficulty': 'Sulit',
      },
      {
        'key': 'es-cendol',
        'title': 'Es Cendol',
        'thumb':
            'https://images.unsplash.com/photo-1563379091339-03246963d51a?w=400',
        'times': '15 Menit',
        'serving': '2 Porsi',
        'difficulty': 'Mudah',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          // App Bar dengan gradient yang menarik
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFF6B6B),
                      const Color(0xFFFFE66D),
                      const Color(0xFF4ECDC4),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Resep Nusantara',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Temukan ${recipes.length} resep lezat untuk keluarga',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white.withOpacity(0.6),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cari resep favorit kamu...',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category Filter
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final isSelected =
                            categories[index] == selectedCategory;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = categories[index];
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              right: index == categories.length - 1 ? 0 : 12,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        const Color(0xFFFF6B6B),
                                        const Color(0xFFFFE66D),
                                      ],
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0xFF3A3A3A),
                              ),
                            ),
                            child: Text(
                              categories[index],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recipe Grid
          isLoading
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFFFF6B6B),
                        ),
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _buildRecipeCard(recipes[index]);
                    }, childCount: recipes.length),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(ApiRecipe recipe) {
    return GestureDetector(
      onTap: () {
        print('Recipe tapped: ${recipe.title}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button overlay
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: recipe.thumb,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF3A3A3A),
                        child: Center(
                          child: Icon(
                            Icons.restaurant_menu_rounded,
                            color: Colors.white.withOpacity(0.3),
                            size: 32,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF3A3A3A),
                        child: Center(
                          child: Icon(
                            Icons.restaurant_menu_rounded,
                            color: Colors.white.withOpacity(0.3),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  // Difficulty badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(recipe.difficulty),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        recipe.difficulty,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.times,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.people_rounded,
                          size: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.serving,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'mudah':
        return const Color(0xFF4ECDC4);
      case 'sedang':
        return const Color(0xFFFFE66D);
      case 'sulit':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF6C757D);
    }
  }
}
