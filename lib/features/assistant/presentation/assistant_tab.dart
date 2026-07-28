import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/ui.dart';
import '../data/chat_message.dart';
import '../data/chat_session.dart';
import '../providers.dart';

/// Assistant tab — a history of chats, and the open conversation.
///
/// When no conversation is active the body is the chat-history list; opening
/// a chat (or starting a new one) swaps the body to the message thread.
///
/// The top title bar and the bottom input bar are frosted [BackdropFilter]
/// chrome floating over the scroll content, so the list and message bubbles
/// slide *behind* them with a live blur — matching the iOS 26 look.
class AssistantTab extends ConsumerStatefulWidget {
  const AssistantTab({super.key});

  @override
  ConsumerState<AssistantTab> createState() => _AssistantTabState();
}

class _AssistantTabState extends ConsumerState<AssistantTab>
    with WidgetsBindingObserver {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  static const _suggestions = [
    'আমার ধানের পাতায় দাগ পড়েছে',
    'When should I plant potatoes?',
    'আজ কি সেচ দেওয়া উচিত?',
    'Best fertilizer for tomatoes?',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Keep the newest message visible when the keyboard opens/resizes.
  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _send([String? text]) {
    final message = text ?? _controller.text;
    _controller.clear();
    ref.read(chatControllerProvider.notifier).send(message);
    // Scroll to bottom after the frame with the new message renders.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatControllerProvider);
    // Keep the newest content in view whenever the thread grows or the
    // typing indicator toggles — covers the async reply landing after send.
    ref.listen(
      chatControllerProvider.select(
        (s) => (s.active?.messages.length ?? 0, s.sending),
      ),
      (_, _) => WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToBottom(),
      ),
    );
    // History list only once there is something to list; before the first
    // chat exists, open straight into the Assistant welcome conversation.
    final showHistory = chat.activeId == null && chat.sessions.isNotEmpty;
    return showHistory
        ? _HistoryView(suggestions: _suggestions)
        : _ConversationView(
            controller: _controller,
            scrollController: _scrollController,
            onSend: _send,
            suggestions: _suggestions,
          );
  }
}

