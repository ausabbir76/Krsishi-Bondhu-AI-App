import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/ui.dart';
import '../data/disease_result.dart';
import '../providers.dart';

/// Crop disease scan — pick a photo, analyze, show diagnosis + treatment.
class DiseaseScanScreen extends ConsumerWidget {
  const DiseaseScanScreen({super.key});

  Future<void> _pick(WidgetRef ref, ImageSource source) async {
    final file = await ImagePicker()
        .pickImage(source: source, maxWidth: 1600, imageQuality: 88);
    if (file != null) {
      ref.read(scanControllerProvider.notifier).setImage(file.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scan = ref.watch(scanControllerProvider);
    final primary = KrishiColors.primary.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);

    return AppPage(
      title: l10n.diseaseTitle,
      background: const KrishiBackground(),
      children: [
        Text(
          l10n.diseaseIntro,
          style: TextStyle(fontSize: 14, height: 1.4, color: muted),
        ),
        const SizedBox(height: 20),

        // ── Image area ───────────────────────────────────────────────
        if (scan.imagePath == null)
          _UploadZone(onTap: () => _pick(ref, ImageSource.gallery))
        else
          _ImagePreview(path: scan.imagePath!, analyzing: scan.analyzing),
        const SizedBox(height: AppSpacing.cardGap),

        // ── Pick buttons ─────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _PickButton(
                icon: CupertinoIcons.camera_fill,
                label: l10n.camera,
                onTap: () => _pick(ref, ImageSource.camera),
              ),
            ),
            const SizedBox(width: AppSpacing.cardGap),
            Expanded(
              child: _PickButton(
                icon: CupertinoIcons.photo_fill,
                label: l10n.gallery,
                onTap: () => _pick(ref, ImageSource.gallery),
              ),
            ),
          ],
        ),

