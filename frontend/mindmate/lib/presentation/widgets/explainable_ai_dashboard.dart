import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/burnout_forecast.dart';
import '../../domain/models/detected_situation.dart';
import '../../domain/models/ai_insight_result.dart';

class ExplainableAiDashboard extends StatelessWidget {
  final BurnoutForecast? burnoutForecast;
  final List<DetectedSituation> detectedSituations;
  final AiInsightResult? aiInsight;

  const ExplainableAiDashboard({
    super.key,
    this.burnoutForecast,
    this.detectedSituations = const [],
    this.aiInsight,
  });

  @override
  Widget build(BuildContext context) {
    if (burnoutForecast == null && detectedSituations.isEmpty && aiInsight == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EXPLAINABLE AI DASHBOARD",
          style: GoogleFonts.vt323(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 12),
        if (burnoutForecast != null) _buildBurnoutExplanation(burnoutForecast!),
        if (detectedSituations.isNotEmpty) ...detectedSituations.map((s) => _buildSituationExplanation(s)),
        if (aiInsight != null) _buildInsightExplanation(aiInsight!),
      ],
    );
  }

  Widget _buildBurnoutExplanation(BurnoutForecast forecast) {
    final prediction = forecast.trend == 'Increasing' 
        ? "Burnout likely to increase." 
        : forecast.trend == 'Decreasing'
            ? "Burnout likely to decrease."
            : "Burnout likely to remain stable.";

    return _buildExplanationCard(
      title: "Forecast",
      prediction: prediction,
      confidence: forecast.confidence,
      contributors: forecast.contributingSignals,
      color: Colors.black,
      textColor: Colors.white,
    );
  }

  Widget _buildSituationExplanation(DetectedSituation situation) {
    return _buildExplanationCard(
      title: "Situation Detected",
      prediction: situation.situationName,
      confidence: situation.confidence,
      contributors: situation.evidenceUsed,
      color: Colors.blueAccent,
      textColor: Colors.white,
    );
  }

  Widget _buildInsightExplanation(AiInsightResult insight) {
    return _buildExplanationCard(
      title: "Daily Insight",
      prediction: insight.observation,
      confidence: insight.confidence,
      contributors: insight.factorsUsed,
      color: Colors.purpleAccent,
      textColor: Colors.white,
    );
  }

  Widget _buildExplanationCard({
    required String title,
    required String prediction,
    required double confidence,
    required List<String> contributors,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.vt323(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor.withOpacity(0.8),
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.yellow,
                child: Text(
                  "${confidence.toStringAsFixed(0)}% CONFIDENCE",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prediction,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: textColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            "CONTRIBUTORS",
            style: GoogleFonts.vt323(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.8),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          if (contributors.isEmpty)
            Text(
              "No specific contributors identified.",
              style: GoogleFonts.inter(fontSize: 14, color: textColor.withOpacity(0.8)),
            )
          else
            ...contributors.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ", style: GoogleFonts.inter(fontSize: 14, color: textColor, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          c,
                          style: GoogleFonts.inter(fontSize: 14, color: textColor),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
