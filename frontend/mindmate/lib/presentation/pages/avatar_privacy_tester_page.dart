import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/privacy/avatar_privacy_service.dart';

class AvatarPrivacyTesterPage extends StatefulWidget {
  const AvatarPrivacyTesterPage({super.key});

  @override
  State<AvatarPrivacyTesterPage> createState() => _AvatarPrivacyTesterPageState();
}

class _AvatarPrivacyTesterPageState extends State<AvatarPrivacyTesterPage> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  AvatarPrivacyValidation? _result;
  bool _isTesting = false;

  Future<void> _pickAndTestImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _imagePath = picked.path;
          _isTesting = true;
          _result = null;
        });

        final validation = await AvatarPrivacyService.instance.validateAvatar(picked.path);

        if (mounted) {
          setState(() {
            _result = validation;
            _isTesting = false;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open gallery')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: Text(
          "AVATAR PRIVACY TESTER",
          style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Test an image against the avatar privacy filter.",
              style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 20),
            
            Center(
              child: GestureDetector(
                onTap: _isTesting ? null : _pickAndTestImage,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: _imagePath != null
                      ? Image.file(
                          File(_imagePath!),
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.upload_file, color: Colors.greenAccent, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              "Upload image",
                              style: GoogleFonts.spaceMono(color: Colors.greenAccent),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_isTesting)
              const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
            else if (_result != null) ...[
              Text(
                "DEBUG INFO:",
                style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 20),
              ),
              const SizedBox(height: 8),
              _buildStatRow("Faces Detected", _result!.facesDetected.toString()),
              
              const SizedBox(height: 20),
              Text(
                "STATUS:",
                style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _result!.isValid ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
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

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
