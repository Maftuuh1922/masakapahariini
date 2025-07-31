import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSearch;
  final Function()? onFilterTap;

  const SearchBarWidget({
    super.key,
    this.onSearch,
    this.onFilterTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Search Input
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: widget.onSearch,
                decoration: InputDecoration(
                  hintText: 'Temukan resep dari bahan yang ada',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            // Filter Button
            Container(
              width: 1,
              height: 20,
              color: Colors.grey[300],
            ),
            GestureDetector(
              onTap: widget.onFilterTap ?? () => _showFilterBottomSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.tune_rounded,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedDifficulty = '';
  String selectedTime = '';
  List<String> selectedIngredients = [];
  
  final List<String> difficulties = ['Mudah', 'Sedang', 'Sulit'];
  final List<String> timeRanges = ['< 15 menit', '15-30 menit', '30-60 menit', '> 1 jam'];
  final List<String> commonIngredients = [
    'Ayam', 'Daging', 'Ikan', 'Telur', 'Tahu', 'Tempe',
    'Nasi', 'Mie', 'Kentang', 'Wortel', 'Bawang', 'Cabai'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Resep',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedDifficulty = '';
                      selectedTime = '';
                      selectedIngredients.clear();
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Difficulty Filter
                const Text(
                  'Tingkat Kesulitan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: difficulties.map((difficulty) {
                    final isSelected = selectedDifficulty == difficulty;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDifficulty = isSelected ? '' : difficulty;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? const Color(0xFF8B5CF6)
                            : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                            ? null
                            : Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          difficulty,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // Time Filter
                const Text(
                  'Waktu Memasak',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: timeRanges.map((time) {
                    final isSelected = selectedTime == time;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTime = isSelected ? '' : time;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? const Color(0xFF8B5CF6)
                            : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                            ? null
                            : Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // Ingredients Filter
                const Text(
                  'Bahan Utama',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: commonIngredients.map((ingredient) {
                    final isSelected = selectedIngredients.contains(ingredient);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIngredients.remove(ingredient);
                          } else {
                            selectedIngredients.add(ingredient);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? const Color(0xFF8B5CF6)
                            : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                            ? null
                            : Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          ingredient,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                // Apply Filter Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Apply filters logic here
                      _applyFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Terapkan Filter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // Implement filter logic here
    // You can pass the selected filters back to parent widget
    final Map<String, dynamic> filters = {
      'difficulty': selectedDifficulty,
      'time': selectedTime,
      'ingredients': selectedIngredients,
    };
    
    // Example: Use a callback or provider to apply filters
    print('Applied filters: $filters');
  }
}