        // ── Analyze CTA ──────────────────────────────────────────────
        if (scan.imagePath != null && scan.result == null) ...[
          const SizedBox(height: AppSpacing.cardGap),
          SizedBox(
            width: double.infinity,
            child: SolidButton(
              onTap: () => ref.read(scanControllerProvider.notifier).analyze(),
              enabled: !scan.analyzing,
              child: scan.analyzing
                  ? GlassProgressIndicator.circular(size: 20, color: primary)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.sparkles, size: 18, color: primary),
                        const SizedBox(width: 8),
                        Text(
                          l10n.analyzePhoto,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],

        if (scan.error != null) ...[
          const SizedBox(height: AppSpacing.cardGap),
          SolidCard(
            child: Row(
              children: [
                const Icon(CupertinoIcons.exclamationmark_triangle_fill,
                    size: 18, color: KrishiColors.warning),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(scan.error!,
                      style: const TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        ],

        // ── Result ───────────────────────────────────────────────────
        if (scan.result != null) ...[
          const SizedBox(height: AppSpacing.section),
          _ResultView(result: scan.result!),
          const SizedBox(height: AppSpacing.cardGap),
          Center(
            child: CupertinoButton(
              onPressed: () =>
                  ref.read(scanControllerProvider.notifier).reset(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.arrow_counterclockwise,
                      size: 16, color: primary),
                  const SizedBox(width: 7),
                  Text(l10n.scanAnother,
                      style: TextStyle(color: primary, fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Empty-state upload zone ────────────────────────────────────────────

/// Dashed "drop zone" shown before a photo is picked. Tapping opens the
/// gallery; the Camera/Gallery buttons below remain the explicit actions.
class _UploadZone extends StatelessWidget {
  const _UploadZone({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = KrishiColors.primary.resolveFrom(context);
    final label = CupertinoColors.label.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: primary.withValues(alpha: 0.45),
          radius: AppSpacing.radiusLarge,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: KrishiColors.accentFill
                .resolveFrom(context)
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          ),
          padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 24),
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(CupertinoIcons.camera_viewfinder,
                    size: 36, color: primary),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noPhotoSelected,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: label),
              ),
              const SizedBox(height: 5),
              Text(
                l10n.diseaseTitle,
                style: TextStyle(fontSize: 13, color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selected-photo frame with a hairline border; dims + spins while analyzing.
class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.path, required this.analyzing});

  final String path;
  final bool analyzing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border:
            Border.all(color: KrishiColors.cardBorder.resolveFrom(context)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Stack(
          children: [
            Image.file(
              File(path),
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
            if (analyzing)
              Positioned.fill(
                child: ColoredBox(
                  color: CupertinoColors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: GlassProgressIndicator.circular(
                      size: 28,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Camera / Gallery secondary picker button.
class _PickButton extends StatelessWidget {
  const _PickButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    return SolidButton(
      onTap: onTap,
      height: 46,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: primary),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Result ─────────────────────────────────────────────────────────────

class _ResultView extends StatelessWidget {
  const _ResultView({required this.result});

  final DiseaseResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = CupertinoColors.label.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);
    final primary = KrishiColors.primary.resolveFrom(context);
    final severityColor = _severityColor(result.severity);
    final percent = (result.confidence * 100).round();
    final aiAdvice = result.aiAdvice?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Diagnosis header ─────────────────────────────────────────
        SolidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(CupertinoIcons.checkmark_seal_fill,
                        size: 26, color: primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.detectedLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          result.disease,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            color: label,
                          ),
                        ),
                        if (result.scientificName.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            result.scientificName,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaPill(
                    icon: CupertinoIcons.chart_bar_alt_fill,
                    label: l10n.confidenceChip('$percent'),
                    color: primary,
                  ),
                  _MetaPill(
                    icon: CupertinoIcons.exclamationmark_triangle_fill,
                    label: '${l10n.severityLabel}${result.severity}',
                    color: severityColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        if (aiAdvice != null && aiAdvice.isNotEmpty)
          _TreatmentCard(
            icon: CupertinoIcons.sparkles,
            color: AppColors.green,
            title: 'AI suggestions',
            body: aiAdvice,
          )
        else ...[
          _TreatmentCard(
            icon: CupertinoIcons.leaf_arrow_circlepath,
            color: AppColors.green,
            title: l10n.organicTreatment,
            body: result.organicTreatment,
          ),
          const SizedBox(height: AppSpacing.cardGap),
          _TreatmentCard(
            icon: CupertinoIcons.drop_fill,
            color: AppColors.blue,
            title: l10n.chemicalTreatment,
            body: result.chemicalTreatment,
          ),
          const SizedBox(height: AppSpacing.cardGap),
          _TreatmentCard(
            icon: CupertinoIcons.shield_fill,
            color: AppColors.orange,
            title: l10n.prevention,
            body: result.prevention,
          ),
        ],
      ],
    );
  }
}

/// Small rounded status pill: tinted icon + label (confidence, severity).
class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Treatment card: tinted icon badge + title + body copy.
class _TreatmentCard extends StatelessWidget {
  const _TreatmentCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SolidCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: KrishiColors.mutedText.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Best-effort severity → color (English + common Bangla keywords). Defaults
/// to [KrishiColors.warning] (moderate) when the level can't be recognized.
Color _severityColor(String severity) {
  final s = severity.toLowerCase();
  if (s.contains('severe') ||
      s.contains('high') ||
      s.contains('তীব্র') ||
      s.contains('মারাত্মক') ||
      s.contains('বেশি')) {
    return KrishiColors.danger;
  }
  if (s.contains('mild') ||
      s.contains('low') ||
      s.contains('হালকা') ||
      s.contains('কম') ||
      s.contains('অল্প')) {
    return AppColors.green;
  }
  return KrishiColors.warning;
}

/// Draws a dashed rounded-rectangle border (used by the upload drop zone).
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const double _dash = 7;
  static const double _gap = 5;
  static const double _strokeWidth = 1.6;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final len = math.min(_dash, metric.length - dist);
        canvas.drawPath(metric.extractPath(dist, dist + len), paint);
        dist += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
