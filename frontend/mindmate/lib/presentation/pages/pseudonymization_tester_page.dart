import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/privacy/pseudonymization_service.dart';

class PseudonymizationTesterPage extends StatefulWidget {
  const PseudonymizationTesterPage({super.key});

  @override
  State<PseudonymizationTesterPage> createState() => _PseudonymizationTesterPageState();
}

class _PseudonymizationTesterPageState extends State<PseudonymizationTesterPage> {
  final TextEditingController _textController = TextEditingController(
      text: "Rahul punched me. Kartik watched. Kartik never helps.");
  final TextEditingController _conversationIdController =
      TextEditingController(text: "conv_1");

  String _sanitizedOutput = "";
  List<String> _detectedRelationships = [];
  List<String> _detectedNames = [];
  List<String> _generatedAliases = [];

  @override
  void initState() {
    super.initState();
    _processText();
  }

  void _processText() {
    final text = _textController.text;
    final convId = _conversationIdController.text.trim().isEmpty 
        ? "default" 
        : _conversationIdController.text.trim();

    final sanitized = PseudonymizationService.instance.sanitizeText(text, convId);
    final mapping = PseudonymizationService.instance.getAliasMapping(convId);

    List<String> relationships = [];
    List<String> names = [];
    List<String> aliases = [];

    final Set<String> processedNames = {};

    final RegExp relRegex = RegExp(
      r'\b(?:(?:my|our|his|her|their|a|an|the|your)\s+)?(friend|teacher|parent|sibling|coworker|manager|partner|classmate|relative)\s+([A-Za-z]+)\b',
      caseSensitive: false,
    );

    for (var match in relRegex.allMatches(text)) {
      final relationship = match.group(1)!;
      final name = match.group(2)!;
      final lowerName = name.toLowerCase();
      
      if (PseudonymizationService.instance.isKnownName(lowerName) || mapping.containsKey(lowerName)) {
        String capRel = relationship[0].toUpperCase() + relationship.substring(1).toLowerCase();
        if (!processedNames.contains(lowerName)) {
          relationships.add(capRel);
          names.add(name);
          aliases.add("$capRel-${mapping[lowerName]}");
          processedNames.add(lowerName);
        }
      }
    }

    final RegExp wordRegex = RegExp(r'\b[A-Za-z]+\b');
    for (var match in wordRegex.allMatches(text)) {
      final name = match.group(0)!;
      final lowerName = name.toLowerCase();
      
      if (!processedNames.contains(lowerName)) {
        if (PseudonymizationService.instance.isKnownName(lowerName) || mapping.containsKey(lowerName)) {
          relationships.add("None");
          names.add(name);
          aliases.add(mapping[lowerName] ?? "Unknown");
          processedNames.add(lowerName);
        }
      }
    }

    setState(() {
      _sanitizedOutput = sanitized;
      _detectedRelationships = relationships;
      _detectedNames = names;
      _generatedAliases = aliases;
    });
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
          "PSEUDONYMIZATION ENGINE DEBUG",
          style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
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
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
              ),
              onChanged: (_) => _processText(),
            ),
            const SizedBox(height: 20),
            Text(
              "INPUT TEXT",
              style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 20),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 4,
              style: GoogleFonts.vt323(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent),
                ),
              ),
              onChanged: (_) => _processText(),
            ),
            const SizedBox(height: 24),
            _buildDashedLine(),
            const SizedBox(height: 20),
            Text(
              "DETECTED RELATIONSHIP",
              style: GoogleFonts.vt323(color: Colors.purpleAccent, fontSize: 20),
            ),
            const SizedBox(height: 8),
            _detectedRelationships.isEmpty
                ? Text("None", style: GoogleFonts.vt323(color: Colors.grey, fontSize: 18))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _detectedRelationships
                        .map((r) => Text("- $r", style: GoogleFonts.vt323(color: Colors.white, fontSize: 18)))
                        .toList(),
                  ),
            const SizedBox(height: 20),
            Text(
              "DETECTED NAME",
              style: GoogleFonts.vt323(color: Colors.purpleAccent, fontSize: 20),
            ),
            const SizedBox(height: 8),
            _detectedNames.isEmpty
                ? Text("None", style: GoogleFonts.vt323(color: Colors.grey, fontSize: 18))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _detectedNames
                        .map((name) => Text("- $name", style: GoogleFonts.vt323(color: Colors.white, fontSize: 18)))
                        .toList(),
                  ),
            const SizedBox(height: 20),
            Text(
              "GENERATED ALIAS",
              style: GoogleFonts.vt323(color: Colors.purpleAccent, fontSize: 20),
            ),
            const SizedBox(height: 8),
            _generatedAliases.isEmpty
                ? Text("None", style: GoogleFonts.vt323(color: Colors.grey, fontSize: 18))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _generatedAliases
                        .map((a) => Text("- $a", style: GoogleFonts.vt323(color: Colors.greenAccent, fontSize: 18)))
                        .toList(),
                  ),
            const SizedBox(height: 20),
            _buildDashedLine(),
            const SizedBox(height: 20),
            Text(
              "SANITIZED OUTPUT",
              style: GoogleFonts.vt323(color: Colors.greenAccent, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border.all(color: Colors.greenAccent),
              ),
              child: Text(
                _sanitizedOutput,
                style: GoogleFonts.vt323(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedLine() {
    return Text(
      "------------------------",
      style: GoogleFonts.vt323(color: Colors.grey[600], fontSize: 18, letterSpacing: 2),
    );
  }
}
