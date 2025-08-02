import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/recipe_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/recipe/recipe_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FA), Color(0xFFEDE9FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              const CustomAppBar(
                title: 'Hari Ini Masak Apa?',
                subtitle: '❤️ Resep Favorit Anda',
              ),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari resep favorit...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              
              // Favorites List
              Expanded(
                child: Consumer<RecipeProvider>(
                  builder: (context, provider, child) {
                    final favoriteRecipes = provider.favoriteRecipes
                        .where((recipe) => recipe.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                    if (favoriteRecipes.isEmpty && _searchQuery.isEmpty) {
                      return _buildEmptyState();
                    }

                    if (favoriteRecipes.isEmpty && _searchQuery.isNotEmpty) {
                      return _buildNoSearchResults();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: favoriteRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = favoriteRecipes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              // Navigate to recipe detail
                            },
                            onFavoriteToggle: () {
                              provider.toggleFavorite(recipe);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_outline,
                size: 64,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Resep Favorit',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Masuk atau daftar untuk menyimpan resep favorit Anda. Temukan resep yang Anda suka dan tambahkan ke favorit!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to login/register
                    },
                    child: const Text('Masuk'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to register
                    },
                    child: const Text('Daftar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Switch to home tab to explore recipes
              },
              child: const Text('Jelajahi Resep'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak Ditemukan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak ada resep favorit yang cocok dengan pencarian "$_searchQuery"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Text('Hapus Pencarian'),
            ),
          ],
        ),
      ),
    );
  }
}
