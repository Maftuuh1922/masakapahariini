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
  List<ApiRecipe> recommendations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      // Use mock data since API is not working
      final mockData = _getMockRecipeData();
      setState(() {
        recipes = mockData.map((json) => ApiRecipe.fromJson(json)).toList();
        recommendations = recipes
            .take(4)
            .toList(); // First 4 as recommendations
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: \$e');
      setState(() => isLoading = false);
    }
  }

  // Mock data method
  List<Map<String, dynamic>> _getMockRecipeData() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23), // Very dark blue-purple
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          backgroundColor: const Color(0xFF1E1B2E),
          color: const Color(0xFFA855F7),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Masak Apa',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Temukan resep favoritmu',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2937),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF374151),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatsCard(
                        'Total Resep',
                        '\${recipes.length}',
                        Icons.restaurant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatsCard(
                        'Rekomendasi',
                        '\${recommendations.length}',
                        Icons.star,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Cari Resep',
                        Icons.search,
                        () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        'AI Assistant',
                        Icons.smart_toy,
                        () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // AI Recommendations Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rekomendasi AI',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Lihat Semua',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFF10B981)),
                  )
                else
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        return _buildAIRecommendationCard(
                          recommendations[index],
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 32),

                // All Recipes Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Semua Resep',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2937),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF374151)),
                      ),
                      child: Text(
                        '\${recipes.length} resep',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8B5CF6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Recipe List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return _buildRecipeCard(recipes[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D2B42), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFFA855F7), size: 24),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA855F7), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIRecommendationCard(ApiRecipe recipe) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D2B42), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: recipe.thumb,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xFF2D2B42),
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    color: Color(0xFF9CA3AF),
                    size: 32,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF2D2B42),
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    color: Color(0xFF9CA3AF),
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF9CA3AF),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          recipe.times,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA855F7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      recipe.difficulty,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFA855F7),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(ApiRecipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D2B42), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: recipe.thumb,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFF2D2B42),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant,
                      color: Color(0xFF9CA3AF),
                      size: 24,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF2D2B42),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant,
                      color: Color(0xFF9CA3AF),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: const Color(0xFF9CA3AF),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          recipe.times,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.people_outline,
                        color: const Color(0xFF9CA3AF),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          recipe.serving,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA855F7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFA855F7).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      recipe.difficulty,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFA855F7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2B42),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA855F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
