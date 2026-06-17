import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/archive_provider.dart';
import '../../domain/models/archive_models.dart';

class LocalChatViewPage extends StatefulWidget {
  final String chatId;

  const LocalChatViewPage({super.key, required this.chatId});

  @override
  State<LocalChatViewPage> createState() => _LocalChatViewPageState();
}

class _LocalChatViewPageState extends State<LocalChatViewPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArchiveProvider>();
    final chat = provider.chats.firstWhere(
      (c) => c.id == widget.chatId,
      orElse: () => LocalChat(
        id: 'error',
        title: 'NOT FOUND',
        messages: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (chat.id == 'error') {
      return Scaffold(
        appBar: AppBar(title: const Text('ERROR')),
        body: const Center(child: Text('Chat not found.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4EFEB),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
        title: Text(
          chat.title.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
            ),
            onSelected: (value) {
              if (value == 'rename') {
                _showRenameDialog(context, provider, chat);
              } else if (value == 'delete') {
                _showDeleteDialog(context, provider, chat);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'rename',
                child: Text('RENAME', style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold)),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('DELETE', style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold, color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: chat.messages.length,
        itemBuilder: (context, index) {
          final msg = chat.messages[index];
          final isUser = msg.role == 'user';
          return _buildMessageBubble(msg.text, isUser, msg.timestamp);
        },
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser, DateTime timestamp) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isUser)
                    Text(
                      DateFormat('HH:mm').format(timestamp),
                      style: GoogleFonts.vt323(color: Colors.grey[600], fontSize: 14),
                    ),
                  if (isUser) const SizedBox(width: 8),
                  Text(
                    isUser ? 'YOU' : 'MINDMATE',
                    style: GoogleFonts.vt323(
                      color: isUser ? Colors.grey[500] : const Color(0xFF4A90E2),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isUser) const SizedBox(width: 8),
                  if (!isUser)
                    Text(
                      DateFormat('HH:mm').format(timestamp),
                      style: GoogleFonts.vt323(color: Colors.grey[600], fontSize: 14),
                    ),
                ],
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

  Future<void> _showRenameDialog(BuildContext context, ArchiveProvider provider, LocalChat chat) async {
    final controller = TextEditingController(text: chat.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF2F0E9),
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: Text('RENAME CHAT', style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: GoogleFonts.spaceMono(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL', style: GoogleFonts.spaceMono(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text('SAVE', style: GoogleFonts.spaceMono(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      provider.renameChat(chat.id, newTitle.trim());
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, ArchiveProvider provider, LocalChat chat) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF2F0E9),
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: Text('DELETE CHAT?', style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold)),
        content: Text('This action cannot be undone.', style: GoogleFonts.spaceMono()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('CANCEL', style: GoogleFonts.spaceMono(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('DELETE', style: GoogleFonts.spaceMono(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      provider.deleteChat(chat.id);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
