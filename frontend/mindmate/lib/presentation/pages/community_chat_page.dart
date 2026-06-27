import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../services/privacy/pseudonymization_service.dart';
import '../../domain/models/anonymous_post.dart';
import '../../data/repositories/anonymous_post_repository_impl.dart';
import '../widgets/global_background.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/community/community_socket_service.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';

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
  final ScrollController _scrollController = ScrollController();
  late StreamSubscription _messageSubscription;
  
  List<AnonymousPost> _posts = [];
  bool _isLoading = true;
  String _sortMode = 'Newest';
  
  String? _replyingToPostId;
  String? _replyingToPostText;

  @override
  void initState() {
    super.initState();
    CommunitySocketService.instance.setActiveCommunity(widget.communityName);
    _loadPosts();
    _subscribeToMessages();
  }

  void _subscribeToMessages() {
    _messageSubscription = CommunitySocketService.instance.messageStream.listen((data) {
      if (data['communityId'] == widget.communityName) {
        final post = AnonymousPost()
          ..id = data['messageId'].hashCode // mock isar id
          ..conversationId = data['communityId']
          ..sanitizedText = data['sanitizedMessage']
          ..originalText = '' // don't need original text for others
          ..timestamp = DateTime.parse(data['timestamp'])
          ..upvotes = 0
          ..parentPostId = data['replyTarget'] != null ? data['replyTarget'].hashCode : null
          ..aliasMappingMetadata = '{"alias": "${data['anonymousAlias']}"}';
          
        if (mounted) {
          setState(() {
            _posts.add(post);
            _sortPosts();
          });
          _scrollToBottom();
        }
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

  void _sortPosts() {
    if (_sortMode == 'Newest') {
      // Newest messages appear at the bottom
      _posts.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } else {
      _posts.sort((a, b) {
        final upvotesComp = b.upvotes.compareTo(a.upvotes);
        if (upvotesComp != 0) return upvotesComp;
        return a.timestamp.compareTo(b.timestamp);
      });
    }
  }

  Future<void> _loadPosts() async {
    final history = await CommunitySocketService.instance.getHistory(widget.communityName);
    
    final mappedPosts = history.map((data) {
      return AnonymousPost()
        ..id = data['messageId']?.hashCode ?? 0
        ..conversationId = data['communityId'] ?? widget.communityName
        ..sanitizedText = data['sanitizedMessage'] ?? ''
        ..originalText = ''
        ..timestamp = data['timestamp'] != null ? DateTime.parse(data['timestamp']) : DateTime.now()
        ..upvotes = data['reactionCounts']?['upvote'] ?? 0
        ..parentPostId = data['replyTarget'] != null ? data['replyTarget'].hashCode : null
        ..aliasMappingMetadata = '{"alias": "${data['anonymousAlias'] ?? 'Member'}"}';
    }).toList();

    if (mounted) {
      setState(() {
        _posts = mappedPosts;
        _sortPosts();
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    
    final parentId = _replyingToPostId;
    setState(() {
      _replyingToPostId = null;
      _replyingToPostText = null;
    });

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final senderId = authVm.uuid ?? const Uuid().v4();

    await CommunitySocketService.instance.sendMessage(
      communityId: widget.communityName,
      senderId: senderId,
      originalText: text,
      replyTarget: parentId,
    );

    // No local repository create. Socket stream will broadcast the message back.
  }

  Future<void> _reactToPost(AnonymousPost post) async {
    // Phase 9: For now we update locally. A full implementation would emit a react socket event.
    setState(() {
      post.upvotes += 1;
    });
  }

  void _startReply(AnonymousPost post) {
    setState(() {
      _replyingToPostId = post.id.toString(); // converted to string for socket reply target
      _replyingToPostText = post.sanitizedText;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingToPostId = null;
      _replyingToPostText = null;
    });
  }

  @override
  void dispose() {
    CommunitySocketService.instance.setActiveCommunity(null);
    _messageSubscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkBackground = widget.communityColor.computeLuminance() < 0.5;
    final headerTextColor = isDarkBackground ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
              "ANONYMOUS DISCUSSION",
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
      body: GlobalBackgroundLayer(
        child: Column(
          children: [
            _buildSortingHeader(),
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
            if (_replyingToPostId != null) _buildReplyIndicator(),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Discussions",
            style: GoogleFonts.anton(
              fontSize: 20,
              letterSpacing: 0.5,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              _buildSortButton('Newest'),
              const SizedBox(width: 8),
              _buildSortButton('Most Helpful'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String mode) {
    final isSelected = _sortMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortMode = mode;
          _sortPosts();
        });
        _scrollToBottom();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          mode,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.reply, size: 16, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Replying to: ${_replyingToPostText ?? ''}",
              style: GoogleFonts.spaceGrotesk(fontSize: 13, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: _cancelReply,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AnonymousPost post) {
    final timeFormatted = DateFormat('MMM d, h:mm a').format(post.timestamp);
    final isReply = post.parentPostId != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: widget.communityColor.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.black87),
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
                      post.aliasMappingMetadata.contains('alias') ? (jsonDecode(post.aliasMappingMetadata)['alias'] ?? "Member") : "Member",
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
                if (isReply) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.subdirectory_arrow_right, size: 14, color: Colors.black45),
                      const SizedBox(width: 4),
                      Text(
                        "Replied to a post",
                        style: GoogleFonts.spaceGrotesk(fontSize: 12, color: Colors.black45, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _reactToPost(post),
                      child: Row(
                        children: [
                          Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            "${post.upvotes}",
                            style: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _startReply(post),
                      child: Row(
                        children: [
                          Icon(Icons.reply_outlined, size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            "Reply",
                            style: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  hintText: _replyingToPostId != null ? "Write a reply..." : "Share your thoughts anonymously...",
                  hintStyle: GoogleFonts.spaceGrotesk(color: Colors.grey[500]),
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
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
