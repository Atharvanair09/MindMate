import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/privacy/username_privacy_service.dart';

class UsernamePrivacyTesterPage extends StatefulWidget {
  const UsernamePrivacyTesterPage({super.key});

  @override
  State<UsernamePrivacyTesterPage> createState() => _UsernamePrivacyTesterPageState();
}

class _UsernamePrivacyTesterPageState extends State<UsernamePrivacyTesterPage> {
  final TextEditingController _controller = TextEditingController();
  UsernamePrivacyValidation? _result;

  void _validate() {
    final username = _controller.text.trim();
    if (username.isEmpty) {
      setState(() {
        _result = null;
      });
      return;
    }

    setState(() {
      _result = UsernamePrivacyService.instance.validateUsername(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: Text(
          "USERNAME PRIVACY TESTER",
          style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Test a username against the privacy filter.",
              style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: GoogleFonts.spaceMono(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter username',
                hintStyle: GoogleFonts.spaceMono(color: Colors.white54),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: 20),
            if (_result != null) ...[
              Text(
                "STATUS:",
                style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _result!.isValid ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  border: Border.all(
                    color: _result!.isValid ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _result!.isValid ? Icons.check_circle : Icons.error,
                      color: _result!.isValid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _result!.isValid ? "Accepted" : "Rejected",
                      style: GoogleFonts.spaceMono(
                        color: _result!.isValid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (!_result!.isValid && _result!.reason != null) ...[
                const SizedBox(height: 20),
                Text(
                  "REASON:",
                  style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  _result!.reason!,
                  style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: 14),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
