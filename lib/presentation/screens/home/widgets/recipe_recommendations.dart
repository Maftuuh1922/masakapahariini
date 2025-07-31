import 'package:flutter/material.dart';

class RecipeRecommendations extends StatelessWidget {
  final String category;
  final String mood;

  const RecipeRecommendations({
    Key? key,
    required this.category,
    required this.mood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recommendations = _getRecommendations();
    
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getRecommendationTitle(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final recipe = recommendations[index];
              return Container(
                width: 200,
                margin: EdgeInsets.only(
                  right: index == recommendations.length - 1 ? 0 : 12,
                ),
                child: _buildRecommendationCard(recipe),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getRecommendationTitle() {
    if (mood.isEmpty) {
      return 'Rekomendasi $category';
    }
    
    switch (mood) {
      case 'Senang':
        return 'Resep untuk merayakan kebahagiaan! 🎉';
      case 'Sedih':
        return 'Comfort food untuk menghibur 🤗';
      case 'Lelah':
        return 'Resep praktis dan mudah 😌';
      case 'Excited':
        return 'Resep menantang untuk dicoba! 🔥';
      default:
        return 'Rekomendasi untuk Anda';
    }
  }

  List<RecipeRecommendation> _getRecommendations() {
    // Mock data - replace with actual data from provider
    if (mood == 'Senang') {
      return [
        RecipeRecommendation(
          name: 'Gado-Gado Jakarta',
          difficulty: 'Sedang',
          time: '30m',
          portions: '3 porsi',
          image: 'assets/images/gado_gado.jpg',
          rating: 4.8,
          isPopular: true,
        ),
        RecipeRecommendation(
          name: 'Es Cendol Durian',
          difficulty: 'Mudah',
          time: '15m',
          portions: '2 porsi',
          image: 'assets/images/cendol.jpg',
          rating: 4.6,
        ),
      ];
    } else if (mood == 'Sedih') {
      return [
        RecipeRecommendation(
          name: 'Sayur Lodeh',
          difficulty: 'Sedang',
          time: '25m',
          portions: '4 porsi',
          image: 'assets/images/sayur_lodeh.jpg',
          rating: 4.5,
        ),
        RecipeRecommendation(
          name: 'Bubur Ayam Kampung',
          difficulty: 'Mudah',
          time: '45m',
          portions: '3 porsi',
          image: 'assets/images/bubur_ayam.jpg',
          rating: 4.7,
        ),
      ];
    } else if (mood == 'Lelah') {
      return [
        RecipeRecommendation(
          name: 'Soto Ayam Bening',
          difficulty: 'Sedang',
          time: '60m',
          portions: '4 porsi',
          image: 'assets/images/soto_ayam.jpg',
          rating: 4.9,
          isEasy: true,
        ),
        RecipeRecommendation(
          name: 'Nasi Goreng Telur',
          difficulty: 'Mudah',
          time: '15m',
          portions: '2 porsi',
          image: 'assets/images/nasi_goreng.jpg',
          rating: 4.4,
          isEasy: true,
        ),
      ];
    }
    
    return [];
  }

  Widget _buildRecommendationCard(RecipeRecommendation recipe) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badges
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[200]!],
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.restaurant,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Badges
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (recipe.isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Populer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (recipe.isEasy) ...[
                        if (recipe.isPopular) const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Mudah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${recipe.difficulty} dan ${recipe.time}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recipe.portions,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 12,
                          color: Color(0xFFFBBF24),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          recipe.rating.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeRecommendation {
  final String name;
  final String difficulty;
  final String time;
  final String portions;
  final String image;
  final double rating;
  final bool isPopular;
  final bool isEasy;

  RecipeRecommendation({
    required this.name,
    required this.difficulty,
    required this.time,
    required this.portions,
    required this.image,
    required this.rating,
    this.isPopular = false,
    this.isEasy = false,
  });
}
