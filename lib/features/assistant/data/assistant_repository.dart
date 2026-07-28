import '../../../core/errors/result.dart';
import '../../../core/network/api_client.dart';
import 'chat_message.dart';

/// Talks to the KrishiBondhu assistant backend.
///
/// The backend is not live yet — [sendMock] is active. When the agent API
/// ships, swap to [send] in providers.dart (contract: docs/api_contract.md).
class AssistantRepository {
  AssistantRepository(this._api);

  final ApiClient _api;

  /// POST /assistant/chat — the real agent endpoint.
  Future<Result<ChatMessage>> send({
    required String message,
    required List<ChatMessage> history,
    String locale = 'bn',
  }) {
    return _api.post<ChatMessage>(
      '/assistant/chat',
      data: {
        'message': message,
        'locale': locale,
        'history': [for (final m in history) m.toJson()],
      },
      decode: (data) =>
          ChatMessage.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Mock reply until the agent backend exists.
  Future<Result<ChatMessage>> sendMock({
    required String message,
    required List<ChatMessage> history,
    String locale = 'bn',
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return Success(
      ChatMessage(
        id: 'mock-${history.length}',
        role: ChatRole.assistant,
        text: 'আমি এখনো সার্ভারের সাথে যুক্ত হইনি। 🌾\n\n'
            'The KrishiBondhu AI agent is not connected yet — this is a '
            'preview reply. Once the backend is live, your question '
            '("$message") will be answered with real agricultural '
            'intelligence in Bangla.',
      ),
    );
  }
}
