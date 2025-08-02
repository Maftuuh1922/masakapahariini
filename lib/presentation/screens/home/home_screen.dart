import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/recipe/recipe_card.dart';
import '../../../data/providers/recipe_provider.dart';
import '../../../data/models/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMood = '';
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> moods = [
    {
      'emoji': '😊',
      'label': 'Senang',
      'colors': [Color(0xFFFBBF24), Color(0xFFF59E0B)]
    },
    {
      'emoji': '😢',
      'label': 'Sedih',
      'colors': [Color(0xFF3B82F6), Color(0xFF1D4ED8)]
    },
    {
      'emoji': '😴',
      'label': 'Lelah',
      'colors': [Color(0xFF8B5CF6), Color(0xFF7C3AED)]
    },
  ];

  final List<Recipe> mockRecipes = [
    Recipe(
      id: 1,
      title: 'Gado-Gado Jakarta',
      description: 'Salad sayuran tradisional dengan bumbu kacang yang gurih',
      time: '30m',
      servings: 3,
      difficulty: 'Mudah',
      category: 'Mudah',
      tagColor: const Color(0xFF10B981),
      emoji: '🥗',
      ingredients: ['Tahu', 'Tempe', 'Sayuran'],
      instructions: ['Step 1', 'Step 2'],
      nutritionalInfo: '350 kalori',
      rating: 4.4,
      reviewCount: 120,
    ),
    Recipe(
      id: 2,
      title: 'Sayur Lodeh',
      description: 'Cocok untuk waktu sekarang dan mudah dibuat',
      time: '25m',
      servings: 4,
      difficulty: 'Sedang',
      category: 'Sedang',
      tagColor: const Color(0xFF8B5CF6),
      emoji: '🍲',
      ingredients: ['Sayuran', 'Santan'],
      instructions: ['Step 1', 'Step 2'],
      nutritionalInfo: '180 kalori',
    ),
    Recipe(
      id: 3,
      title: 'Nasi Goreng Sederhana',
      description: 'Pelengkap bersenandung favoritu tradisional best food lagi',
      time: '15m',
      servings: 2,
      difficulty: 'Mudah',
      category: 'Mudah',
      tagColor: const Color(0xFF10B981),
      emoji: '🍛',
      ingredients: ['Nasi', 'Telur', 'Bawang'],
      instructions: ['Step 1', 'Step 2'],
      nutritionalInfo: '420 kalori',
      rating: 4.5,
      reviewCount: 89,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FA), Color(0xFFEDE9FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              const SliverToBoxAdapter(
                child: CustomAppBar(
                  title: 'Hari Ini Masak Apa?',
                  subtitle: '🔍 Temukan resep dari bahan yang ada',
                ),
              ),
              
              // Mood Selector with Welcome Message
              SliverToBoxAdapter(
                child: _buildMoodSelector(),
              ),
              
              // Quick Question Section
              SliverToBoxAdapter(
                child: _buildQuickQuestionSection(),
              ),
              
              // Recipe Recommendations
              SliverToBoxAdapter(
                child: _buildRecommendationsSection(),
              ),
              
              // Trending Recipes
              SliverToBoxAdapter(
                child: _buildTrendingSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '✨',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat Sore!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '🤔 marekomendasikan untuk Anda hari ini',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Mood Question
          Text(
            'Bagaimana perasaan Anda hari ini?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Mood Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: moods.map((mood) {
              final isSelected = selectedMood == mood['label'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMood = mood['label'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected 
                        ? LinearGradient(colors: mood['colors'])
                        : null,
                    color: isSelected ? null : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.transparent 
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mood['emoji'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        mood['label'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuestionSection() {
    if (selectedMood.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bagaimana perasaan Anda hari ini?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Pilih sesuai mood Anda',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            height: 100,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildRecommendationCard('Nasi Goreng Sederhana', 'Mudah'),
                _buildRecommendationCard('Ayam Bakar Bumbu Rujak', 'Sedang'),
                _buildRecommendationCard('Nasi Goreng...', 'Mudah'),
              ],
            ),
          ),
          
          // Page indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index 
                      ? const Color(0xFF8B5CF6) 
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String difficulty) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restaurant, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      difficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Text(
                '92%',
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(8),
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockRecipes.length,
              itemBuilder: (context, index) {
                final recipe = mockRecipes[index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 12),
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      // Navigate to recipe detail
                    },
                    onFavoriteToggle: () {
                      // Toggle favorite
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Resep Trending',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Single trending recipe with large image
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text('🍛', style: TextStyle(fontSize: 64)),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Mudah',
                            style: TextStyle(
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nasi Goreng Spesial',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Resep nasi goreng yang enak dan mudah dibuat untuk keluarga',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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

