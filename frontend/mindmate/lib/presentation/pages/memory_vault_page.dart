import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/archive_provider.dart';
import '../../domain/models/archive_models.dart' hide JournalEntry;
import '../../domain/models/journal_entry.dart';
import 'local_chat_view_page.dart';
import 'local_journal_view_page.dart';
class MemoryVaultPage extends StatefulWidget {
  const MemoryVaultPage({super.key});

  @override
  State<MemoryVaultPage> createState() => _MemoryVaultPageState();
}

class _MemoryVaultPageState extends State<MemoryVaultPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArchiveProvider>().loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final archiveProvider = context.watch<ArchiveProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F0E9), // Beige
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F0E9),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
        title: Text(
          'ARCHIVE',
          style: GoogleFonts.spaceMono(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildTabs(),
          const SizedBox(height: 16),
          _buildSearchBar(archiveProvider),
          const SizedBox(height: 16),
          Expanded(
            child: archiveProvider.isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildChatsList(archiveProvider),
                      _buildJournalsList(archiveProvider),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _tabController.animateTo(0),
                child: Container(
                  color: _tabController.index == 0 ? const Color(0xFFFDEB00) : const Color(0xFFE5E2D9),
                  alignment: Alignment.center,
                  child: Text(
                    'CHATS',
                    style: GoogleFonts.spaceMono(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(width: 2, color: Colors.black),
            Expanded(
              child: GestureDetector(
                onTap: () => _tabController.animateTo(1),
                child: Container(
                  color: _tabController.index == 1 ? const Color(0xFFFDEB00) : const Color(0xFFE5E2D9),
                  alignment: Alignment.center,
                  child: Text(
                    'JOURNAL',
                    style: GoogleFonts.spaceMono(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ArchiveProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: provider.search,
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'SEARCH ARCHIVE...',
                  hintStyle: GoogleFonts.spaceMono(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const Icon(Icons.filter_alt_outlined, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsList(ArchiveProvider provider) {
    if (provider.chats.isEmpty) {
      return Center(
        child: Text(
          'NO CHATS FOUND',
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: provider.chats.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final chat = provider.chats[index];
        final isNew = index == 0 && DateTime.now().difference(chat.updatedAt).inHours < 24;
        
        return Dismissible(
          key: Key(chat.id),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24.0),
            child: const Icon(Icons.delete, color: Colors.white, size: 32),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFFF2F0E9),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  title: Text(
                    'DELETE CHAT?',
                    style: GoogleFonts.spaceMono(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  content: Text(
                    'This action cannot be undone.',
                    style: GoogleFonts.spaceMono(
                      color: Colors.black87,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.spaceMono(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'DELETE',
                        style: GoogleFonts.spaceMono(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            provider.deleteChat(chat.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'CHAT DELETED',
                  style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: Colors.black,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocalChatViewPage(chatId: chat.id),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                chat.title.toUpperCase(),
                                style: GoogleFonts.spaceMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward, color: Colors.black),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'TIMESTAMP: ${DateFormat('dd.MM.yy HH:mm').format(chat.updatedAt)}',
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Colors.black, thickness: 1, height: 1),
                        const SizedBox(height: 12),
                        Text(
                          chat.messages.isNotEmpty 
                            ? '"${chat.messages.last.text.replaceAll('\n', ' ')}"' 
                            : '"No messages yet."',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isNew)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDEB00),
                          border: Border(
                            left: BorderSide(color: Colors.black, width: 2),
                            bottom: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        child: Text(
                          'NEW',
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildJournalsList(ArchiveProvider provider) {
    if (provider.journals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NO JOURNALS FOUND',
              style: GoogleFonts.spaceMono(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Placeholder for future journal creation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Journal creation coming soon.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                side: const BorderSide(color: Colors.black, width: 2),
                elevation: 0,
              ),
              child: Text(
                'CREATE JOURNAL (COMING SOON)',
                style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: provider.journals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final journal = provider.journals[index];
        return Dismissible(
          key: Key(journal.id.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24.0),
            child: const Icon(Icons.delete, color: Colors.white, size: 32),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFFF2F0E9),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  title: Text(
                    'DELETE JOURNAL?',
                    style: GoogleFonts.spaceMono(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  content: Text(
                    'This action cannot be undone.',
                    style: GoogleFonts.spaceMono(
                      color: Colors.black87,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.spaceMono(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'DELETE',
                        style: GoogleFonts.spaceMono(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            provider.deleteJournal(journal.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'JOURNAL DELETED',
                  style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: Colors.black,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOG: ${DateFormat('EEEE').format(journal.createdAt).toUpperCase()}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DATE: ${DateFormat('dd.MM.yy').format(journal.createdAt)}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    journal.preview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocalJournalViewPage(journalId: journal.id.toString()),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          'VIEW FULL LOG',
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
