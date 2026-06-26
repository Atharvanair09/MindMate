import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/detected_situation.dart';
import '../../services/ml/situation_detection_engine.dart';
import '../../services/wellness/coping_toolkit_service.dart';
import 'package:intl/intl.dart';

class SituationDetectionTesterPage extends StatefulWidget {
  const SituationDetectionTesterPage({super.key});

  @override
  State<SituationDetectionTesterPage> createState() => _SituationDetectionTesterPageState();
}

class _SituationDetectionTesterPageState extends State<SituationDetectionTesterPage> {
  List<DetectedSituation> _detectedSituations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runDetection();
  }

  Future<void> _runDetection() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final situations = await SituationDetectionEngine.instance.detectSituations();
      setState(() {
        _detectedSituations = situations;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildValueRow(String text, {bool isCyan = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: GoogleFonts.vt323(
          color: isCyan ? Colors.cyanAccent : Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 1,
        color: Colors.grey[800],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'timer':
        return Icons.timer;
      case 'list_alt':
        return Icons.list_alt;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'air':
        return Icons.air;
      case 'checklist':
        return Icons.checklist;
      case 'book':
        return Icons.book;
      case 'nightlight_round':
        return Icons.nightlight_round;
      case 'tips_and_updates':
        return Icons.tips_and_updates;
      case 'edit_note':
        return Icons.edit_note;
      default:
        return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
        title: Text(
          "AI SITUATION DETECTION ENGINE",
          style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _isLoading ? null : _runDetection,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.grey[800] : Colors.orangeAccent,
                  border: Border.all(color: Colors.orangeAccent, width: 2),
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : Text(
                          "TRIGGER DETECTION",
                          style: GoogleFonts.vt323(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              "DETECTED SITUATIONS (${_detectedSituations.length})",
              style: GoogleFonts.vt323(
                color: Colors.orangeAccent,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildDivider(),
            
            Expanded(
              child: _detectedSituations.isEmpty
                  ? Center(
                      child: Text(
                        "No situations detected based on recent evidence.",
                        style: GoogleFonts.vt323(color: Colors.grey, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _detectedSituations.length,
                      itemBuilder: (context, index) {
                        final situation = _detectedSituations[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[800]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                situation.situationName.toUpperCase(),
                                style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 22),
                              ),
                              const SizedBox(height: 8),
                              _buildValueRow("Confidence: ${situation.confidence.toStringAsFixed(1)}%"),
                              _buildValueRow("Generated: ${DateFormat('MMM d, h:mm a').format(situation.generatedAt.toLocal())}"),
                              _buildDivider(),
                              _buildValueRow("Reason:", isCyan: true),
                              _buildValueRow(situation.reason),
                              const SizedBox(height: 8),
                              _buildValueRow("Evidence Breakdown:", isCyan: true),
                              ...situation.evidenceUsed.map((e) => _buildValueRow("  + $e")),
                              const SizedBox(height: 8),
                              _buildValueRow("Signals Used:", isCyan: true),
                              if (situation.signalsUsed.isEmpty)
                                _buildValueRow("  None")
                              else
                                ...situation.signalsUsed.map((s) => _buildValueRow("  > $s")),
                              const SizedBox(height: 8),
                              _buildValueRow("Supporting Factors:", isCyan: true),
                              if (situation.supportingFactors.isEmpty)
                                _buildValueRow("  None")
                              else
                                ...situation.supportingFactors.map((f) => _buildValueRow("  - $f")),
                              const SizedBox(height: 8),
                              _buildValueRow("Detected Keywords:", isCyan: true),
                              if (situation.keywordsTriggered.isEmpty)
                                _buildValueRow("  None")
                              else
                                _buildValueRow("  ${situation.keywordsTriggered.join(', ')}"),
                              _buildDivider(),
                              _buildValueRow("RECOMMENDED TOOLS", isCyan: true),
                              ...CopingToolkitService.instance
                                  .getRecommendedTools(situation)
                                  .map((tool) => Padding(
                                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              _getIconData(tool.iconName),
                                              color: Colors.orangeAccent,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    tool.name.toUpperCase(),
                                                    style: GoogleFonts.vt323(color: Colors.white, fontSize: 18),
                                                  ),
                                                  Text(
                                                    tool.description,
                                                    style: GoogleFonts.vt323(color: Colors.grey, fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
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
