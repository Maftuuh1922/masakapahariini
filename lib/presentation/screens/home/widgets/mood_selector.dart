
import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final Function(String) onMoodSelected;

  const MoodSelector({
    Key? key,
    required this.selectedMood,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bagaimana perasaan Anda hari ini?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMoodButton(
              context,
              mood: 'Senang',
              emoji: '😊',
              color: const Color(0xFFFEF3C7),
              textColor: const Color(0xFFD97706),
            ),
            _buildMoodButton(
              context,
              mood: 'Sedih',
              emoji: '😢',
              color: const Color(0xFFDDD6FE),
              textColor: const Color(0xFF7C3AED),
            ),
            _buildMoodButton(
              context,
              mood: 'Lelah',
              emoji: '😴',
              color: const Color(0xFFD1FAE5),
              textColor: const Color(0xFF059669),
            ),
            _buildMoodButton(
              context,
              mood: 'Excited',
              emoji: '🤩',
              color: const Color(0xFFFECDD3),
              textColor: const Color(0xFFE11D48),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodButton(
    BuildContext context, {
    required String mood,
    required String emoji,
    required Color color,
    required Color textColor,
  }) {
    final isSelected = selectedMood == mood;
    
    return GestureDetector(
      onTap: () => onMoodSelected(mood),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? textColor : color,
          borderRadius: BorderRadius.circular(16),
          border: isSelected 
            ? Border.all(color: textColor, width: 2)
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              mood,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
