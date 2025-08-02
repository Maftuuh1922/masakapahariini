import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  String? _selectedRecipeId;
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Recipe Detail - Coming Soon'),
          ],
        ),
      );
    }

    switch (_activeTab) {
      case 0:
        return const RecipeListScreen();
      case 1:
        return const RecipeSearchScreen();
      case 2:
        return const AIAssistantScreen();
      case 3:
        return const FavoriteRecipesScreen();
      case 4:
        return const UserProfileScreen();
      default:
        return const RecipeListScreen();
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
            // Liquid floating bubbles
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: 80 + (50 * _backgroundController.value),
                      left: MediaQuery.of(context).size.width * 0.1,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.4 + (40 * (1 - _backgroundController.value)),
                      right: MediaQuery.of(context).size.width * 0.15,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.2 + (30 * _backgroundController.value),
                      left: MediaQuery.of(context).size.width * 0.6,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.02),
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
                            Colors.white.withOpacity(0.1),
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
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hari Ini Masak Apa?',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [Colors.purple.shade600, Colors.blue.shade600],
                                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
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
            
            // Floating Glass Bottom Navigation
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -8),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutBack,
                              width: isActive ? 55 : 45,
                              height: isActive ? 55 : 45,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background liquid effect
                                  if (isActive)
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 400),
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: tab.gradient,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: tab.gradient[0].withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.6),
                                            blurRadius: 6,
                                            offset: const Offset(0, -2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  
                                  // Icon
                                  Icon(
                                    tab.icon,
                                    size: isActive ? 24 : 20,
                                    color: isActive ? Colors.white : Colors.grey.shade600,
                                  ),
                                ],
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

// Placeholder screens
class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

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
                      
                      // Sample recommendation cards
                      _buildSampleRecipeCard('Nasi Goreng Spesial', 'Mudah • 20 menit • 2 porsi'),
                      const SizedBox(height: 12),
                      _buildSampleRecipeCard('Soto Ayam Bening', 'Sedang • 45 menit • 4 porsi'),
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
          
          // Sample trending recipes
          _buildSampleRecipeCard('Ayam Geprek Sambal Matah', 'Sedang • 35 menit • 2 porsi'),
          const SizedBox(height: 12),
          _buildSampleRecipeCard('Rendang Daging Sapi', 'Sulit • 3 jam • 6 porsi'),
          const SizedBox(height: 12),
          _buildSampleRecipeCard('Gado-gado Jakarta', 'Mudah • 25 menit • 3 porsi'),
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

  Widget _buildSampleRecipeCard(String title, String subtitle) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade300, Colors.pink.shade300],
                ),
              ),
              child: const Icon(Icons.restaurant, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
}

class RecipeSearchScreen extends StatelessWidget {
  const RecipeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Recipe Search - Coming Soon'),
        ],
      ),
    );
  }
}

class AIAssistantScreen extends StatelessWidget {
  const AIAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('AI Assistant - Coming Soon'),
        ],
      ),
    );
  }
}

class FavoriteRecipesScreen extends StatelessWidget {
  const FavoriteRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Favorite Recipes - Coming Soon'),
        ],
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('User Profile - Coming Soon'),
        ],
      ),
    );
  }
}
