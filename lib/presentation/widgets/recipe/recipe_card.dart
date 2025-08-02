import 'package:flutter/material.dart';
import '../../../data/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool showMatchPercentage;
  final int? matchPercentage;

  const RecipeCard({
    Key? key,
    required this.recipe,
    this.onTap,
    this.onFavoriteToggle,
    this.showMatchPercentage = false,
    this.matchPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: recipe.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(recipe.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Default image placeholder
                  if (recipe.imageUrl == null)
                    Center(
                      child: Text(
                        recipe.emoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: recipe.isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: onFavoriteToggle,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  
                  // Match percentage
                  if (showMatchPercentage && matchPercentage != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$matchPercentage%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  
                  // Category tag
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: recipe.tagColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        recipe.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Recipe Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Description
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Time, Servings, Difficulty
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.access_time,
                        text: recipe.time,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.people,
                        text: '${recipe.servings} porsi',
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(recipe.difficulty).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          recipe.difficulty,
                          style: TextStyle(
                            color: _getDifficultyColor(recipe.difficulty),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Rating
                  if (recipe.rating > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < recipe.rating.floor()
                                ? Icons.star
                                : index < recipe.rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            size: 16,
                            color: const Color(0xFFFBBF24),
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          recipe.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (recipe.reviewCount > 0) ...[
                          Text(
                            ' (${recipe.reviewCount})',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'mudah':
        return const Color(0xFF10B981);
      case 'sedang':
        return const Color(0xFF8B5CF6);
      case 'sulit':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF8B5CF6);
    }
  }
}
