import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_runtime.dart';
import '../../core/requests/service_request.dart';
import '../../theme/app_theme.dart';

class ServiceRequestDetailScreen extends StatefulWidget {
  const ServiceRequestDetailScreen({
    required this.requestId,
    this.serviceName,
    super.key,
  });

  final String requestId;
  final String? serviceName;

  @override
  State<ServiceRequestDetailScreen> createState() =>
      _ServiceRequestDetailScreenState();
}

class _ServiceRequestDetailScreenState
    extends State<ServiceRequestDetailScreen> {
  ServiceRequest? _request;
  List<ServiceRequestStatusHistory> _history = const [];
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<Object>([
        AppRuntime.serviceRequests.fetchById(widget.requestId),
        AppRuntime.serviceRequests.fetchHistory(widget.requestId),
      ]);
      if (!mounted) return;
      setState(() {
        _request = results[0] as ServiceRequest;
        _history = results[1] as List<ServiceRequestStatusHistory>;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: const Text('Request Tracking')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: ElevatedButton(
                onPressed: _load,
                child: const Text('Retry loading request'),
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _summary(_request!),
                  const SizedBox(height: 16),
                  Text(
                    'Status history',
                    style: GoogleFonts.notoSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_history.isEmpty)
                    const Text('No status history found.')
                  else
                    ..._history.map(_historyItem),
                ],
              ),
            ),
    );
  }

  Widget _summary(ServiceRequest request) => Card(
    elevation: 0,
    color: AppTheme.surfaceLight,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.serviceName ?? 'Service Request',
            style: GoogleFonts.notoSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _row('Request number', request.requestNumber),
          _row('Current status', request.status.replaceAll('_', ' ')),
          _row('Created', _formatDateTime(request.createdAt)),
          if (request.applicantNote?.isNotEmpty == true)
            _row('Applicant note', request.applicantNote!),
          if (request.officerRemark?.isNotEmpty == true)
            _row('Officer remark', request.officerRemark!),
          if (request.rejectionReason?.isNotEmpty == true)
            _row('Rejection reason', request.rejectionReason!),
        ],
      ),
    ),
  );

  Widget _historyItem(ServiceRequestStatusHistory item) => Card(
    elevation: 0,
    color: AppTheme.surfaceLight,
    child: ListTile(
      leading: const Icon(Icons.radio_button_checked, color: AppTheme.primary),
      title: Text(item.newStatus.replaceAll('_', ' ')),
      subtitle: Text(
        [
          _formatDateTime(item.changedAt),
          if (item.remark?.isNotEmpty == true) item.remark!,
        ].join('\n'),
      ),
    ),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(top: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/'
      '${local.month.toString().padLeft(2, '0')}/${local.year} '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}
