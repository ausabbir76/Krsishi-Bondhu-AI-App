import 'package:flutter/cupertino.dart';

/// Scaffolding for a home-tab body: scroll view + safe area + 24pt padding
/// + 34pt large title + subtitle + content + bottom-bar clearance.
///
/// Extracted from the four near-identical tab bodies in main.dart.
class TabContentView extends StatelessWidget {
  const TabContentView({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleStyle,
    this.subtitleGap = 8,
    required this.children,
  });

  /// Large tab title.
  final String title;

  /// Optional muted subtitle under the title.
  final String? subtitle;

  /// Override for the subtitle style (Explore tab uses 17pt).
  final TextStyle? subtitleStyle;

  /// Gap between title and subtitle (Explore tab uses 4).
  final double subtitleGap;

  /// Tab content below the header.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.label.resolveFrom(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: subtitleGap),
                    Text(
                      subtitle!,
                      style: subtitleStyle ??
                          TextStyle(
                            fontSize: 15,
                            color: CupertinoColors.secondaryLabel
                                .resolveFrom(context),
                          ),
                    ),
                  ],
                  ...children,
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
