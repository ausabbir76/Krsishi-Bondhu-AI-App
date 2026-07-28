import 'chat_message.dart';

/// One saved conversation with the assistant.
///
/// A session groups its [messages] under a [title] derived from the first
/// user question. [updatedAt] (epoch millis) orders the history list.
class ChatSession {
  const ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final List<ChatMessage> messages;
  final int updatedAt;

  ChatSession copyWith({
    String? title,
    List<ChatMessage>? messages,
    int? updatedAt,
  }) =>
      ChatSession(
        id: id,
        title: title ?? this.title,
        messages: messages ?? this.messages,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'] as String,
        title: json['title'] as String,
        messages: [
          for (final m in json['messages'] as List)
            ChatMessage.fromJson(m as Map<String, dynamic>),
        ],
        updatedAt: json['updatedAt'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'messages': [for (final m in messages) m.toJson()],
        'updatedAt': updatedAt,
      };
}