/// Chat-history list — shown when the assistant is first opened.
class _HistoryView extends ConsumerWidget {
  const _HistoryView({required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sessions = ref.watch(chatControllerProvider).sessions;
    final muted = KrishiColors.mutedText.resolveFrom(context);
    final primary = KrishiColors.primary.resolveFrom(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    if (sessions.isEmpty) {
      return SafeArea(
        bottom: false,
        child: _HistoryEmptyState(
          onNewChat: () => ref.read(chatControllerProvider.notifier).newChat(),
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        // Same top offset as the home tab (safe area + 16).
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          16,
          AppSpacing.pageHorizontal,
          bottomInset + AppSpacing.bottomBarClearance,
        ),
        children: [
          // ── Scrollable title row (matches the other tabs' large title) ──
          Row(
            // Top-align so the new-chat button lines up with the title's first
            // line — same vertical position as the more-menu on other screens.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.chatHistoryTitle,
                      style: AppTextStyles.pageTitle(context),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.chatHistorySubtitle,
                      style: TextStyle(fontSize: 14, color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GlassButton(
                onTap: () =>
                    ref.read(chatControllerProvider.notifier).newChat(),
                width: 44,
                height: 44,
                settings: RecommendedGlassSettings.interactive,
                icon: Icon(
                  CupertinoIcons.square_pencil,
                  size: 22,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (final s in sessions) ...[
            _HistoryRow(
              session: s,
              onTap: () =>
                  ref.read(chatControllerProvider.notifier).openSession(s.id),
              onDelete: () =>
                  ref.read(chatControllerProvider.notifier).deleteSession(s.id),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

/// One row in the chat-history list: title + last message preview + count.
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.session,
    required this.onTap,
    required this.onDelete,
  });

  final ChatSession session;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = KrishiColors.primary.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);
    final preview = _preview(context);

    return SolidCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.chat_bubble_2_fill,
              size: 20,
              color: primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  preview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: muted),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.chatMessageCount(session.messages.length),
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            behavior: HitTestBehavior.opaque,
            child: Icon(CupertinoIcons.trash, size: 19, color: muted),
          ),
        ],
      ),
    );
  }

  String _preview(BuildContext context) {
    if (session.messages.isEmpty) return '';
    final last = session.messages.last;
    if (last.text.startsWith(kChatErrorPrefix)) {
      return AppLocalizations.of(
        context,
      ).chatError(last.text.substring(kChatErrorPrefix.length));
    }
    return last.text;
  }
}

/// Empty history — invites the first conversation.
class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState({required this.onNewChat});

  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = KrishiColors.primary.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageHorizontal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.chat_bubble_2_fill,
                size: 40,
                color: primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.chatHistoryEmpty,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.chatHistoryEmptySub,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: muted),
            ),
            const SizedBox(height: 22),
            SolidButton(
              onTap: onNewChat,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.square_pencil, size: 18, color: primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.chatNew,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The open conversation — a title section (glass back button, liquid-glass
/// title pill, more-menu), the message thread, and the input bar.
class _ConversationView extends ConsumerWidget {
  const _ConversationView({
    required this.controller,
    required this.scrollController,
    required this.onSend,
    required this.suggestions,
  });

  final TextEditingController controller;
  final ScrollController scrollController;
  final void Function([String?]) onSend;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chat = ref.watch(chatControllerProvider);
    final session = chat.active;
    final messages = session?.messages ?? const <ChatMessage>[];
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final systemBottom = MediaQuery.viewPaddingOf(context).bottom;
    // Only offer "back" when there is a history list to return to.
    final canGoBack = chat.sessions.isNotEmpty;
    // Fixed title — the pill always reads "Assistant" (not the chat name).
    final title = l10n.tabAssistant;
    // Floating glass islands sit on top of the full-screen thread; content
    // clears them via list padding so nothing hides under the glass.
    // Matches the 44pt glass buttons either side of the title pill.
    const titleBarHeight = 44.0;
    // Mirror HomeScreen's bottom-nav lift so the composer keeps its gap above
    // the tab bar: the bar rises 8pt off an open keyboard, and 10pt off the
    // screen edge on gesture-nav devices with no system inset. Keep this in
    // sync with `barLift` in home_screen.dart.
    final barLift = keyboard > 0 ? 8.0 : (systemBottom > 0 ? 0.0 : 10.0);
    // The input island rides above the keyboard when it's open; otherwise it
    // floats above the bottom tab bar. In both cases it lifts with the nav bar.
    final inputBottom =
        (keyboard > 0 ? keyboard + 8 : bottomInset + 74) + barLift;
    // Same top offset as the home tab (safe area + 16).
    final topClearance = topInset + 15 + titleBarHeight + 10;
    // Clear the input island (48pt tall) plus a 15pt gap — matching the
    // spacing between chat bubbles and between the input and the nav bar.
    final bottomClearance = inputBottom + 48 + 14;

    return Stack(
      children: [
        // ── Full-screen message thread (edge to edge) ──────────────────
        Positioned.fill(
          child: messages.isEmpty
              ? _EmptyState(
                  onSuggestionTap: onSend,
                  suggestions: suggestions,
                  topPadding: topClearance,
                  bottomPadding: bottomClearance,
                )
              : ListView(
                  controller: scrollController,
                  // Snappy iOS momentum + a generous cache so bubbles are
                  // built ~2 screens ahead of the fling for ultra-smooth
                  // scrolling.
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  scrollCacheExtent: const ScrollCacheExtent.viewport(2.0),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    topClearance,
                    AppSpacing.pageHorizontal,
                    bottomClearance,
                  ),
                  // RepaintBoundary isolates each row so one bubble (or the
                  // animated typing indicator at the tail) repainting doesn't
                  // repaint the whole thread.
                  children: [
                    for (final message in messages)
                      RepaintBoundary(child: _MessageBubble(message: message)),
                    if (chat.sending)
                      const RepaintBoundary(child: _TypingIndicator()),
                  ],
                ),
        ),

        // ── Floating title islands: back · title pill · more-menu ──────
        Positioned(
          top: topInset + 16,
          left: AppSpacing.pageHorizontal,
          right: AppSpacing.pageHorizontal,
          child: Row(
            // Top-align: the first-run large title's line box is taller than
            // the 44pt buttons (Bangla glyphs especially), and centering
            // would nudge the more-menu below the home tab's position.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (canGoBack) ...[
                GlassButton.custom(
                  onTap: () =>
                      ref.read(chatControllerProvider.notifier).backToHistory(),
                  width: 44,
                  height: 44,
                  quality: GlassQuality.premium,
                  useOwnLayer: true,
                  settings: RecommendedGlassSettings.homeBottomBar,
                  child: Icon(
                    CupertinoIcons.back,
                    size: 22,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                const SizedBox(width: 16),
                // Custom (non-glass) title pill — mirrors the input field's
                // gradient-rim + solid-fill language so the header no longer
                // pays for a third live glass layer over the scrolling thread.
                Expanded(
                  child: Center(
                    child: _AssistantTitlePill(
                      title: title,
                      height: titleBarHeight,
                    ),
                  ),
                ),
              ] else
                // First-run welcome: a normal large title, like other tabs.
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.pageTitle(context),
                  ),
                ),
              const SizedBox(width: 16),
              // Liquid-glass more-menu: grows out of this button. On the
              // first-run welcome there is nothing to offer (no history, no
              // session to delete, already in a fresh chat), so the button
              // is inert — same look, no popover.
              if (!canGoBack)
                GlassButton.custom(
                  onTap: () {},
                  width: 44,
                  height: 44,
                  quality: GlassQuality.premium,
                  useOwnLayer: true,
                  settings: RecommendedGlassSettings.homeBottomBar,
                  child: Icon(
                    CupertinoIcons.ellipsis,
                    size: 22,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                )
              else
                GlassPopover(
                  popoverWidth: 220,
                  popoverBorderRadius: 22,
                  alignment: GlassMenuAlignment.topRight,
                  // Premium is safe here: the popover is a full-screen overlay
                  // with nothing scrolling behind it (unlike the islands).
                  quality: GlassQuality.premium,
                  settings: RecommendedGlassSettings.homeBottomBar.copyWith(
                    blur: 12,
                    backerColor: KrishiColors.card
                        .resolveFrom(context)
                        .withValues(alpha: 0.92),
                  ),
                  triggerBuilder: (context, toggle) => GlassButton.custom(
                    onTap: toggle,
                    width: 44,
                    height: 44,
                    quality: GlassQuality.premium,
                    useOwnLayer: true,
                    settings: RecommendedGlassSettings.homeBottomBar,
                    child: Icon(
                      CupertinoIcons.ellipsis,
                      size: 22,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                  contentBuilder: (context, close) => _ChatMenu(
                    canGoBack: canGoBack,
                    onNewChat: () {
                      close();
                      ref.read(chatControllerProvider.notifier).newChat();
                    },
                    onAllChats: () {
                      close();
                      ref.read(chatControllerProvider.notifier).backToHistory();
                    },
                    onDelete: session == null
                        ? null
                        : () {
                            close();
                            ref
                                .read(chatControllerProvider.notifier)
                                .deleteSession(session.id);
                          },
                  ),
                ),
            ],
          ),
        ),

        // ── Floating input island ──────────────────────────────────────
        Positioned(
          left: AppSpacing.pageHorizontal,
          right: AppSpacing.pageHorizontal,
          // Rides above the keyboard when open; else above the glass tab bar.
          bottom: inputBottom,
          child: _ChatInputField(
            controller: controller,
            placeholder: l10n.chatPlaceholder,
            sending: chat.sending,
            onMicTap: () =>
                GlassToast.show(context, message: l10n.micComingSoon),
            onSubmitted: onSend,
          ),
        ),
      ],
    );
  }
}

/// Custom (non-glass) title pill for the assistant header.
///
/// Same construction as [_ChatInputField]'s pill — a 1.5pt green gradient
/// rim wrapping a solid [KrishiColors.card] fill, plus a soft ambient glow —
/// so the header reads as one cohesive family with the composer below it,
/// without paying for a second live glass layer over the scrolling thread.
/// A small gradient "spark" badge and a gradient-shaded title lift it past a
/// plain label.
class _AssistantTitlePill extends StatelessWidget {
  const _AssistantTitlePill({required this.title, required this.height});

  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    final glow = KrishiColors.glow.resolveFrom(context);
    final card = KrishiColors.pillFill.resolveFrom(context);
    final border = KrishiColors.cardBorder.resolveFrom(context);

    return Container(
      height: height,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [border, border],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.16),
            blurRadius: 16,
            spreadRadius: -4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((height - 3) / 2),
          color: card,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gradient "spark" badge — the assistant's little brand mark.
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [primary, glow],
                ).createShader(bounds),
                child: const Icon(
                  CupertinoIcons.sparkles,
                  size: 16,
                  color: CupertinoColors.white,
                ),
              ),
              const SizedBox(width: 7),
              // Gradient-shaded title text.
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primary, glow],
                ).createShader(bounds),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom chat composer — a solid, gorgeous alternative to the glass field.
