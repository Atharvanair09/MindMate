import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/daily_mood_check_in.dart';

class ContinuousMoodSelector extends StatefulWidget {
  final DailyMoodCheckIn? todayMood;
  final String insightText;
  final Function(int) onMoodSelected;
  final VoidCallback onChangeMood;

  const ContinuousMoodSelector({
    super.key,
    required this.todayMood,
    required this.insightText,
    required this.onMoodSelected,
    required this.onChangeMood,
  });

  @override
  State<ContinuousMoodSelector> createState() => _ContinuousMoodSelectorState();
}

class _ContinuousMoodSelectorState extends State<ContinuousMoodSelector> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int? _selectedIndex;
  bool _isExpanded = false;
  bool _isReversing = false;

  final List<Map<String, String>> moods = [
    {"emoji": "😄", "label": "GREAT"},
    {"emoji": "😊", "label": "GOOD"},
    {"emoji": "😐", "label": "OKAY"},
    {"emoji": "😔", "label": "LOW"},
    {"emoji": "🚨", "label": "BAD"},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (widget.todayMood != null) {
      _isExpanded = true;
      _selectedIndex = _getIndexForMood(widget.todayMood!.moodLevel);
      _controller.value = 1.0;
    }
  }

  int _getIndexForMood(String moodLevel) {
    final index = moods.indexWhere((m) => 
      m["label"] == moodLevel || (moodLevel == "STRUGGLING" && m["label"] == "BAD"));
    return index >= 0 ? index : 2;
  }

  @override
  void didUpdateWidget(ContinuousMoodSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todayMood != null && oldWidget.todayMood == null) {
      if (!_isExpanded && !_isReversing) {
        _selectedIndex = _getIndexForMood(widget.todayMood!.moodLevel);
        _isExpanded = true;
        _controller.forward();
      }
    } else if (widget.todayMood == null && oldWidget.todayMood != null) {
      // If external state sets todayMood to null, but we aren't reversing yet
      if (_isExpanded && !_isReversing) {
        _handleChangeMood();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleMoodTap(int index) {
    if (_isExpanded) return;
    setState(() {
      _selectedIndex = index;
      _isExpanded = true;
      _isReversing = false;
    });
    // Trigger animation visually
    _controller.forward();
    // Notify parent to save data
    widget.onMoodSelected(index);
  }

  void _handleChangeMood() {
    if (_isReversing || !_isExpanded) return;
    
    setState(() {
      _isReversing = true;
    });
    
    _controller.reverse().then((_) {
      if (mounted) {
        setState(() { 
          _selectedIndex = null; 
          _isExpanded = false;
          _isReversing = false;
        });
        widget.onChangeMood();
      }
    });
  }

  Color _getMoodColor(String label) {
    switch (label.toUpperCase()) {
      case 'GREAT':
        return const Color(0xFF4CAF50);
      case 'GOOD':
        return const Color(0xFF8BC34A);
      case 'OKAY':
        return const Color(0xFFFFB300);
      case 'LOW':
        return const Color(0xFFFF9800);
      case 'BAD':
      case 'STRUGGLING':
        return const Color(0xFFE53935);
      default:
        return Colors.white;
    }
  }

  Color _getMoodTextColor(String label) {
    switch (label.toUpperCase()) {
      case 'GREAT':
      case 'LOW':
      case 'BAD':
      case 'STRUGGLING':
        return Colors.white;
      case 'GOOD':
      case 'OKAY':
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      final itemWidth = (totalWidth - 48) / 5;
      final spacing = (totalWidth - (itemWidth * 5)) / 4;
      
      // Animations
      final highlightAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.2, curve: Curves.easeOut)),
      );
      
      final widthAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.6, curve: Curves.easeInOutCubic)),
      );

      final heightAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.8, curve: Curves.easeInOutCubic)),
      );

      final contentFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeOut)),
      );

      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final isAnimatingOrExpanded = _selectedIndex != null;
          final currentLabel = isAnimatingOrExpanded ? moods[_selectedIndex!]["label"]! : "OKAY";
          final containerBg = isAnimatingOrExpanded ? _getMoodColor(currentLabel) : Colors.white;
          final textColor = isAnimatingOrExpanded ? _getMoodTextColor(currentLabel) : Colors.black;
          final subTextColor = textColor.withOpacity(0.85);
          
          final unselectedOpacity = (1.0 - (0.7 * highlightAnim.value) - (0.3 * heightAnim.value)).clamp(0.0, 1.0);
          
          final startHeight = 100.0;
          final targetHeight = 200.0;
          final containerHeight = startHeight + ((targetHeight - startHeight) * heightAnim.value);
          
          return SizedBox(
            height: containerHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Render the 5 buttons
                if (unselectedOpacity > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final isSelected = _selectedIndex == index;
                      final label = moods[index]["label"]!;
                      final bg = isSelected ? _getMoodColor(label) : Colors.white;
                      final txtColor = isSelected ? _getMoodTextColor(label) : Colors.black;
                      
                      // Unselected fade
                      if (!isSelected && isAnimatingOrExpanded) {
                        return Opacity(
                          opacity: unselectedOpacity,
                          child: _buildMoodButton(index, bg, txtColor, itemWidth, false, 0),
                        );
                      }
                      
                      // Selected (if animating width, hide base button because expanding card overlays it)
                      if (isSelected && widthAnim.value > 0) {
                        return SizedBox(width: itemWidth);
                      }
                      
                      // Normal or slightly highlighted selected button
                      final scale = isSelected ? 1.0 + (0.05 * highlightAnim.value) : 1.0;
                      final elevation = isSelected ? 3.0 + (3.0 * highlightAnim.value) : 3.0;
                      
                      return Transform.scale(
                        scale: scale,
                        child: _buildMoodButton(index, bg, txtColor, itemWidth, isSelected, elevation),
                      );
                    }),
                  ),
                  
                // The expanding selected card
                if (isAnimatingOrExpanded && widthAnim.value > 0)
                  ...[
                    Builder(builder: (context) {
                       final startLeft = _selectedIndex! * (itemWidth + spacing);
                       final targetLeft = 0.0;
                       final currentLeft = startLeft + (targetLeft - startLeft) * widthAnim.value;
                       
                       final targetWidth = totalWidth;
                       final currentWidth = itemWidth + (targetWidth - itemWidth) * widthAnim.value;
                       
                       final dynamicPadding = 16.0 - (16.0 * (1 - widthAnim.value));

                       return Positioned(
                         left: currentLeft,
                         top: 0,
                         width: currentWidth,
                         height: containerHeight,
                         child: Container(
                           padding: EdgeInsets.all(dynamicPadding.clamp(0.0, 16.0)),
                           decoration: BoxDecoration(
                             color: containerBg,
                             border: Border.all(color: Colors.black, width: 2),
                             boxShadow: const [
                               BoxShadow(
                                 color: Colors.black,
                                 offset: Offset(4, 4),
                               ),
                             ],
                           ),
                           child: Stack(
                             children: [
                               // Icon is always visible
                               Positioned(
                                 left: (itemWidth / 2) - 16 - dynamicPadding,
                                 top: (startHeight / 2) - 16 - dynamicPadding,
                                 child: Text(
                                   moods[_selectedIndex!]["emoji"]!,
                                   style: const TextStyle(fontSize: 32),
                                 ),
                               ),
                               
                               // The summary content fades in
                               if (contentFadeAnim.value > 0)
                                 Positioned.fill(
                                   child: Opacity(
                                     opacity: contentFadeAnim.value,
                                     child: Padding(
                                       padding: const EdgeInsets.only(left: 48.0),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(
                                             "Today's Mood: ${moods[_selectedIndex!]["label"]!}",
                                             style: GoogleFonts.bebasNeue(
                                               fontSize: 24,
                                               fontWeight: FontWeight.bold,
                                               color: textColor,
                                               letterSpacing: 2,
                                             ),
                                           ),
                                           const SizedBox(height: 4),
                                           Expanded(
                                             child: Text(
                                               widget.insightText,
                                               style: GoogleFonts.inter(
                                                 fontSize: 15,
                                                 fontWeight: FontWeight.w600,
                                                 color: subTextColor,
                                                 height: 1.4,
                                               ),
                                               maxLines: 3,
                                               overflow: TextOverflow.ellipsis,
                                             ),
                                           ),
                                           const SizedBox(height: 12),
                                           SizedBox(
                                             width: double.infinity,
                                             height: 48,
                                             child: GestureDetector(
                                               onTap: _handleChangeMood,
                                               child: Container(
                                                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                 decoration: BoxDecoration(
                                                   color: Colors.black,
                                                   border: Border.all(color: Colors.black, width: 2),
                                                 ),
                                                 child: Center(
                                                   child: Text(
                                                     "CHANGE MOOD",
                                                     style: GoogleFonts.vt323(
                                                       fontSize: 20,
                                                       color: Colors.white,
                                                       fontWeight: FontWeight.bold,
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                             ],
                           ),
                         ),
                       );
                    }),
                  ],
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildMoodButton(int index, Color bg, Color txtColor, double width, bool isSelected, double elevation) {
    return GestureDetector(
      onTap: () => _handleMoodTap(index),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(elevation, elevation),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              moods[index]["emoji"]!,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              moods[index]["label"]!,
              style: GoogleFonts.vt323(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: txtColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
