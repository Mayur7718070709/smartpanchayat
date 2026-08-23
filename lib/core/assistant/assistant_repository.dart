import '../network/api_client.dart';

/// The current assistant is backed by the controlled FAQ knowledge base.
/// No standalone assistant/conversation API exists in the approved contract.
class AssistantRepository {
  const AssistantRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkKnowledgeBaseAvailability() =>
      _apiClient.get<void>('/api/v1/faq', decode: (_) {});
}
