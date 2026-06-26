import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/community_recommendation.dart';
import '../../services/community/community_recommendation_service.dart';

class CommunityRecommendationTesterPage extends StatefulWidget {
  const CommunityRecommendationTesterPage({super.key});

  @override
  State<CommunityRecommendationTesterPage> createState() => _CommunityRecommendationTesterPageState();
}

class _CommunityRecommendationTesterPageState extends State<CommunityRecommendationTesterPage> {
  bool _isLoading = false;
  List<CommunityRecommendation> _recommendations = [];
  List<String> _tags = [];
  Map<String, double> _allConfidences = {};
  Map<String, String> _allReasons = {};

  Future<void> _runEngine() async {
    setState(() {
      _isLoading = true;
    });

    final engine = CommunityRecommendationService.instance;
    final results = await engine.generateRecommendations();

    setState(() {
      _recommendations = results;
      _tags = engine.lastDetectedTags;
      _allConfidences = engine.lastConfidenceScores;
      _allReasons = engine.lastMatchReasons;
      _isLoading = false;
    });
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.constrainWidth();
        final dashWidth = 5.0;
        final dashCount = (width / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }

  Widget _buildValueRow(String text, {bool isCyan = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.vt323(
          color: isCyan ? Colors.cyanAccent : Colors.greenAccent,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.vt323(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: Text(
          "AI COMMUNITY ENGINE",
          style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _isLoading ? null : _runEngine,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.grey[800] : Colors.blueAccent,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : Text(
                          "TRIGGER RECOMMENDATION ENGINE",
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
            _buildDashedLine(),
            const SizedBox(height: 20),

            _buildSection("Detected Tags", [
              if (_tags.isEmpty)
                _buildValueRow("No tags detected. Run engine first.")
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.all(color: Colors.cyanAccent),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 16),
                    ),
                  )).toList(),
                ),
            ]),
            
            const SizedBox(height: 20),
            _buildDashedLine(),
            const SizedBox(height: 20),

            _buildSection("Top 3 Recommendations", [
              if (_recommendations.isEmpty)
                _buildValueRow("No recommendations available.")
              else
                ..._recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec.communityName,
                          style: GoogleFonts.vt323(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Confidence: ${rec.confidence.toStringAsFixed(1)}%",
                          style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Reason: ${rec.matchReason}",
                          style: GoogleFonts.vt323(color: Colors.greenAccent, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )),
            ]),
            
            const SizedBox(height: 20),
            _buildDashedLine(),
            const SizedBox(height: 20),

            _buildSection("Debug: All Confidences", [
              if (_allConfidences.isEmpty)
                _buildValueRow("No data.")
              else
                ..._allConfidences.entries.map((entry) => _buildValueRow(
                  "${entry.key}: ${entry.value.toStringAsFixed(1)}%"
                )),
            ]),
          ],
        ),
      ),
    );
  }
}
