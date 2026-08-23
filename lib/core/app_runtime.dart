import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/auth_context_repository.dart';
import 'auth/phone_auth_service.dart';
import 'config/app_config.dart';
import 'citizens/citizen_profile_repository.dart';
import 'complaints/complaint_repository.dart';
import 'feedback/feedback_repository.dart';
import 'faq/faq_repository.dart';
import 'network/api_client.dart';
import 'notices/notice_repository.dart';
import 'notifications/notification_repository.dart';
import 'payments/payment_repository.dart';
import 'requests/service_request_repository.dart';
import 'schemes/scheme_repository.dart';
import 'services/service_repository.dart';

class AppRuntime {
  AppRuntime._();

  static final AppConfig config = AppConfig.fromEnvironment();
  static PhoneAuthService? _auth;
  static FaqRepository? _faq;
  static AuthContextRepository? _authContext;
  static CitizenProfileRepository? _citizenProfile;
  static ComplaintRepository? _complaints;
  static FeedbackRepository? _feedback;
  static NoticeRepository? _notices;
  static NotificationRepository? _notifications;
  static PaymentRepository? _payments;
  static SchemeRepository? _schemes;
  static ServiceRepository? _services;
  static ServiceRequestRepository? _serviceRequests;

  static bool get usesRealApi => config.useRealApi;

  static PhoneAuthService get auth =>
      _auth ?? (throw StateError('Real authentication is not initialized.'));

  static AuthContextRepository get authContext =>
      _authContext ?? (throw StateError('FastAPI client is not initialized.'));

  static FaqRepository get faq =>
      _faq ?? (throw StateError('FAQ repository is not initialized.'));

  static CitizenProfileRepository get citizenProfile =>
      _citizenProfile ??
      (throw StateError('Citizen profile repository is not initialized.'));

  static ServiceRepository get services =>
      _services ?? (throw StateError('Service repository is not initialized.'));

  static ComplaintRepository get complaints =>
      _complaints ??
      (throw StateError('Complaint repository is not initialized.'));

  static FeedbackRepository get feedback =>
      _feedback ??
      (throw StateError('Feedback repository is not initialized.'));

  static NoticeRepository get notices =>
      _notices ?? (throw StateError('Notice repository is not initialized.'));

  static NotificationRepository get notifications =>
      _notifications ??
      (throw StateError('Notification repository is not initialized.'));

  static SchemeRepository get schemes =>
      _schemes ?? (throw StateError('Scheme repository is not initialized.'));

  static PaymentRepository get payments =>
      _payments ?? (throw StateError('Payment repository is not initialized.'));

  static ServiceRequestRepository get serviceRequests =>
      _serviceRequests ??
      (throw StateError('Service request repository is not initialized.'));

  static Future<void> initialize() async {
    final errors = config.validate();
    if (errors.isNotEmpty) throw StateError(errors.join(' '));
    if (!usesRealApi) return;

    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabaseAnonKey,
    );
    final authService = PhoneAuthService(Supabase.instance.client);
    final apiClient = ApiClient(
      config: config,
      tokenProvider: () async => authService.accessToken,
    );
    _auth = authService;
    _faq = FaqRepository(apiClient);
    _authContext = AuthContextRepository(apiClient);
    _citizenProfile = CitizenProfileRepository(apiClient);
    _complaints = ComplaintRepository(apiClient);
    _feedback = FeedbackRepository(apiClient);
    _notices = NoticeRepository(apiClient);
    _notifications = NotificationRepository(apiClient);
    _payments = PaymentRepository(apiClient);
    _schemes = SchemeRepository(apiClient);
    _services = ServiceRepository(apiClient);
    _serviceRequests = ServiceRequestRepository(apiClient);
  }
}
