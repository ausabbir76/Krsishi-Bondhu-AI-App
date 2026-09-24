import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/result.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/key_value_storage.dart';
import '../settings/providers.dart';
import 'data/assistant_repository.dart';
import 'data/chat_message.dart';
import 'data/chat_session.dart';

/// Repository provider for the live assistant backend.
final assistantRepositoryProvider = Provider<AssistantRepository>(
  (ref) => AssistantRepository(ref.watch(apiClientProvider)),
);

/// Assistant state: the saved [sessions] (most-recent first), the id of the
/// open conversation (null = the history list is shown), and whether a reply
/// is currently being generated.
class ChatState {
  const ChatState({
    this.sessions = const [],
    this.activeId,
    this.sending = false,
  });

  final List<ChatSession> sessions;
  final String? activeId;
  final bool sending;

  ChatSession? get active {
    final id = activeId;
    if (id == null) return null;
    for (final s in sessions) {
      if (s.id == id) return s;
    }
    return null;
  }
}

class ChatController extends Notifier<ChatState> {
  static const _storageKey = 'assistant.sessions';

  @override
  ChatState build() {
    final raw = ref.read(keyValueStorageProvider).getString(_storageKey);
    if (raw == null) return const ChatState();
    try {
      final list = [
        for (final e in jsonDecode(raw) as List)
          ChatSession.fromJson(e as Map<String, dynamic>),
      ];
      return ChatState(sessions: list);
    } catch (_) {
      return const ChatState();
    }
  }

  /// Open an existing conversation from the history list.
  void openSession(String id) =>
      state = ChatState(sessions: state.sessions, activeId: id);

  /// Start a fresh conversation. The draft is not persisted until the first
  /// message is sent (see [send]); an abandoned empty draft is dropped by
  /// [backToHistory].
  void newChat() {
    final now = DateTime.now();
    final session = ChatSession(
      id: 'sess-${now.microsecondsSinceEpoch}',
      title: '',
      messages: const [],
      updatedAt: now.millisecondsSinceEpoch,
    );
    state = ChatState(
      sessions: [session, ...state.sessions],
      activeId: session.id,
    );
  }

  /// Return to the history list, discarding the active draft if it has no
  /// messages yet.
  void backToHistory() {
    final active = state.active;
    if (active != null && active.messages.isEmpty) {
      final sessions =
          state.sessions.where((s) => s.id != active.id).toList();
      state = ChatState(sessions: sessions);
      _persist(sessions);
    } else {
      state = ChatState(sessions: state.sessions);
    }
  }

  /// Permanently delete a conversation.
  void deleteSession(String id) {
    final sessions = state.sessions.where((s) => s.id != id).toList();
    state = ChatState(
      sessions: sessions,
      activeId: state.activeId == id ? null : state.activeId,
    );
    _persist(sessions);
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.sending) return;

    var session = state.active;
    if (session == null) {
      newChat();
      session = state.active!;
    }

    final userMessage = ChatMessage(
      id: 'user-${session.messages.length}',
      role: ChatRole.user,
      text: trimmed,
    );
    session = session.copyWith(
      title: session.messages.isEmpty ? _titleFrom(trimmed) : session.title,
      messages: [...session.messages, userMessage],
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    _upsert(session, sending: true);

    final result = await ref.read(assistantRepositoryProvider).send(
          message: trimmed,
          history: session.messages,
          locale: ref.read(languageControllerProvider),
        );

    // Re-read from state in case it changed while awaiting.
    final current = state.active?.id == session.id ? state.active! : session;

    final reply = switch (result) {
      Success(:final value) => value,
      // Prefixed marker — the UI maps this to a localized error string.
      Failure(:final error) => ChatMessage(
          id: 'error-${current.messages.length}',
          role: ChatRole.assistant,
          text: '$kChatErrorPrefix${error.message}',
        ),
    };

    _upsert(
      current.copyWith(
        messages: [...current.messages, reply],
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
      sending: false,
    );
  }

  /// Replace [session] in the list, move it to the front (most recent),
  /// keep it active, and persist.
  void _upsert(ChatSession session, {required bool sending}) {
    final sessions = [
      session,
      ...state.sessions.where((s) => s.id != session.id),
    ];
    state = ChatState(
      sessions: sessions,
      activeId: session.id,
      sending: sending,
    );
    _persist(sessions);
  }

  void _persist(List<ChatSession> sessions) {
    ref.read(keyValueStorageProvider).setString(
          _storageKey,
          jsonEncode([for (final s in sessions) s.toJson()]),
        );
  }

  String _titleFrom(String text) {
    final oneLine = text.replaceAll('\n', ' ').trim();
    return oneLine.length <= 40 ? oneLine : '${oneLine.substring(0, 40).trim()}…';
  }
}

/// Marker prefix for error messages (see the assistant UI localization).
const kChatErrorPrefix = '@@error:';

final chatControllerProvider =
    NotifierProvider<ChatController, ChatState>(ChatController.new);
