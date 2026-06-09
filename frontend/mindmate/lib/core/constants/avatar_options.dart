import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Shared avatar option — used by ProfileSetupPage and UserProvider
// ---------------------------------------------------------------------------
class AvatarOption {
  final IconData icon;
  final List<Color> gradient;
  final String label;

  const AvatarOption({
    required this.icon,
    required this.gradient,
    required this.label,
  });
}

const List<AvatarOption> kDefaultAvatars = [
  AvatarOption(
    icon: Icons.auto_awesome,
    gradient: [Color(0xFF7B61FF), Color(0xFFB19DFF)],
    label: 'Cosmic',
  ),
  AvatarOption(
    icon: Icons.forest_rounded,
    gradient: [Color(0xFF06D6A0), Color(0xFF00B4D8)],
    label: 'Nature',
  ),
  AvatarOption(
    icon: Icons.local_fire_department_rounded,
    gradient: [Color(0xFFFF6B6B), Color(0xFFFFD166)],
    label: 'Flame',
  ),
  AvatarOption(
    icon: Icons.bolt_rounded,
    gradient: [Color(0xFFFFD166), Color(0xFFFF9F1C)],
    label: 'Storm',
  ),
  AvatarOption(
    icon: Icons.water_drop_rounded,
    gradient: [Color(0xFF00B4D8), Color(0xFF0077B6)],
    label: 'Ocean',
  ),
  AvatarOption(
    icon: Icons.spa_rounded,
    gradient: [Color(0xFFEF476F), Color(0xFFB5179E)],
    label: 'Zen',
  ),
  AvatarOption(
    icon: Icons.star_rounded,
    gradient: [Color(0xFFFFC300), Color(0xFFFF5733)],
    label: 'Nova',
  ),
  AvatarOption(
    icon: Icons.nightlight_round,
    gradient: [Color(0xFF2D3561), Color(0xFF7B61FF)],
    label: 'Moon',
  ),
];

/// Returns the [AvatarOption] matching [label], or falls back to the first
/// option (Cosmic) if no match is found.
AvatarOption avatarByLabel(String? label) {
  if (label == null) return kDefaultAvatars.first;
  return kDefaultAvatars.firstWhere(
    (a) => a.label == label,
    orElse: () => kDefaultAvatars.first,
  );
}
