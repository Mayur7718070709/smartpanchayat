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
