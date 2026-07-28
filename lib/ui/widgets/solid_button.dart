import 'package:flutter/cupertino.dart';

import '../../app/theme/app_colors.dart';

/// Solid-fill button with a liquid-style press interaction.
///
/// Recreates the feel of [GlassButton]'s tap feedback — quick scale-up on
/// touch, elastic overshoot on release, green glow wash while pressed —
/// using only transforms and an AnimatedContainer. Unlike [GlassButton]
/// (even with `blur: 0`), this never enters the glass shader pipeline, so
/// nothing behind the button is captured or resampled per frame.
///
/// This is the standard CTA button for scrollable content areas
/// (KrishiBondhu performance policy: glass is reserved for floating
/// navigation chrome).
class SolidButton extends StatefulWidget {
  const SolidButton({
    super.key,
    required this.child,
    required this.onTap,
    this.height = 48,
    this.radius = 14,
    this.color,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback onTap;
  final double height;
  final double radius;

  /// Fill color; defaults to [KrishiColors.card].
  final Color? color;

  /// When false the button dims and ignores taps.
  final bool enabled;

  @override
  State<SolidButton> createState() => _SolidButtonState();
}

class _SolidButtonState extends State<SolidButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 380),
  );

  /// 1.0 → 1.05 on press; elastic overshoot on the way back — the same
  /// snap-back character as the package's LiquidStretch.
  late final Animation<double> _scale = Tween<double>(begin: 1, end: 1.05)
      .animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.elasticIn,
  ));

  bool _pressed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    setState(() => _pressed = value);
    if (value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    final base = widget.color ?? KrishiColors.card.resolveFrom(context);

    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: ScaleTransition(
            scale: _scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              height: widget.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // Press feedback: brand-green tint wash + soft outer glow.
                color: _pressed
                    ? Color.alphaBlend(primary.withValues(alpha: 0.18), base)
                    : base,
                borderRadius: BorderRadius.circular(widget.radius),
                border: Border.all(
                  color: _pressed
                      ? primary.withValues(alpha: 0.55)
                      : KrishiColors.cardBorder.resolveFrom(context),
                ),
                boxShadow: _pressed
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ]
                    : const [],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
