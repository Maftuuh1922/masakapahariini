import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/ai_assistant_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masak Apa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA855F7), // Purple-500
          brightness: Brightness.dark,
          primary: const Color(0xFFA855F7), // Purple-500
          secondary: const Color(0xFF8B5CF6), // Purple-600
          surface: const Color(0xFF1E1B2E), // Dark purple-gray
          background: const Color(0xFF111827), // Dark gray
          onSurface: Colors.white,
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        scaffoldBackgroundColor: const Color(
          0xFF0F0F23,
        ), // Very dark blue-purple
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1B2E), // Dark purple card
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF2D2B42), width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F23),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
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

class _AppContentState extends State<AppContent> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RecipeListScreen(),
    const SearchScreen(),
    const AIAssistantScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tambah extendBody untuk membuat body extend di belakang bottom nav
      extendBody: true,
      floatingActionButton: null, // Hapus FAB dari scaffold karena sudah custom
      floatingActionButtonLocation:
          null, // Hapus location karena FAB sudah custom
      body: Stack(
        children: [
          // Main content
          _screens[_currentIndex],

          // Custom floating bottom navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E), // Dark gray seperti di gambar
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: const Border(
                  top: BorderSide(color: Color(0xFF2C2C2E), width: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSimpleNavItem(0, Icons.home, 'Home'),
                      _buildSimpleNavItem(1, Icons.search, 'Search'),
                      _buildSimpleNavItem(2, Icons.auto_awesome, 'AI'),
                      _buildSimpleNavItem(3, Icons.favorite, 'Favorites'),
                      _buildSimpleNavItem(4, Icons.person, 'Profile'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleNavItem(int index, IconData icon, String label) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF8B5CF6) // Purple untuk active
                  : const Color(0xFF8E8E93), // Abu-abu seperti di gambar
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: isActive
                    ? const Color(0xFF8B5CF6) // Purple untuk active
                    : const Color(0xFF8E8E93), // Abu-abu seperti di gambar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
