import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/privacy/pseudonymization_service.dart';
import '../../domain/models/anonymous_post.dart';
import '../../data/repositories/anonymous_post_repository_impl.dart';

class SanitizedStorageTesterPage extends StatefulWidget {
  const SanitizedStorageTesterPage({super.key});

  @override
  State<SanitizedStorageTesterPage> createState() => _SanitizedStorageTesterPageState();
}

class _SanitizedStorageTesterPageState extends State<SanitizedStorageTesterPage> {
  final TextEditingController _textController = TextEditingController(text: "Rahul insulted me.");
  final TextEditingController _conversationIdController = TextEditingController(text: "conv_store_1");
  final AnonymousPostRepositoryImpl _repository = AnonymousPostRepositoryImpl();

  List<AnonymousPost> _storedPosts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final posts = await _repository.getAll();
    setState(() {
      _storedPosts = posts.reversed.toList();
    });
  }

  Future<void> _storePost() async {
    final text = _textController.text;
    if (text.isEmpty) return;

    final convId = _conversationIdController.text.trim().isEmpty 
        ? "default" 
        : _conversationIdController.text.trim();

    // PHASE 5.4 - SANITIZED STORAGE
    // 1. BEFORE STORAGE: Run Pseudonymization Engine / Relationship Engine
    final sanitizedText = PseudonymizationService.instance.sanitizeText(text, convId);
    
    // Get Alias Mapping Metadata
    final mapping = PseudonymizationService.instance.getAliasMapping(convId);
    final mappingJson = jsonEncode(mapping);

    // 2. STORE: Sanitized Content, Alias Mapping Metadata
    // DO NOT STORE: Original Human Names
    final post = AnonymousPost()
      ..originalText = text // We store it ONLY for debug display purposes as requested by "DEBUG PAGE Show: Original Text, Stored Text". In production, this field would be dropped or not exist.
      ..sanitizedText = sanitizedText
      ..conversationId = convId
      ..timestamp = DateTime.now()
      ..aliasMappingMetadata = mappingJson;

    await _repository.create(post);
    _textController.clear();
    await _loadPosts();
  }

  @override
  void dispose() {
    _textController.dispose();
    _conversationIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: Text(
          "SANITIZED STORAGE DEBUG",
          style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CONVERSATION ID",
              style: GoogleFonts.vt323(color: Colors.orangeAccent, fontSize: 20),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _conversationIdController,
              style: GoogleFonts.vt323(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.orangeAccent)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "INPUT TEXT (TO STORE)",
              style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: GoogleFonts.vt323(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[700]!)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _storePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  ),
                  child: Text("STORE", style: GoogleFonts.vt323(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "------------------------",
              style: GoogleFonts.vt323(color: Colors.grey[600], fontSize: 18, letterSpacing: 2),
            ),
            const SizedBox(height: 20),
            Text(
              "STORED DATABASE RECORDS",
              style: GoogleFonts.vt323(color: Colors.greenAccent, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _storedPosts.isEmpty
                  ? Center(child: Text("No records found in database.", style: GoogleFonts.vt323(color: Colors.grey, fontSize: 18)))
                  : ListView.builder(
                      itemCount: _storedPosts.length,
                      itemBuilder: (context, index) {
                        final post = _storedPosts[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ORIGINAL TEXT",
                                style: GoogleFonts.vt323(color: Colors.redAccent, fontSize: 16),
                              ),
                              Text(
                                post.originalText,
                                style: GoogleFonts.vt323(color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "STORED TEXT (SANITIZED)",
                                style: GoogleFonts.vt323(color: Colors.greenAccent, fontSize: 16),
                              ),
                              Text(
                                post.sanitizedText,
                                style: GoogleFonts.vt323(color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "ALIAS MAPPING METADATA",
                                style: GoogleFonts.vt323(color: Colors.purpleAccent, fontSize: 16),
                              ),
                              Text(
                                post.aliasMappingMetadata,
                                style: GoogleFonts.vt323(color: Colors.white70, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
