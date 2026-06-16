import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/state/user_provider.dart';
import '../../data/repositories/auth_repository.dart';

// ---------------------------------------------------------------------------
// Random fictional username generator
// ---------------------------------------------------------------------------
const List<String> _adjectives = [
  'SILENT', 'COSMIC', 'VELVET', 'LUNAR', 'AZURE', 'GOLDEN', 'MYSTIC',
  'JADE', 'SILVER', 'NEON', 'INDIGO', 'AMBER', 'SCARLET', 'SHADOW',
  'CRYSTAL', 'STELLAR', 'CRIMSON', 'SAPPHIRE', 'EMERALD', 'PHANTOM',
];

const List<String> _nouns = [
  'TIGER', 'PHOENIX', 'NEBULA', 'COMET', 'PANDA', 'WOLF', 'FALCON',
  'OTTER', 'RAVEN', 'LYNX', 'ORBIT', 'QUASAR', 'SPIRIT', 'STORM',
  'LOTUS', 'CIPHER', 'PIXEL', 'WANDERER', 'ECHO', 'DRIFT',
];

String _generateUsername() {
  final rand = Random();
  final adj = _adjectives[rand.nextInt(_adjectives.length)];
  final noun = _nouns[rand.nextInt(_nouns.length)];
  final number = rand.nextInt(90) + 10;
  return '$adj$noun$number';
}

// ---------------------------------------------------------------------------
// ProfileSetupPage
// ---------------------------------------------------------------------------
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  int _currentAvatarIndex = 1;
  String? _customImagePath;
  bool _isSaving = false;
  bool _isReturningUser = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final userProvider = context.read<UserProvider>();
      if (userProvider.hasUsername) {
        setState(() {
          _isReturningUser = true;
          _usernameController.text = userProvider.userName;
          // Try to map current avatar label to an index, default to 1
          final label = userProvider.avatarLabel;
          if (label.startsWith('CyberAvatar')) {
            _currentAvatarIndex = int.tryParse(label.replaceAll('CyberAvatar', '')) ?? 1;
          } else {
            _currentAvatarIndex = Random().nextInt(3) + 1;
          }
        });
      } else {
        _randomizeIdentity();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _randomizeIdentity() {
    setState(() {
      _usernameController.text = _generateUsername();
      _currentAvatarIndex = Random().nextInt(3) + 1;
      _customImagePath = null;
    });
  }

  void _randomizeUsernameOnly() {
    setState(() {
      _usernameController.text = _generateUsername();
    });
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _customImagePath = picked.path;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open gallery.', style: GoogleFonts.spaceMono(fontSize: 12)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _onConfirm() async {
    final userProvider = context.read<UserProvider>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final repo = AuthRepository();

    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Username cannot be empty', style: GoogleFonts.spaceMono(fontSize: 12)), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isSaving = true);

    final avatarLabel = 'CyberAvatar$_currentAvatarIndex';
    final imageFile = _customImagePath != null ? File(_customImagePath!) : null;

    if (_isReturningUser) {
      // ——— Avatar-only update ———
      try {
        await repo.updateUserAvatar(
          avatarLabel,
          imageFile: imageFile,
          clearImage: _customImagePath == null,
        );
        
        final profile = await repo.fetchUserProfile();
        final savedImageUrl = profile?['avatarImageUrl'];

        userProvider.updateAvatar(
          avatarIcon: Icons.account_circle, // Default fallback
          avatarGradient: [Colors.black, Colors.grey],
          avatarLabel: avatarLabel,
          localImagePath: _customImagePath,
          persistedImageUrl: savedImageUrl,
        );
      } catch (e) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Upload failed: $e', style: GoogleFonts.spaceMono(fontSize: 12)),
            backgroundColor: Colors.redAccent,
          ));
        }
      }
    } else {
      // ——— First-time full setup ———
      try {
        await repo.setupUserProfile(
          username, 
          avatarLabel,
          imageFile: imageFile,
        );
        
        final profile = await repo.fetchUserProfile();
        final savedImageUrl = profile?['avatarImageUrl'];

        userProvider.updateProfile(
          username: username,
          avatarIcon: Icons.account_circle, // Default fallback
          avatarGradient: [Colors.black, Colors.grey],
          avatarLabel: avatarLabel,
          localImagePath: _customImagePath,
          persistedImageUrl: savedImageUrl,
        );
      } catch (e) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Sync failed: $e', style: GoogleFonts.spaceMono(fontSize: 12)),
            backgroundColor: Colors.redAccent,
          ));
        }
      }
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      navigator.pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                _isReturningUser ? 'YOUR IDENTITY (EDIT)' : 'YOUR IDENTITY',
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              
              // Avatar Section
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildImagePreview(),
                        const SizedBox(height: 16),
                        
                        // Row of avatars to select from
                        _buildAvatarSelector(),
                        const SizedBox(height: 24),
                        
                        // Username & Reload
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _usernameController,
                                enabled: !_isReturningUser,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.spaceMono(
                                  color: const Color(0xFFFDEB00), // Neon yellow
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            if (!_isReturningUser)
                              GestureDetector(
                                onTap: _randomizeUsernameOnly,
                                child: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isReturningUser
                              ? 'Your alias is permanent. Only your avatar can change.'
                              : 'This is you. Only you know this is you.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.spaceMono(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Badges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBadge('NO NAME', false, -0.02),
                  _buildBadge('NO EMAIL', true, 0.02),
                  _buildBadge('NO TRACE', false, -0.03),
                ],
              ),
              const SizedBox(height: 40),
              
              // Confirm Button
              GestureDetector(
                onTap: _isSaving ? null : _onConfirm,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEB00),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isReturningUser ? 'UPDATE AVATAR' : 'THIS IS ME',
                                style: GoogleFonts.spaceMono(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward, color: Colors.black),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Bottom Text
              Text(
                'Save your 12-word recovery phrase on the next screen.',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceMono(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: _customImagePath != null
              ? Image.file(
                  File(_customImagePath!),
                  fit: BoxFit.cover,
                )
              : _currentAvatarIndex != 0
                  ? Image.asset(
                      'assets/avatars/avatar_$_currentAvatarIndex.png',
                      fit: BoxFit.cover,
                    )
                  : const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
        // Add gallery picker button on top
        GestureDetector(
          onTap: _pickImageFromGallery,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFDEB00),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Icon(Icons.photo_library, color: Colors.black, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final avatarIdx = index + 1;
        final isSelected = _currentAvatarIndex == avatarIdx && _customImagePath == null;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentAvatarIndex = avatarIdx;
              _customImagePath = null;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? const Color(0xFFFDEB00) : Colors.white54,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Image.asset(
              'assets/avatars/avatar_$avatarIdx.png',
              fit: BoxFit.cover,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBadge(String text, bool highlighted, double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFFFDEB00) : Colors.black,
          border: Border.all(color: highlighted ? Colors.black : Colors.white, width: 2),
        ),
        child: Text(
          text,
          style: GoogleFonts.spaceMono(
            color: highlighted ? Colors.black : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
