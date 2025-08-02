import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../ai/ai_assistant_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const AIAssistantScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Beranda',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search,
                  label: 'Cari',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.auto_awesome_outlined,
                  activeIcon: Icons.auto_awesome,
                  label: 'AI',
                  index: 2,
                  isSpecial: true,
                ),
                _buildNavItem(
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite,
                  label: 'Favorit',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profil',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    bool isSpecial = false,
  }) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSpecial && isSelected 
              ? const Color(0xFF8B5CF6) 
              : isSelected 
                  ? const Color(0xFF8B5CF6).withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSpecial && isSelected
                  ? Colors.white
                  : isSelected
                      ? const Color(0xFF8B5CF6)
                      : theme.textTheme.bodySmall?.color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSpecial && isSelected
                    ? Colors.white
                    : isSelected
                        ? const Color(0xFF8B5CF6)
                        : theme.textTheme.bodySmall?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
