import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/category_grid.dart';
import 'widgets/trending_recipes.dart';
import '../../../data/providers/recipe_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['Makanan', 'Minuman', 'Cemilan', 'Kue'];
  String selectedCategory = 'Makanan';

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().loadTrendingRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            const SliverToBoxAdapter(
              child: CustomAppBar(
                title: 'Hari Ini Masak Apa?',
              ),
            ),
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) => SearchBarWidget(),
                ),
              ),
            ),
            // Categories
            // ...existing code...
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CategoryGrid(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: onCategorySelected,
                ),
              ),
            ),
            // Trending Recipes
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TrendingRecipes(recipes: context.watch<RecipeProvider>().trendingRecipes),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

