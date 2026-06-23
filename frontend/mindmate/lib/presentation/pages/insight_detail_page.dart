import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/ai_insight_result.dart';

class InsightDetailPage extends StatelessWidget {
  final AiInsightResult insight;

  const InsightDetailPage({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "AI INSIGHT DETAIL",
          style: GoogleFonts.vt323(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              title: "OBSERVATION",
              content: insight.observation,
              icon: Icons.visibility,
              color: Colors.black,
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: "AI INSIGHT",
              content: insight.homeCardInsight,
              icon: Icons.auto_awesome,
              color: Colors.yellow,
              textColor: Colors.black,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: "SUGGESTION",
              content: insight.suggestion,
              icon: Icons.lightbulb_outline,
              color: Colors.white,
              textColor: Colors.black,
            ),
            const SizedBox(height: 24),
            Text(
              "METADATA",
              style: GoogleFonts.vt323(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            _buildMetadataRow("CONFIDENCE", "${insight.confidence.toStringAsFixed(1)}%"),
            _buildMetadataRow("GENERATED", insight.generatedAt.toLocal().toString().split('.')[0]),
            const SizedBox(height: 12),
            Text(
              "FACTORS USED:",
              style: GoogleFonts.vt323(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: insight.factorsUsed.map((f) => _buildFactorChip(f)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.vt323(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: textColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.vt323(fontSize: 18, color: Colors.grey[800]),
          ),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