///
/// Deliberately *not* liquid glass (no backdrop capture, no blur) so it stays
/// cheap while riding above a scrolling thread. The look is on-brand: a solid
/// [KrishiColors.card] pill wrapped in a green gradient rim and a soft green
/// glow that both bloom on focus, a circular mic affordance, and an animated
/// send button that lights up only when there is text to send.
class _ChatInputField extends StatefulWidget {
  const _ChatInputField({
    required this.controller,
    required this.placeholder,
    required this.sending,
    required this.onMicTap,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String placeholder;
  final bool sending;
  final VoidCallback onMicTap;
  final void Function([String?]) onSubmitted;

  @override
  State<_ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<_ChatInputField>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  bool _focused = false;
  bool _hasText = false;

  // Radial splash that ripples across the pill on every tap (field or button).
  late final AnimationController _splash = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 480),
  );
  Offset _splashOrigin = Offset.zero;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
    _hasText = widget.controller.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChange);
    _splash.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focused != _focusNode.hasFocus) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  void _onTextChange() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  // Kick a ripple outward from where the finger landed inside the pill.
  void _emitSplash(Offset local) {
    _splashOrigin = local;
    _splash.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    final glow = KrishiColors.glow.resolveFrom(context);
    final card = KrishiColors.pillFill.resolveFrom(context);
    final border = KrishiColors.cardBorder.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);
    final label = CupertinoColors.label.resolveFrom(context);
    // Send is available only with non-blank text and no reply in flight.
    final canSend = _hasText && !widget.sending;
    // The bright leaf-green primary reads as neon on the dark card, so the
    // send puck uses a toned-down fill in dark mode (still on-brand).
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final sendFill = isDark
        ? Color.lerp(primary, CupertinoColors.black, 0.28)!
        : primary;

    // The rim is a 1.5pt gradient stroke: a whisper of green at rest, a full
    // primary→glow sweep when focused. Implemented as a gradient-filled
    // container with an inset solid card, so the gradient only shows at the
    // edges (the classic "gradient border" trick, no shader cost).
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _focused ? [primary, glow] : [border, border],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: _focused ? 0.28 : 0.0),
            blurRadius: _focused ? 18 : 0,
            spreadRadius: _focused ? -2 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Clip so the ripple is contained by the pill's rounded corners.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.5),
        child: ColoredBox(
          color: card,
          // Listener (not a gesture detector) observes every pointer-down in
          // the pill without stealing it, so the field still focuses and the
          // buttons still fire while we ripple from the touch point.
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (e) => _emitSplash(e.localPosition),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
                  child: Row(
                    // Center everything against the pill's rounded corners.
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Mic affordance ──────────────────────────────────
                      _BouncyTap(
                        onTap: widget.onMicTap,
                        child: Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.mic_fill,
                            size: 19,
                            color: primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ── The field itself ────────────────────────────────
                      Expanded(
                        child: CupertinoTextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          placeholder: widget.placeholder,
                          placeholderStyle: TextStyle(
                            fontSize: 15,
                            color: muted,
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.3,
                            color: label,
                          ),
                          cursorColor: primary,
                          minLines: 1,
                          maxLines: 5,
                          textInputAction: TextInputAction.send,
                          keyboardAppearance:
                              CupertinoTheme.of(context).brightness ??
                              Brightness.dark,
                          onSubmitted: (_) => widget.onSubmitted(),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: const BoxDecoration(),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // ── Send button — blooms to a filled gradient puck the
                      //    moment there is something to send. ───────────────
                      _BouncyTap(
                        enabled: canSend,
                        onTap: () => widget.onSubmitted(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: canSend
                                ? sendFill
                                : primary.withValues(alpha: 0.14),
                            boxShadow: canSend
                                ? [
                                    BoxShadow(
                                      color: sendFill.withValues(alpha: 0.28),
                                      blurRadius: 10,
                                      spreadRadius: -3,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_up,
                            size: 20,
                            color: canSend
                                ? CupertinoColors.white
                                : primary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Ripple overlay (drawn above the row, ignores pointers) ──
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _splash,
                      builder: (context, _) => CustomPaint(
                        painter: _SplashPainter(
                          origin: _splashOrigin,
                          progress: _splash.value,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Press-to-shrink, release-to-pop micro-interaction: the child scales down
/// under the finger, then springs back past 1.0 (a little zoom "jump") on
/// release. Disabled taps are inert (no animation, no callback).
class _BouncyTap extends StatefulWidget {
  const _BouncyTap({
    required this.child,
    required this.onTap,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<_BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<_BouncyTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 340),
  );
  // Forward → shrink; reverse → elastic pop back to (and briefly past) 1.0.
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.86)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
          reverseCurve: Curves.elasticOut,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _release() {
    if (_controller.status == AnimationStatus.forward ||
        _controller.value > 0) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.enabled ? (_) => _controller.forward() : null,
      onTapUp: widget.enabled
          ? (_) {
              _release();
              widget.onTap();
            }
          : null,
      onTapCancel: widget.enabled ? _release : null,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

/// Paints the liquid-glass-style touch glow inside the input pill.
///
/// Mirrors the package's finger-glow: a soft [RadialGradient] (bright at the
/// touch point, transparent at the rim) that blooms from where the finger
/// lands and spreads outward across the pill as it fades — not a flat disc or
/// a hard ring.
class _SplashPainter extends CustomPainter {
  const _SplashPainter({
    required this.origin,
    required this.progress,
    required this.color,
  });

  final Offset origin;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final t = Curves.easeOut.transform(progress);
    // Reach to the farthest corner so the glow sweeps the whole pill.
    final dx = math.max(origin.dx, size.width - origin.dx);
    final dy = math.max(origin.dy, size.height - origin.dy);
    final maxRadius = math.sqrt(dx * dx + dy * dy);
    // Bloom out from ~35% of full reach to the far corner.
    final radius = maxRadius * (0.35 + 0.65 * t);
    // Soft glow: brightest at the touch point, transparent at the edge,
    // fading overall as it spreads.
    final centerAlpha = (1 - t) * 0.3;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: centerAlpha),
          color.withValues(alpha: 0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: origin, radius: radius));
    canvas.drawCircle(origin, radius, paint);
  }

  @override
  bool shouldRepaint(_SplashPainter old) =>
      old.progress != progress || old.origin != origin;
}

/// Contents of the conversation more-menu popover: new chat, all chats,
/// delete. [onDelete] is null when there is no active session to delete.
class _ChatMenu extends StatelessWidget {
  const _ChatMenu({
    required this.canGoBack,
    required this.onNewChat,
    required this.onAllChats,
    required this.onDelete,
  });

  final bool canGoBack;
  final VoidCallback onNewChat;
  final VoidCallback onAllChats;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ChatMenuItem(
            icon: CupertinoIcons.square_pencil,
            iconColor: primary,
            label: l10n.chatNew,
            onTap: onNewChat,
          ),
          if (canGoBack)
            _ChatMenuItem(
              icon: CupertinoIcons.list_bullet,
              iconColor: CupertinoColors.label.resolveFrom(context),
              label: l10n.chatAllChats,
              onTap: onAllChats,
            ),
          if (onDelete != null) ...[
            _ChatMenuDivider(),
            _ChatMenuItem(
              icon: CupertinoIcons.trash,
              iconColor: KrishiColors.danger,
              label: l10n.chatDelete,
              labelColor: KrishiColors.danger,
              onTap: onDelete!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ChatMenuItem extends StatelessWidget {
  const _ChatMenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: labelColor ?? CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: KrishiColors.cardBorder.resolveFrom(context),
    );
  }
}

/// Welcome view with tappable question suggestions.
class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.onSuggestionTap,
    required this.suggestions,
    required this.topPadding,
    required this.bottomPadding,
  });

  final void Function(String) onSuggestionTap;
  final List<String> suggestions;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        topPadding,
        AppSpacing.pageHorizontal,
        bottomPadding,
      ),
      children: [
        Center(
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.chat_bubble_2_fill,
              size: 40,
              color: primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            AppLocalizations.of(context).assistantEmptyTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            AppLocalizations.of(context).assistantEmptySubtitle,
            style: TextStyle(
              fontSize: 14,
              color: KrishiColors.mutedText.resolveFrom(context),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.section),
        SubSectionLabel(label: AppLocalizations.of(context).tryAsking),
        const SizedBox(height: 10),
        for (final s in suggestions) ...[
          SolidCard(
            onTap: () => onSuggestionTap(s),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Icon(CupertinoIcons.sparkles, size: 17, color: primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

/// One chat bubble — user messages in brand green, AI replies on card fill.
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final primary = KrishiColors.primary.resolveFrom(context);
    // Error messages carry a marker prefix so they localize at render time.
    final text = message.text.startsWith(kChatErrorPrefix)
        ? AppLocalizations.of(
            context,
          ).chatError(message.text.substring(kChatErrorPrefix.length))
        : message.text;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? primary.withValues(alpha: 0.22)
              : KrishiColors.card.resolveFrom(context),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 5),
            bottomRight: Radius.circular(isUser ? 5 : 18),
          ),
          border: isUser
              ? null
              : Border.all(color: KrishiColors.cardBorder.resolveFrom(context)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            height: 1.35,
            color: CupertinoColors.label.resolveFrom(context),
          ),
        ),
      ),
    );
  }
}

/// "Assistant is typing" placeholder row.
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: KrishiColors.card.resolveFrom(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: KrishiColors.cardBorder.resolveFrom(context),
          ),
        ),
        child: GlassProgressIndicator.circular(
          size: 18,
          // Default falls back to the light glow/iOS-blue, which is invisible
          // on the white card in light mode — pin it to the brand green.
          color: KrishiColors.primary.resolveFrom(context),
        ),
      ),
    );
  }
}
