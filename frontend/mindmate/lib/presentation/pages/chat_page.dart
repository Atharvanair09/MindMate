import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/state/user_provider.dart';
import '../../data/repositories/chat_repository.dart';
import '../widgets/bottom_nav.dart';
import 'voice_call_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final ChatRepository _chatRepo = ChatRepository();

  /// Unique conversation ID — persisted for the lifetime of this chat session.
  /// A new one is generated each time the user opens a fresh chat.
  late String _conversationId;

  /// True while waiting for the backend/Claude to respond.
  bool _isLoading = false;

  /// True while restoring history from the backend on first open.
  bool _isLoadingHistory = true;

  bool get _hasMessages => _messages.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _conversationId = _chatRepo.newConversationId();
    _isLoadingHistory = false; // Fresh conversation — nothing to load
  }

  /// Sends a user message to the backend and handles the AI response.
  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;

    final userText = _controller.text.trim();
    setState(() {
      _messages.add({'text': userText, 'isUser': true});
      _controller.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final result = await _chatRepo.sendMessage(
        message: userText,
        conversationId: _conversationId,
      );

      if (!mounted) return;

      setState(() {
        _messages.add({
          'text': result['response'] as String? ??
              "I'm here for you. Could you tell me more?",
          'isUser': false,
        });
        _isLoading = false;
      });

      _scrollToBottom();

      // Check if the backend flagged escalation
      final showEscalation = result['show_escalation'] as bool? ?? false;
      if (showEscalation && mounted) {
        _showEscalationDialog();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text':
              "I'm here, but having a little trouble right now — can you try sending that again?",
          'isUser': false,
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  /// Shows a gentle, non-alarming escalation dialog when risk flags accumulate.
  void _showEscalationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'We care about you',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'It sounds like you might be going through a tough time. '
          'Talking to someone you trust — a friend, family member, '
          'or a helpline — can really help.\n\n'
          'iCall: 9152987821\n'
          'Vandrevala Foundation: 1860-2662-345',
          style: GoogleFonts.poppins(fontSize: 14, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'I understand',
              style: GoogleFonts.poppins(
                color: const Color(0xFF4B39EF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
              child: _isLoadingHistory
                  ? const Center(child: CircularProgressIndicator())
                  : _hasMessages
                      ? _buildMessageList()
                      : _buildEmptyState(),
            ),
            _buildInputBar(),
          ],
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 1),
    );
  }

  Future<void> _loadHistory(String conversationId) async {
    setState(() {
      _isLoadingHistory = true;
      _conversationId = conversationId;
    });

    try {
      final history = await _chatRepo.getHistory(conversationId: conversationId);
      if (!mounted) return;

      setState(() {
        _messages.clear();
        for (final msg in history) {
          _messages.add({
            'text': msg['message'] as String,
            'isUser': msg['role'] == 'user',
          });
        }
        _isLoadingHistory = false;
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingHistory = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load history: $e')),
      );
    }
  }

  void _showConversationsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Past Conversations',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _conversationId = _chatRepo.newConversationId();
                            _messages.clear();
                            _isLoadingHistory = false;
                          });
                        },
                        child: Text(
                          'New Chat',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF4B39EF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _chatRepo.getConversations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load conversations',
                            style: GoogleFonts.poppins(),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No past conversations found.',
                            style: GoogleFonts.poppins(),
                          ),
                        );
                      }

                      final convs = snapshot.data!;
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: convs.length,
                        itemBuilder: (context, index) {
                          final conv = convs[index];
                          final preview = conv['preview'] as String? ?? 'Empty conversation';
                          final id = conv['conversation_id'] as String;
                          return ListTile(
                            leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF4B39EF)),
                            title: Text(
                              preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              _loadHistory(id);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
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
            onTap: _showConversationsModal,
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF4B39EF),
              size: 26,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoiceCallScreen()),
              );
            },
            child: const Icon(
              Icons.phone_in_talk,
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
      // +1 for the typing indicator when loading
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // Show typing indicator as the last item when waiting for AI
        if (index == _messages.length && _isLoading) {
          return _buildTypingIndicator();
        }
        final msg = _messages[index];
        return _buildMessageBubble(msg['text'] as String, msg['isUser'] as bool);
      },
    );
  }

  /// A subtle "..." typing indicator shown while Claude is responding.
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.3, end: 1.0),
              duration: Duration(milliseconds: 400 + (i * 200)),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFAAAAAA),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
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
                enabled: !_isLoading,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF1E1E1E),
                ),
                decoration: InputDecoration(
                  hintText: _isLoading ? 'Thinking...' : 'Ask Jarvis',
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
            // Send / AI icon
            _inputIconButton(
              icon: Icons.arrow_forward_rounded,
              onTap: _isLoading ? () {} : _sendMessage,
              color: _isLoading
                  ? const Color(0xFFAAAAAA)
                  : const Color(0xFF4B39EF),
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
