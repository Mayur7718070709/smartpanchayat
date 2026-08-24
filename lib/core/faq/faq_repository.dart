import '../network/api_client.dart';
import '../../models/faq_model.dart';

/// Dynamic FAQ is an authenticated, gated capability.
/// Static FAQ content remains a demo/offline fixture and is not decoded as if
/// it came from this endpoint.
class FaqRepository {
  const FaqRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> listFaq() => _apiClient.get(
    '/api/v1/faq',
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(),
  );

  Future<AssistantConversation> createConversation() => _apiClient.post(
    '/api/v1/assistant/conversations',
    decode: (data) =>
        AssistantConversation.fromJson(data as Map<String, dynamic>),
  );

  Future<AssistantAnswer> ask(String conversationId, String question) =>
      _apiClient.post(
        '/api/v1/assistant/conversations/$conversationId/messages',
        data: {'question': question},
        decode: (data) =>
            AssistantAnswer.fromJson(data as Map<String, dynamic>),
      );

  Future<void> deleteConversation(String conversationId) =>
      _apiClient.delete<void>(
        '/api/v1/assistant/conversations/$conversationId',
        decode: (_) {},
      );
}
