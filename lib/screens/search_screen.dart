import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/api_models.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ApiRecipe> searchResults = [];
  bool isLoading = false;

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => isLoading = true);

    try {
      // Use mock data for search since API is not working
      final mockData = _getMockRecipeData();
      final filteredResults = mockData
          .where(
            (recipe) => recipe['title'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();

      setState(() {
        searchResults = filteredResults
            .map((json) => ApiRecipe.fromJson(json))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() => isLoading = false);
    }
  }

  // Mock data method for search
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
      backgroundColor: const Color(0xFF0A0B0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Header
              Text(
                'Cari Resep',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Temukan resep favorit Anda',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF374151)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Cari resep...',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF9CA3AF),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF10B981),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _search,
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),

              const SizedBox(height: 24),

              // Search Results
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF10B981),
                        ),
                      )
                    : searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F2937),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF374151),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchController.text.isEmpty
                                        ? 'Mulai cari resep favoritmu'
                                        : 'Resep tidak ditemukan',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchController.text.isEmpty
                                        ? 'Ketik nama resep yang ingin kamu cari'
                                        : 'Coba kata kunci lain atau cari resep populer',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return _buildSearchResultCard(searchResults[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(ApiRecipe recipe) {
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
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF9CA3AF),
                size: 16,
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
