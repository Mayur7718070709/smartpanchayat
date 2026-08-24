/// FAQ / Q&A model for Smart Panchayat Assistant.
/// Designed to be replaced by LLM/RAG engine responses in Phase 2
/// without changing the chat UI contract.
class FaqAnswer {
  final String id;
  final String question;
  final String questionEn;
  final String answer;
  final String? source;
  final String? lastUpdated;

  const FaqAnswer({
    required this.id,
    required this.question,
    required this.questionEn,
    required this.answer,
    this.source,
    this.lastUpdated,
  });
}

class AssistantConversation {
  const AssistantConversation({
    required this.id,
    required this.createdAt,
    required this.expiresAt,
  });
  factory AssistantConversation.fromJson(Map<String, dynamic> json) =>
      AssistantConversation(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        expiresAt: DateTime.parse(json['expires_at'] as String),
      );
  final String id;
  final DateTime createdAt;
  final DateTime expiresAt;
}

class AssistantAnswer {
  const AssistantAnswer({
    required this.id,
    required this.conversationId,
    required this.answerEn,
    required this.answerMr,
    required this.outcome,
    required this.createdAt,
    this.citation,
  });
  factory AssistantAnswer.fromJson(Map<String, dynamic> json) =>
      AssistantAnswer(
        id: json['id'] as String,
        conversationId: json['conversation_id'] as String,
        answerEn: json['answer_en'] as String,
        answerMr: json['answer_mr'] as String,
        outcome: json['outcome'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        citation: json['citation'] == null
            ? null
            : Map<String, dynamic>.from(json['citation'] as Map),
      );
  final String id;
  final String conversationId;
  final String answerEn;
  final String answerMr;
  final String outcome;
  final DateTime createdAt;
  final Map<String, dynamic>? citation;
}

/// Chat message model — works for both FAQ and future LLM responses.
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? source;
  final String? lastUpdated;
  final ChatMessageState state;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.source,
    this.lastUpdated,
    this.state = ChatMessageState.delivered,
  });

  ChatMessage copyWith({ChatMessageState? state, String? text}) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      isUser: isUser,
      timestamp: timestamp,
      source: source,
      lastUpdated: lastUpdated,
      state: state ?? this.state,
    );
  }
}

enum ChatMessageState { delivered, typing, noAnswer, networkError }
