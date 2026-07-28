import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A soft radial glow circle used to decorate glass backgrounds.
///
/// Centralizes the hand-built radial-gradient circles that were duplicated
/// in the showcase background, indicator parity demo, and the scaffold
/// regression demo.
class GlowOrb extends StatelessWidget {
  const GlowOrb({
    super.key,
    required this.size,
    required this.colors,
    this.stops,
  });

  /// Diameter of the orb.
  final double size;

  /// Gradient colors, brightest first. The last color should usually be
  /// [Colors.transparent].
  final List<Color> colors;

  /// Optional gradient stops (defaults to evenly distributed).
  final List<double>? stops;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors, stops: stops),
      ),
    );
  }
}

/// A theme-aware background for showcase pages.
class ShowcaseBackground extends StatelessWidget {
  const ShowcaseBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    return isDark
        ? const _DarkShowcaseBackground()
        : const _LightShowcaseBackground();
  }
}

class _DarkShowcaseBackground extends StatelessWidget {
  const _DarkShowcaseBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF020715), // deep navy
      child: Stack(
        children: [
          // Purple glow — upper right (9B59FF / A246F7)
          Positioned(
            top: -50,
            right: -100,
            child: GlowOrb(
              size: 500,
              colors: [
                const Color(0xFFA246F7).withValues(alpha: 0.32),
                const Color(0xFF9B59FF).withValues(alpha: 0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          // Hot pink glow — center left (E040FB / EB66FF)
          Positioned(
            top: 280,
            left: -100,
            child: GlowOrb(
              size: 460,
              colors: [
                const Color(0xFFEB66FF).withValues(alpha: 0.16),
                const Color(0xFFE040FB).withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          // Blue glow — bottom right (2077FF / 4FC3F7)
          Positioned(
            bottom: -60,
            right: -40,
            child: GlowOrb(
              size: 420,
              colors: [
                const Color(0xFF2077FF).withValues(alpha: 0.18),
                const Color(0xFF4FC3F7).withValues(alpha: 0.06),
                Colors.transparent,
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
          // Subtle purple accent — mid-left
          Positioned(
            top: 120,
            left: 30,
            child: GlowOrb(
              size: 160,
              colors: [
                const Color(0xFF9B59FF).withValues(alpha: 0.10),
                Colors.transparent,
              ],
            ),
          ),
          // Purple wash — center screen (behind catalog cards)
          Positioned(
            top: 500,
            left: 0,
            right: 0,
            child: Center(
              child: GlowOrb(
                size: 340,
                colors: [
                  const Color(0xFF9B59FF).withValues(alpha: 0.14),
                  const Color(0xFF7B3FA8).withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LightShowcaseBackground extends StatelessWidget {
  const _LightShowcaseBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF5F0FA), // Very light lavender
            Color(0xFFF0F4F8), // Soft blue-grey
            Color(0xFFEEEEF2), // Light grey
          ],
        ),
      ),
      child: Stack(
        children: [
          // Muted purple glow — upper right
          Positioned(
            top: -50,
            right: -100,
            child: GlowOrb(
              size: 500,
              colors: [
                const Color(0xFFA246F7).withValues(alpha: 0.15),
                const Color(0xFF9B59FF).withValues(alpha: 0.06),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          // Soft pink glow — center left
          Positioned(
            top: 280,
            left: -100,
            child: GlowOrb(
              size: 460,
              colors: [
                const Color(0xFFEB66FF).withValues(alpha: 0.12),
                const Color(0xFFE040FB).withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          // Blue accent — bottom right
          Positioned(
            bottom: -60,
            right: -40,
            child: GlowOrb(
              size: 420,
              colors: [
                const Color(0xFF2077FF).withValues(alpha: 0.12),
                const Color(0xFF4FC3F7).withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ],
      ),
    );
  }
}
