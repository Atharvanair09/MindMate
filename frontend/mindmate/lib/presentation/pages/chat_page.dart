import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/state/user_provider.dart';
import '../widgets/bottom_nav.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  bool get _hasMessages => _messages.isNotEmpty;

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text.trim();
    setState(() {
      _messages.add({'text': userText, 'isUser': true});
      _controller.clear();
    });

    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text':
                "I understand how you feel. Remember to take deep breaths and take it one step at a time. I'm here for you.",
            'isUser': false,
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _hasMessages ? _buildMessageList() : _buildEmptyState(),
            ),
            _buildInputBar(),
          ],
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 1),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Chat bubble icon
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF4B39EF),
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Consumer<UserProvider>(
      builder: (context, userState, child) {
        final name = userState.userName.isEmpty ? 'Friend' : userState.userName;
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello, ',
                        style: GoogleFonts.poppins(
                          fontSize: 38,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF1E1E1E),
                        ),
                      ),
                      TextSpan(
                        text: name,
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF4B39EF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'what would you like to talk about?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF3C3C3C),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return _buildMessageBubble(msg['text'] as String, msg['isUser'] as bool);
      },
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF4285F4) : const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isUser ? Colors.white : const Color(0xFF1E1E1E),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 20),
            // Text field
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF1E1E1E),
                ),
                decoration: InputDecoration(
                  hintText: 'Ask Jarvis',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFFAAAAAA),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.only(top: 9, bottom: 9),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Mic icon
            _inputIconButton(
              icon: Icons.mic_none_rounded,
              onTap: () {},
            ),
            const SizedBox(width: 4),
            // Camera icon
            _inputIconButton(
              icon: Icons.camera_alt_outlined,
              onTap: () {},
            ),
            const SizedBox(width: 4),
            // Sparkle / AI icon
            _inputIconButton(
              icon: Icons.arrow_forward_rounded,
              onTap: _sendMessage,
              color: const Color(0xFF4B39EF),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _inputIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = const Color(0xFF6E6E73),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
