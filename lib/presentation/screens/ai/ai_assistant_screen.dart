import 'package:flutter/material.dart';
import '../../widgets/common/custom_app_bar.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({Key? key}) : super(key: key);

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, dynamic>> _quickQuestions = [
    {
      'icon': '💭',
      'question': 'Mau masak apa hari ini?',
    },
    {
      'icon': '🍳',
      'question': 'Resep cepat untuk sarapan',
    },
    {
      'icon': '🥗',
      'question': 'Masakan sehat dan bergizi',
    },
    {
      'icon': '⚡',
      'question': 'Resep untuk pemula',
    },
    {
      'icon': '💕',
      'question': 'Masakan romantis untuk date',
    },
    {
      'icon': '🍜',
      'question': 'Comfort food saat hujan',
    },
  ];

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
                subtitle: '🤖 AI Smart Assistant',
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // AI Features Cards
                      _buildAIFeaturesGrid(),
                      
                      const SizedBox(height: 24),
                      
                      // Quick Questions
                      _buildQuickQuestions(),
                      
                      const SizedBox(height: 24),
                      
                      // AI Chat Info
                      _buildAIChatInfo(),
                    ],
                  ),
                ),
              ),
              
              // Chat Input
              _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIFeaturesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Smart Assistant',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              icon: '📷',
              title: 'Photo Recognition',
              subtitle: 'Foto bahan untuk rekomendasi otomatis',
              onTap: () {
                // Navigate to camera screen
              },
            ),
            _buildFeatureCard(
              icon: '⚙️',
              title: 'Smart Recommendations',
              subtitle: 'Rekomendasi berdasarkan mood & selera',
              onTap: () {
                // Show smart recommendations
              },
            ),
            _buildFeatureCard(
              icon: '👨‍🍳',
              title: 'Cooking Assistant',
              subtitle: 'Panduan step by step dengan timer',
              onTap: () {
                // Navigate to cooking assistant
              },
            ),
            _buildFeatureCard(
              icon: '⚡',
              title: 'Quick Recipes',
              subtitle: 'Resep cepat dalam 15 menit',
              onTap: () {
                // Show quick recipes
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.flash_on,
              color: Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 8),
            Text(
              'Pertanyaan Cepat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _quickQuestions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final question = _quickQuestions[index];
            return Card(
              elevation: 1,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                  child: Text(
                    question['icon'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                title: Text(
                  question['question'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF8B5CF6),
                ),
                onTap: () {
                  _chatController.text = question['question'];
                  // Process the question
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAIChatInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Color(0xFF8B5CF6),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Halo! Saya AI Assistant untuk membantu Anda menemukan resep yang sempurna. Apa yang bisa saya bantu hari ini? 🍳',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _chatController,
                decoration: InputDecoration(
                  hintText: 'Tanya AI tentang resep...',
                  prefixIcon: const Icon(Icons.chat_bubble_outline),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_chatController.text.isNotEmpty) {
                        // Process chat message
                        _chatController.clear();
                      }
                    },
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    // Process chat message
                    _chatController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
