import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/state/archive_provider.dart';
import '../../domain/models/journal_entry.dart';
import '../widgets/diary_grid/models/diary_page_data.dart';
import '../widgets/diary_grid/scrapbook_diary_editor.dart';
import '../../domain/models/reflection_result.dart';
import '../../services/ml/reflection_engine.dart';

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
      (j) => j.id.toString() == widget.journalId,
      orElse: () => JournalEntry()..id = -1, // Dummy ID to check for error
    );

    if (journal.id == -1) {
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
        itemCount: pages.length + 1,
        itemBuilder: (context, index) {
          if (index == pages.length) {
            return FutureBuilder<ReflectionResult>(
              future: ReflectionEngine.instance.getLatestReflection(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: Colors.black)));
                }
                final reflection = snapshot.data!;
                return Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0), // Light grey
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.black, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AI REFLECTION",
                                  style: GoogleFonts.vt323(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  reflection.burnoutLevel == 'LOW' ? "Positive Vibes" : "Mixed Signals",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        reflection.insight,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16,
                          color: Colors.black87,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "CONTRIBUTING FACTORS",
                        style: GoogleFonts.vt323(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: reflection.contributingFactors.map((factor) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.yellow[700]),
                                const SizedBox(width: 6),
                                Text(
                                  factor,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_outline, color: Colors.yellow),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                reflection.suggestedAction,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

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
