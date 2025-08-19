import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/api_models.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<ApiRecipe> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final mockData = _getMockFavorites();
    setState(() {
      favoriteRecipes = mockData
          .map((json) => ApiRecipe.fromJson(json))
          .toList();
    });
  }

  List<Map<String, dynamic>> _getMockFavorites() {
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
        'key': 'rendang-daging-sapi',
        'title': 'Rendang Daging Sapi',
        'thumb':
            'https://images.unsplash.com/photo-1544025162-d76694265947?w=300',
        'times': '2 Jam',
        'serving': '6 Porsi',
        'difficulty': 'Sulit',
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
        'key': 'gado-gado-betawi',
        'title': 'Gado-Gado Betawi',
        'thumb':
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300',
        'times': '30 Menit',
        'serving': '3 Porsi',
        'difficulty': 'Mudah',
      },
    ];
  }

  void _removeFavorite(int index) {
    setState(() {
      favoriteRecipes.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Resep dihapus dari favorit',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2937),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B0D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorit',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${favoriteRecipes.length} resep tersimpan',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Color(0xFF10B981),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Premium',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Favorites List
            Expanded(
              child: favoriteRecipes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F2937),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF374151),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite_border,
                                    size: 48,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Belum Ada Favorit',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Mulai tambahkan resep ke favorit\nuntuk akses yang lebih mudah',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFF9CA3AF),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF10B981,
                                      ).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    'Jelajahi Resep',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: favoriteRecipes.length,
                      itemBuilder: (context, index) {
                        return _buildFavoriteCard(
                          favoriteRecipes[index],
                          index,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(ApiRecipe recipe, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF374151)),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to recipe detail
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Recipe Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: recipe.thumb,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFF374151),
                    child: const Icon(
                      Icons.restaurant,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFF374151),
                    child: const Icon(
                      Icons.restaurant,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Recipe Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: const Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.times,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.people,
                          size: 14,
                          color: const Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.serving,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF9CA3AF),
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
                        color: _getDifficultyColor(
                          recipe.difficulty,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        recipe.difficulty,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _getDifficultyColor(recipe.difficulty),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  IconButton(
                    onPressed: () => _removeFavorite(index),
                    icon: const Icon(
                      Icons.favorite,
                      color: Color(0xFF10B981),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF9CA3AF),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'mudah':
        return const Color(0xFF10B981);
      case 'sedang':
        return const Color(0xFF3B82F6);
      case 'sulit':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF9CA3AF);
    }
  }
}
