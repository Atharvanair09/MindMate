import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/privacy/pseudonymization_service.dart';
import '../../domain/models/anonymous_post.dart';
import '../../data/repositories/anonymous_post_repository_impl.dart';

class CommunityChatPage extends StatefulWidget {
  final String communityName;
  final Color communityColor;

  const CommunityChatPage({
    super.key,
    required this.communityName,
    required this.communityColor,
  });

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final AnonymousPostRepositoryImpl _repository = AnonymousPostRepositoryImpl();
  final ScrollController _scrollController = ScrollController();
  
  List<AnonymousPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final allPosts = await _repository.getAll();
    final communityPosts = allPosts.where((p) => p.conversationId == widget.communityName).toList();
    
    // Sort by timestamp
    communityPosts.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (mounted) {
      setState(() {
        _posts = communityPosts;
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    final sanitizedText = PseudonymizationService.instance.sanitizeText(text, widget.communityName);
    
    final mapping = PseudonymizationService.instance.getAliasMapping(widget.communityName);
    final mappingJson = jsonEncode(mapping);

    final post = AnonymousPost()
      ..originalText = text
      ..sanitizedText = sanitizedText
      ..conversationId = widget.communityName
      ..timestamp = DateTime.now()
      ..aliasMappingMetadata = mappingJson;

    await _repository.create(post);
    await _loadPosts();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkBackground = widget.communityColor.computeLuminance() < 0.5;
    final headerTextColor = isDarkBackground ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(
        backgroundColor: widget.communityColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headerTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              widget.communityName.toUpperCase(),
              style: GoogleFonts.anton(
                color: headerTextColor,
                fontSize: 22,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              "ANONYMOUS COMMUNITY",
              style: GoogleFonts.spaceGrotesk(
                color: headerTextColor.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : _posts.isEmpty
                    ? Center(
                        child: Text(
                          "No messages yet. Be the first to share!",
                          style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          final post = _posts[index];
                          return _buildMessageBubble(post);
                        },
                      ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AnonymousPost post) {
    final timeFormatted = DateFormat('h:mm a').format(post.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person_outline, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Anonymous Member",
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeFormatted,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      )
                    ],
                  ),
                  child: Text(
                    post.sanitizedText,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 15,
                      color: Colors.black,
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

  Widget _buildMessageInput() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black, width: 2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.spaceGrotesk(fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Share your thoughts anonymously...",
                  hintStyle: GoogleFonts.spaceGrotesk(color: Colors.grey[500]),
                  filled: true,
                  fillColor: const Color(0xFFFAF6EE),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Colors.black, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: widget.communityColor, width: 2),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
