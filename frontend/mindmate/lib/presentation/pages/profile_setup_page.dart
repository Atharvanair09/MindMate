import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/state/user_provider.dart';

// ---------------------------------------------------------------------------
// Default avatar data
// ---------------------------------------------------------------------------
class _AvatarOption {
  final IconData icon;
  final List<Color> gradient;
  final String label;

  const _AvatarOption({
    required this.icon,
    required this.gradient,
    required this.label,
  });
}

const List<_AvatarOption> _kDefaultAvatars = [
  _AvatarOption(
    icon: Icons.auto_awesome,
    gradient: [Color(0xFF7B61FF), Color(0xFFB19DFF)],
    label: 'Cosmic',
  ),
  _AvatarOption(
    icon: Icons.forest_rounded,
    gradient: [Color(0xFF06D6A0), Color(0xFF00B4D8)],
    label: 'Nature',
  ),
  _AvatarOption(
    icon: Icons.local_fire_department_rounded,
    gradient: [Color(0xFFFF6B6B), Color(0xFFFFD166)],
    label: 'Flame',
  ),
  _AvatarOption(
    icon: Icons.bolt_rounded,
    gradient: [Color(0xFFFFD166), Color(0xFFFF9F1C)],
    label: 'Storm',
  ),
  _AvatarOption(
    icon: Icons.water_drop_rounded,
    gradient: [Color(0xFF00B4D8), Color(0xFF0077B6)],
    label: 'Ocean',
  ),
  _AvatarOption(
    icon: Icons.spa_rounded,
    gradient: [Color(0xFFEF476F), Color(0xFFB5179E)],
    label: 'Zen',
  ),
  _AvatarOption(
    icon: Icons.star_rounded,
    gradient: [Color(0xFFFFC300), Color(0xFFFF5733)],
    label: 'Nova',
  ),
  _AvatarOption(
    icon: Icons.nightlight_round,
    gradient: [Color(0xFF2D3561), Color(0xFF7B61FF)],
    label: 'Moon',
  ),
];

// ---------------------------------------------------------------------------
// Blocked username words
// ---------------------------------------------------------------------------
const List<String> _kBlockedWords = [
  'fuck', 'shit', 'bitch', 'asshole', 'ass', 'dick', 'pussy', 'cock',
  'cunt', 'bastard', 'nigger', 'faggot', 'slut', 'whore',
  'rape', 'kill', 'murder', 'suicide', 'nazi', 'racist',
];

bool _isUsernameAppropriate(String username) {
  final lower = username.toLowerCase();
  for (final word in _kBlockedWords) {
    if (lower.contains(word)) return false;
  }
  return true;
}

// ---------------------------------------------------------------------------
// Random fictional username generator
// ---------------------------------------------------------------------------
const List<String> _adjectives = [
  'Silent', 'Cosmic', 'Velvet', 'Lunar', 'Azure', 'Golden', 'Mystic',
  'Jade', 'Silver', 'Neon', 'Indigo', 'Amber', 'Scarlet', 'Shadow',
  'Crystal', 'Stellar', 'Crimson', 'Sapphire', 'Emerald', 'Phantom',
];

