import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_nav.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE), // Light beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF6EE),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "MESSAGES",
          style: GoogleFonts.anton(
            color: Colors.black,
            fontSize: 24,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.black,
            height: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildArchivedButton(),
            const SizedBox(height: 20),
            const Divider(color: Colors.black, thickness: 2),
            const SizedBox(height: 20),
            _buildChatItem(
              name: "JARVIS (AI)",
              time: "21:56",
              message: '"I\'ve updated your focu..."',
              unreadCount: 2,
              backgroundColor: const Color(0xFFFFD600), // Yellow
            ),
            const SizedBox(height: 16),
            _buildChatItem(
              name: "SAHIL",
              time: "21:40",
              message: "Okay, let's sync up after t...",
              unreadCount: 0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 30),
            Text(
              "RELEVANT GROUPS",
              style: GoogleFonts.anton(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            _buildGroupItem(
              title: "STUDY SYNC",
              subtitle: "1.2K MEMBERS • ACTIVE NOW",
              backgroundColor: const Color(0xFF0D6EFD), // Blue
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            _buildGroupItem(
              title: "CALM COLLECTIVE",
              subtitle: "850 MEMBERS • WELLNESS",
              backgroundColor: const Color(0xFFFFD600), // Yellow
              textColor: Colors.black,
            ),
            const SizedBox(height: 16),
            _buildGroupItem(
              title: "NIGHT OWLS",
              subtitle: "420 MEMBERS • LATE NIGHT",
              backgroundColor: const Color(0xFF4A4A4A), // Dark grey
              textColor: Colors.white,
            ),
            const SizedBox(height: 40),
            _buildEmergencyButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 3),
    );
  }

  Widget _buildNeoContainer({
    required Widget child,
    required Color color,
    double height = 60,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSearchBar() {
    return _buildNeoContainer(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "SEARCH CONVERSATIONS...",
                hintStyle: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
              style: GoogleFonts.spaceGrotesk(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.search, color: Colors.black, size: 28),
        ],
      ),
    );
  }

  Widget _buildArchivedButton() {
    return _buildNeoContainer(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.archive_outlined, color: Colors.black),
          const SizedBox(width: 12),
          Text(
            "ARCHIVED CONVERSATIONS",
            style: GoogleFonts.spaceGrotesk(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.black,
            child: Text(
              "33",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem({
    required String name,
    required String time,
    required String message,
    required int unreadCount,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.black87,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: Colors.black,
                        child: Text(
                          unreadCount.toString(),
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFFFFD600),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupItem({
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.anton(
                  color: textColor,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.spaceGrotesk(
                  color: textColor.withOpacity(0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black,
            child: Text(
              "JOIN",
              style: GoogleFonts.spaceGrotesk(
                color: backgroundColor == Colors.white ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return _buildNeoContainer(
      color: const Color(0xFFC62828), // Dark Red
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "EMERGENCY CRISIS SUPPORT",
            style: GoogleFonts.anton(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          const Icon(Icons.phone, color: Colors.white),
        ],
      ),
    );
  }
}
