import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  bool isLoading = false;
  late AnimationController _animationController;

  // Quick suggestions untuk user
  final List<String> quickSuggestions = [
    "Bagaimana cara membuat nasi goreng yang enak?",
    "Tips masak ayam agar empuk",
    "Resep rendang yang mudah",
    "Cara membuat sambal yang pedas",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    setState(() {
      messages.add(
        ChatMessage(
          text:
              '👋 Halo! Saya Chef AI, asisten masak pintar Anda!\n\nSaya bisa membantu dengan:\n• Resep masakan Indonesia\n• Tips memasak\n• Saran bahan pengganti\n• Teknik memasak\n\nAda yang ingin ditanyakan?',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  Future<void> _sendMessage([String? predefinedText]) async {
    final text = predefinedText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      isLoading = true;
    });

    if (predefinedText == null) {
      _messageController.clear();
    }

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });

    // Simulate AI response
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      messages.add(
        ChatMessage(
          text: _generateAIResponse(text),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _generateAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('nasi goreng')) {
      return '🍳 **Tips Nasi Goreng Sempurna:**\n\n• Gunakan nasi yang sudah dingin (idealnya semalam)\n• Panaskan wajan dengan api besar\n• Tumis bumbu hingga harum dulu\n• Masukkan nasi, aduk rata dengan cepat\n• Tambahkan kecap manis untuk warna cantik\n• Jangan lupa telur dan sayuran!\n\n✨ Rahasia: Tambahkan sedikit terasi untuk rasa yang lebih gurih!';
    } else if (message.contains('ayam') && message.contains('empuk')) {
      return '🐔 **Cara Membuat Ayam Super Empuk:**\n\n• Marinasi dengan jeruk nipis 15 menit\n• Pukul-pukul daging ayam dengan punggung pisau\n• Rendam dalam susu 30 menit (opsional)\n• Masak dengan api sedang, jangan terburu-buru\n• Gunakan pressure cooker untuk hasil lebih cepat\n\n💡 Pro tip: Tambahkan sedikit baking soda saat marinasi!';
    } else if (message.contains('rendang')) {
      return '🥘 **Rendang Mudah untuk Pemula:**\n\n• Siapkan bumbu halus: cabai, bawang, jahe, kunyit\n• Masak daging dengan santan kental\n• Tambahkan daun jeruk dan serai\n• Masak dengan sabar, api kecil 2-3 jam\n• Aduk sesekali agar tidak gosong\n• Rendang matang saat berwarna coklat gelap\n\n🔥 Kunci sukses: Kesabaran adalah segalanya!';
    } else if (message.contains('sambal')) {
      return '🌶️ **Sambal Pedas Mantap:**\n\n• Pilih cabai rawit untuk pedas maksimal\n• Sangrai cabai dan bawang dulu\n• Tambahkan tomat untuk rasa segar\n• Ulek kasar, jangan terlalu halus\n• Beri garam dan gula secukupnya\n• Siram dengan minyak panas\n\n🔥 Level pedas bisa disesuaikan dengan jumlah cabai!';
    } else if (message.contains('halo') || message.contains('hai')) {
      return '👋 Halo juga! Senang bertemu dengan Anda!\n\nSaya siap membantu dengan semua kebutuhan memasak Anda. Mau tanya resep apa hari ini? 😊';
    } else if (message.contains('terima kasih') || message.contains('thanks')) {
      return '😊 Sama-sama! Senang bisa membantu!\n\nJangan ragu untuk bertanya lagi kapan saja. Selamat memasak dan semoga hasilnya lezat! 👨‍🍳✨';
    } else {
      return '🤔 **Saya siap membantu Anda!**\n\nSilakan tanyakan tentang:\n• Resep masakan Indonesia 🇮🇩\n• Tips dan trik memasak 👨‍🍳\n• Bahan pengganti 🔄\n• Teknik memasak 🔥\n• Penyimpanan makanan 📦\n\nApa yang ingin Anda ketahui lebih lanjut?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Custom App Bar dengan gradient
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 10,
              20,
              20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6366F1),
                  const Color(0xFF8B5CF6),
                  const Color(0xFFA855F7),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chef AI Assistant',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Asisten masak pintar Anda',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Online',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),

          // Quick Suggestions (hanya tampil jika belum ada banyak chat)
          if (messages.length <= 2)
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: quickSuggestions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _sendMessage(quickSuggestions[index]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          quickSuggestions[index],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF6366F1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Input Area
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Tanyakan resep atau tips masak...',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                GestureDetector(
                  onTap: () => _sendMessage(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1),
                          const Color(0xFF8B5CF6),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? LinearGradient(
                        colors: [
                          const Color(0xFF10B981),
                          const Color(0xFF059669),
                        ],
                      )
                    : null,
                color: message.isUser ? null : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedDot(0),
                const SizedBox(width: 4),
                _buildAnimatedDot(1),
                const SizedBox(width: 4),
                _buildAnimatedDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animationValue = (_animationController.value + index * 0.2) % 1.0;
        final scale = 0.5 + (0.5 * (1 - (animationValue * 2 - 1).abs()));

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