const List<String> _nouns = [
  'Tiger', 'Phoenix', 'Nebula', 'Comet', 'Panda', 'Wolf', 'Falcon',
  'Otter', 'Raven', 'Lynx', 'Orbit', 'Quasar', 'Spirit', 'Storm',
  'Lotus', 'Cipher', 'Pixel', 'Wanderer', 'Echo', 'Drift',
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

class _ProfileSetupPageState extends State<ProfileSetupPage>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  int _selectedAvatarIndex = 0;
  String? _customImagePath; // set when user picks from gallery
  String? _usernameError;
  bool _isSaving = false;

  late AnimationController _fadeController;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _usernameController.text = _generateUsername();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _buttonScaleAnimation = _buttonController;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  // ── Username helpers ───────────────────────────────────────────────────────

  void _regenerateUsername() {
    setState(() {
      _usernameController.text = _generateUsername();
      _usernameError = null;
    });
  }

  bool _validateUsername(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() => _usernameError = 'Username cannot be empty.');
      return false;
    }
    if (trimmed.length < 3) {
      setState(() => _usernameError = 'Too short — at least 3 characters.');
      return false;
    }
    if (trimmed.length > 24) {
      setState(() => _usernameError = 'Too long — max 24 characters.');
      return false;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      setState(
          () => _usernameError = 'Only letters, numbers & underscores allowed.');
      return false;
    }
    if (!_isUsernameAppropriate(trimmed)) {
      setState(() => _usernameError = 'That username isn\'t allowed. Try another.');
      return false;
    }
    setState(() => _usernameError = null);
    return true;
  }

  // ── Avatar image picker ────────────────────────────────────────────────────

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _customImagePath = picked.path);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open gallery. Check app permissions.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _clearCustomImage() => setState(() => _customImagePath = null);

  // ── Confirm & save ─────────────────────────────────────────────────────────

  Future<void> _onConfirm() async {
    final username = _usernameController.text.trim();
    if (!_validateUsername(username)) return;

    await _buttonController.reverse();
    await _buttonController.forward();

    setState(() => _isSaving = true);

    final avatar = _kDefaultAvatars[_selectedAvatarIndex];
    // Read provider and navigator BEFORE the async delay
    final userProvider = context.read<UserProvider>();
    final navigator = Navigator.of(context);

    userProvider.updateProfile(
      username: username,
      avatarIcon: avatar.icon,
      avatarGradient: avatar.gradient,
      avatarLabel: avatar.label,
      customAvatarPath: _customImagePath,
    );

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      navigator.pushReplacementNamed('/home');
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      _buildAvatarPreview(),
                      const SizedBox(height: 16),
                      _buildUploadButton(),
                      const SizedBox(height: 28),
                      _buildUsernameField(),
                      const SizedBox(height: 6),
                      _buildSubtitle(),
                      const SizedBox(height: 32),
                      if (_customImagePath == null) _buildAvatarGrid(),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF4B39EF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Your Identity',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E1E1E),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  // ── Avatar preview circle ──────────────────────────────────────────────────

  Widget _buildAvatarPreview() {
    final avatar = _kDefaultAvatars[_selectedAvatarIndex];
    final hasPhoto = _customImagePath != null;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        TweenAnimationBuilder<double>(
          key: ValueKey(_customImagePath ?? _selectedAvatarIndex),
          tween: Tween(begin: 0.82, end: 1.0),
          duration: const Duration(milliseconds: 350),
          curve: Curves.elasticOut,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasPhoto
                  ? null
                  : LinearGradient(
                      colors: avatar.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              boxShadow: [
                BoxShadow(
                  color: (hasPhoto
                          ? const Color(0xFF7B61FF)
                          : avatar.gradient.first)
                      .withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 3,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: hasPhoto
                  ? Image.file(
                      File(_customImagePath!),
                      fit: BoxFit.cover,
                      width: 130,
                      height: 130,
                    )
                  : Center(
                      child: Icon(avatar.icon, size: 60, color: Colors.white),
                    ),
            ),
          ),
        ),
        // Edit badge
        GestureDetector(
          onTap: _pickImageFromGallery,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B61FF), Color(0xFF9B84FF)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B61FF).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt_rounded,
                size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ── Upload / clear photo button ────────────────────────────────────────────

  Widget _buildUploadButton() {
    if (_customImagePath != null) {
      // Show "Remove photo" option when a custom photo is active
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pillButton(
            icon: Icons.photo_library_rounded,
            label: 'Change Photo',
            color: const Color(0xFF7B61FF),
            onTap: _pickImageFromGallery,
          ),
          const SizedBox(width: 10),
          _pillButton(
            icon: Icons.close_rounded,
            label: 'Remove',
            color: Colors.redAccent,
            onTap: _clearCustomImage,
          ),
        ],
      );
    }

    return _pillButton(
      icon: Icons.photo_library_outlined,
      label: 'Upload from Gallery',
      color: const Color(0xFF7B61FF),
      onTap: _pickImageFromGallery,
    );
  }

  Widget _pillButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Username field ─────────────────────────────────────────────────────────

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _usernameController,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E1E),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: Color(0xFF7B61FF)),
                onPressed: _regenerateUsername,
                tooltip: 'Generate new alias',
              ),
            ),
            onChanged: (val) {
              if (_usernameError != null) _validateUsername(val);
            },
          ),
        ),
        if (_usernameError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline,
                    size: 14, color: Colors.redAccent),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _usernameError!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ── Subtitle ───────────────────────────────────────────────────────────────

  Widget _buildSubtitle() {
    return Text(
      'This is you. Only you know it\'s you.',
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
    );
  }

  // ── Avatar style grid (hidden when custom photo is active) ─────────────────

  Widget _buildAvatarGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'CHOOSE YOUR STYLE',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF9484FF),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B61FF), Color(0xFFB19DFF)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'New',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.78,
          ),
          itemCount: _kDefaultAvatars.length,
          itemBuilder: (context, index) => _buildAvatarCell(index),
        ),
      ],
    );
  }

  Widget _buildAvatarCell(int index) {
    final avatar = _kDefaultAvatars[index];
    final isSelected = _selectedAvatarIndex == index;

    return GestureDetector(
      onTap: () => setState(() {
        _selectedAvatarIndex = index;
        _customImagePath = null; // deselect custom photo when picking default
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: avatar.gradient.first, width: 2.5)
              : Border.all(color: Colors.transparent, width: 2.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: avatar.gradient.first.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? avatar.gradient
                          : [
                              avatar.gradient.first.withOpacity(0.35),
                              avatar.gradient.last.withOpacity(0.35),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      avatar.icon,
                      size: 32,
                      color: isSelected
                          ? Colors.white
                          : avatar.gradient.first.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5),
                color: Colors.white,
                child: Text(
                  avatar.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected
                        ? avatar.gradient.first
                        : const Color(0xFF9E9E9E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom CTA ─────────────────────────────────────────────────────────────

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _buttonScaleAnimation,
            child: GestureDetector(
              onTap: _isSaving ? null : _onConfirm,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isSaving
                        ? [const Color(0xFFB0A8FF), const Color(0xFFCDC6FF)]
                        : [
                            const Color(0xFF7B61FF),
                            const Color(0xFF9B84FF),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B61FF).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'This is me, let\'s go',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline,
                  size: 12, color: Color(0xFFB0A8C8)),
              const SizedBox(width: 5),
              Text(
                'Your alias and avatar are stored only on your device',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: const Color(0xFFB0A8C8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
