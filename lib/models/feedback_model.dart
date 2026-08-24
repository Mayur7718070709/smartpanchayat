class FeedbackEligibleRequest {
  const FeedbackEligibleRequest({
    required this.serviceRequestId,
    required this.requestNumber,
    required this.serviceId,
    required this.serviceNameMr,
    required this.serviceNameEn,
    this.completedAt,
  });

  factory FeedbackEligibleRequest.fromJson(Map<String, dynamic> json) =>
      FeedbackEligibleRequest(
        serviceRequestId: json['service_request_id'] as String,
        requestNumber: json['request_number'] as String,
        serviceId: json['service_id'] as String,
        serviceNameMr: json['service_name_mr'] as String,
        serviceNameEn: json['service_name_en'] as String,
        completedAt: json['completed_at'] == null
            ? null
            : DateTime.parse(json['completed_at'] as String),
      );

  final String serviceRequestId;
  final String requestNumber;
  final String serviceId;
  final String serviceNameMr;
  final String serviceNameEn;
  final DateTime? completedAt;
}

class ServiceFeedback {
  const ServiceFeedback({
    required this.id,
    required this.serviceRequestId,
    required this.serviceId,
    required this.requestNumber,
    required this.serviceNameMr,
    required this.serviceNameEn,
    required this.overallRating,
    required this.categoryRatings,
    required this.createdAt,
    this.comment,
  });

  factory ServiceFeedback.fromJson(Map<String, dynamic> json) =>
      ServiceFeedback(
        id: json['id'] as String,
        serviceRequestId: json['service_request_id'] as String,
        serviceId: json['service_id'] as String,
        requestNumber: json['request_number'] as String,
        serviceNameMr: json['service_name_mr'] as String,
        serviceNameEn: json['service_name_en'] as String,
        overallRating: json['overall_rating'] as int,
        categoryRatings: Map<String, int>.from(json['category_ratings'] as Map),
        comment: json['comment'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  final String id;
  final String serviceRequestId;
  final String serviceId;
  final String requestNumber;
  final String serviceNameMr;
  final String serviceNameEn;
  final int overallRating;
  final Map<String, int> categoryRatings;
  final String? comment;
  final DateTime createdAt;
}
