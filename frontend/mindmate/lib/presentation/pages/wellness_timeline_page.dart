import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/models/timeline_event.dart';
import '../../services/timeline/timeline_service.dart';
import '../../domain/models/wellness_journey_summary.dart';
import '../../services/wellness_journey/wellness_journey_service.dart';
import 'weekly_reflection_page.dart';
import '../widgets/global_background.dart';

class WellnessTimelinePage extends StatefulWidget {
  const WellnessTimelinePage({super.key});

  @override
  State<WellnessTimelinePage> createState() => _WellnessTimelinePageState();
}

class _WellnessTimelinePageState extends State<WellnessTimelinePage> {
  bool _newestFirst = true;
  WellnessJourneySummary? _summary;
  bool _isLoadingSummary = true;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    try {
      final summary = await WellnessJourneyService.instance.getOrGenerateSummary();
      if (mounted) {
        setState(() {
          _summary = summary;
          _isLoadingSummary = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSummary = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "WELLNESS TIMELINE",
          style: GoogleFonts.vt323(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_newestFirst ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.black),
            tooltip: _newestFirst ? "Newest First" : "Oldest First",
            onPressed: () {
              setState(() {
                _newestFirst = !_newestFirst;
              });
            },
          ),
        ],
      ),
      body: GlobalBackgroundLayer(
        child: SafeArea(
          child: StreamBuilder<List<TimelineEvent>>(
          stream: TimelineService.instance.watchTimelineEvents(newestFirst: _newestFirst),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && _isLoadingSummary) {
              return const Center(child: CircularProgressIndicator(color: Colors.black));
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading timeline: ${snapshot.error}",
                  style: GoogleFonts.vt323(fontSize: 18, color: Colors.red),
                ),
              );
            }
            final events = snapshot.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: events.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildJourneySummaryCard();
                }
                
                // Adjust index for events
                final eventIndex = index - 1;
                return _buildTimelineEvent(events[eventIndex]);
              },
            );
          },
        ),
      ),
      ),
    );
  }

  Widget _buildJourneySummaryCard() {
    if (_isLoadingSummary) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    if (_summary == null || _summary!.narrative.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.yellow,
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
              const Icon(Icons.auto_awesome, color: Colors.black, size: 28),
              const SizedBox(width: 12),
              Text(
                "YOUR WELLNESS JOURNEY",
                style: GoogleFonts.vt323(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 2,
            color: Colors.black.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _summary!.narrative,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Generated ${DateFormat('MMM dd, HH:mm').format(_summary!.generatedAt)}",
              style: GoogleFonts.vt323(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineEvent(TimelineEvent event) {
    Color cardColor = Colors.white;
    Color shadowColor = Colors.black;
    double opacity = 1.0;

    if (event.importance == 'HIGH') {
      cardColor = const Color(0xFFFFE8E8); // Light red tint
      shadowColor = Colors.redAccent;
    } else if (event.importance == 'MEDIUM') {
      cardColor = const Color(0xFFF0F4FF); // Light blue tint
      shadowColor = Colors.blueAccent;
    } else {
      cardColor = Colors.white;
      shadowColor = Colors.grey.shade400; // softer shadow for less noise
      opacity = 0.8; // slightly fade low importance
    }

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () {
          if (event.eventType == 'Weekly Reflection Generated') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeeklyReflectionPage()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeIndicator(event.eventDate),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Text(
                                  event.eventType.toUpperCase(),
                                  style: GoogleFonts.vt323(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              if (event.isPositive != null) ...[
                                const SizedBox(width: 8),
                                _buildPatternTypeBadge(event.isPositive!),
                              ],
                            ],
                          ),
                        ),
                        _buildImportanceBadge(event.importance),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      event.title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildPatternTypeBadge(bool isPositive) {
    final color = isPositive ? Colors.green : Colors.orange;
    final icon = isPositive ? Icons.thumb_up : Icons.warning_amber_rounded;
    final text = isPositive ? "POSITIVE" : "WARNING";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.vt323(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportanceBadge(String importance) {
    IconData icon;
    Color color;
    Color bgColor;
    
    if (importance == 'HIGH') {
      icon = Icons.priority_high;
      color = Colors.redAccent;
      bgColor = Colors.redAccent.withOpacity(0.1);
    } else if (importance == 'MEDIUM') {
      icon = Icons.remove;
      color = Colors.blueAccent;
      bgColor = Colors.blueAccent.withOpacity(0.1);
    } else {
      icon = Icons.arrow_downward;
      color = Colors.grey.shade600;
      bgColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            importance,
            style: GoogleFonts.vt323(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeIndicator(DateTime date) {
    return Column(
      children: [
        Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.yellow,
          ),
          child: Column(
            children: [
              Text(
                DateFormat('MMM').format(date).toUpperCase(),
                style: GoogleFonts.vt323(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                DateFormat('dd').format(date),
                style: GoogleFonts.vt323(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('HH:mm').format(date),
          style: GoogleFonts.vt323(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
