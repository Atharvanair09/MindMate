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
  static String? _activeConversationId;
  static final List<Map<String, dynamic>> _activeMessages = [];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> get _messages => _activeMessages;

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
    if (_activeConversationId == null) {
      _activeConversationId = _chatRepo.newConversationId();
      _activeMessages.clear();
    }
    _conversationId = _activeConversationId!;
    _isLoadingHistory = false; 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasMessages) {
        _scrollToBottom();
      }
    });
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
        backgroundColor: const Color(0xFFF4EFEB),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.black, width: 3),
        ),
        title: Text(
          'WE CARE ABOUT YOU',
          style: GoogleFonts.vt323(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        content: Text(
          'It sounds like you might be going through a tough time. '
          'Talking to someone you trust — a friend, family member, '
          'or a helpline — can really help.\n\n'
          'iCall: 9152987821\n'
          'Vandrevala Foundation: 1860-2662-345',
          style: GoogleFonts.vt323(fontSize: 18, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'I UNDERSTAND',
              style: GoogleFonts.vt323(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
      backgroundColor: const Color(0xFFF4EFEB),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _isLoadingHistory
                  ? const Center(child: CircularProgressIndicator(color: Colors.black))
                  : _hasMessages
                      ? _buildMessageList()
                      : _buildEmptyState(),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 3)),
        ),
        child: const MindMateBottomNav(currentIndex: 1),
      ),
    );
  }

  Future<void> _loadHistory(String conversationId) async {
    setState(() {
      _isLoadingHistory = true;
      _conversationId = conversationId;
      _activeConversationId = conversationId;
    });

    try {
      final history = await _chatRepo.getHistory(conversationId: conversationId);
      if (!mounted) return;

      setState(() {
        _activeMessages.clear();
        for (final msg in history) {
          _activeMessages.add({
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
      backgroundColor: const Color(0xFFF4EFEB),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        side: BorderSide(color: Colors.black, width: 3),
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
                        'PAST CONVERSATIONS',
                        style: GoogleFonts.vt323(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _activeConversationId = _chatRepo.newConversationId();
                            _conversationId = _activeConversationId!;
                            _activeMessages.clear();
                            _isLoadingHistory = false;
                          });
                        },
                        child: Text(
                          'NEW CHAT',
                          style: GoogleFonts.vt323(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.black, thickness: 3),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _chatRepo.getConversations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.black));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'FAILED TO LOAD CONVERSATIONS',
                            style: GoogleFonts.vt323(fontSize: 20, color: Colors.black),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'NO PAST CONVERSATIONS FOUND.',
                            style: GoogleFonts.vt323(fontSize: 20, color: Colors.black),
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
                            leading: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                            title: Text(
                              preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.vt323(fontSize: 20, color: Colors.black),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBrutalistButton(
            onTap: _showConversationsModal,
            icon: Icons.chat_bubble_outline_rounded,
            color: Colors.white,
          ),
          _buildBrutalistButton(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice calling is temporarily disabled.')),
              );
            },
            icon: Icons.phone_in_talk_outlined,
            color: const Color(0xFFFFEB3B),
          ),
        ],
      ),
    );
  }

  Widget _buildBrutalistButton({required VoidCallback onTap, required IconData icon, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Consumer<UserProvider>(
      builder: (context, userState, child) {
        final name = userState.userName.isEmpty ? 'FRIEND' : userState.userName.toUpperCase();
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'HELLO,',
                  style: GoogleFonts.anton(
                    fontSize: 40,
                    fontWeight: FontWeight.w100,
                    color: Colors.black,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.anton(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4A90E2),
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'WHAT WOULD YOU LIKE TO TALK\nABOUT?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.vt323(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
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
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isLoading) {
          return _buildTypingIndicator();
        }
        final msg = _messages[index];
        return _buildMessageBubble(msg['text'] as String, msg['isUser'] as bool);
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
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
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: isUser
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'YOU',
                          style: GoogleFonts.vt323(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEB3B),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'MINDMATE',
                      style: GoogleFonts.vt323(
                        color: const Color(0xFF4A90E2),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: isUser ? Colors.black : Colors.white,
                border: isUser
                    ? Border.all(color: Colors.black, width: 3)
                    : const Border(
                        top: BorderSide(color: Colors.black, width: 3),
                        right: BorderSide(color: Colors.black, width: 3),
                        bottom: BorderSide(color: Colors.black, width: 3),
                        left: BorderSide(color: Color(0xFF4A90E2), width: 6),
                      ),
                boxShadow: [
                  BoxShadow(
                    color: isUser ? const Color(0xFFFFEB3B) : Colors.black,
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                text,
                style: GoogleFonts.spaceGrotesk(
                  color: isUser ? const Color(0xFF81D4FA) : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInputBar(),
      ],
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 52),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !_isLoading,
                      style: GoogleFonts.vt323(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: _isLoading ? 'THINKING...' : 'SAY SOMETHING REAL.',
                        hintStyle: GoogleFonts.vt323(
                          fontSize: 20,
                          color: const Color(0xFF9E9E9E),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _inputIconButton(
                          icon: Icons.mic_none_outlined,
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        _inputIconButton(
                          icon: Icons.camera_alt_outlined,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _isLoading ? () {} : _sendMessage,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.black87, size: 24),
    );
  }
}
