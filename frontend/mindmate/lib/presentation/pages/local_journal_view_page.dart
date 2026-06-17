import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/archive_provider.dart';
import '../../domain/models/archive_models.dart';
import '../widgets/diary_grid/models/diary_page_data.dart';
import '../widgets/diary_grid/scrapbook_diary_editor.dart';

class LocalJournalViewPage extends StatefulWidget {
  final String journalId;

  const LocalJournalViewPage({super.key, required this.journalId});

  @override
  State<LocalJournalViewPage> createState() => _LocalJournalViewPageState();
}

class _LocalJournalViewPageState extends State<LocalJournalViewPage> {

  int _getTotalWordCount(List<DiaryPageData> pages) {
    return pages.fold(0, (sum, page) {
      if (page.text.trim().isEmpty) return sum;
      return sum + page.text.trim().split(RegExp(r'\s+')).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArchiveProvider>();
    final journal = provider.journals.firstWhere(
      (j) => j.id == widget.journalId,
      orElse: () => JournalEntry(
        id: 'error',
        content: 'Journal not found.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        journalDate: DateTime.now(),
      ),
    );

    if (journal.id == 'error') {
      return Scaffold(
        appBar: AppBar(title: const Text('ERROR')),
        body: const Center(child: Text('Journal not found.')),
      );
    }

    List<DiaryPageData> pages = [];
    if (journal.pagesJson != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(journal.pagesJson!);
        pages = jsonList.map((json) => DiaryPageData.fromJson(json)).toList();
      } catch (e) {
        debugPrint('Error parsing pagesJson: $e');
      }
    }

    if (pages.isEmpty) {
      final page = DiaryPageData();
      page.text = journal.content;
      pages = [page];
    }

    final totalWordCount = _getTotalWordCount(pages);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F1E3),
        elevation: 0,
        toolbarHeight: 60,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "LOG: ${DateFormat('dd.MM.yy').format(journal.journalDate)}",
          style: GoogleFonts.vt323(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7, // Give each page a fixed height
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScrapbookDiaryEditor(
                pageData: pages[index],
                isLayoutMode: false,
                onLayoutModeChanged: (mode) {},
                selectedImageId: null,
                onImageSelected: (id) {},
                onPageChanged: (newPageData) {},
                readOnly: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
