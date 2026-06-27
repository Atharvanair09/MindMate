import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/burnout_forecast.dart';
import '../../services/wellness/burnout_forecast_engine.dart';
import 'package:intl/intl.dart';

class BurnoutForecastTesterPage extends StatefulWidget {
  const BurnoutForecastTesterPage({super.key});

  @override
  State<BurnoutForecastTesterPage> createState() => _BurnoutForecastTesterPageState();
}

class _BurnoutForecastTesterPageState extends State<BurnoutForecastTesterPage> {
  BurnoutForecast? _forecast;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runForecast();
  }

  Future<void> _runForecast() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final forecast = await BurnoutForecastEngine.instance.getDailyForecast();
      setState(() {
        _forecast = forecast;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildValueRow(String label, String value, {bool isCyan = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: GoogleFonts.vt323(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.vt323(
                color: isCyan ? Colors.cyanAccent : Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
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

  Widget _buildChart(List<double> scores) {
    if (scores.isEmpty) return const SizedBox();

    double maxScore = 100.0;
    
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: scores.asMap().entries.map((e) {
          final score = e.value;
          final heightRatio = (score / maxScore).clamp(0.0, 1.0);
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    score.round().toString(),
                    style: GoogleFonts.vt323(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 60 * heightRatio,
                    color: _getColorForScore(score),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "D-${scores.length - e.key - 1}",
                    style: GoogleFonts.vt323(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getColorForScore(double score) {
    if (score < 35) return Colors.greenAccent;
    if (score < 70) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  Color _getColorForTrend(String trend) {
    if (trend == 'Decreasing' || trend == 'Improving') return Colors.greenAccent;
    if (trend == 'Increasing' || trend == 'Declining') return Colors.redAccent;
    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
        title: Text(
          "BURNOUT FORECAST ENGINE",
          style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _isLoading ? null : _runForecast,
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
                          "GENERATE FORECAST",
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
            
            Expanded(
              child: _forecast == null && !_isLoading
                  ? Center(
                      child: Text(
                        "No forecast available.",
                        style: GoogleFonts.vt323(color: Colors.grey, fontSize: 18),
                      ),
                    )
                  : _forecast == null
                      ? const SizedBox()
                      : SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[800]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "FORECAST GENERATED",
                                  style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 22),
                                ),
                                const SizedBox(height: 8),
                                _buildValueRow("Generated:", DateFormat('MMM d, h:mm a').format(_forecast!.generatedAt.toLocal())),
                                _buildDivider(),

                                Text(
                                  "PREDICTIONS",
                                  style: GoogleFonts.vt323(color: Colors.orangeAccent, fontSize: 20),
                                ),
                                const SizedBox(height: 8),
                                _buildValueRow("Current Burnout:", "${_forecast!.currentBurnout.toStringAsFixed(1)} / 100", isCyan: true),
                                _buildValueRow("Tomorrow (+1d):", "${_forecast!.forecastTomorrow.toStringAsFixed(1)} / 100"),
                                _buildValueRow("In 3 Days (+3d):", "${_forecast!.forecast3Days.toStringAsFixed(1)} / 100"),
                                _buildValueRow("In 7 Days (+7d):", "${_forecast!.forecast7Days.toStringAsFixed(1)} / 100"),
                                
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text("Trend: ", style: GoogleFonts.vt323(color: Colors.grey, fontSize: 18)),
                                    Text(
                                      _forecast!.trend,
                                      style: GoogleFonts.vt323(
                                        color: _getColorForTrend(_forecast!.trend),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                _buildValueRow("Confidence:", "${_forecast!.confidence.toStringAsFixed(1)}%"),
                                
                                _buildDivider(),

                                Text(
                                  "HISTORICAL SCORES",
                                  style: GoogleFonts.vt323(color: Colors.orangeAccent, fontSize: 20),
                                ),
                                _buildChart(_forecast!.historicalScores),

                                _buildDivider(),

                                Text(
                                  "CONTRIBUTING SIGNALS",
                                  style: GoogleFonts.vt323(color: Colors.orangeAccent, fontSize: 20),
                                ),
                                const SizedBox(height: 8),
                                if (_forecast!.contributingSignals.isEmpty)
                                  _buildValueRow("", "None")
                                else
                                  ..._forecast!.contributingSignals.map((s) => _buildValueRow(">", s)),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
