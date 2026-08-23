import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_runtime.dart';
import '../../core/requests/service_request.dart';
import '../../models/service_model.dart';
import '../../theme/app_theme.dart';
import 'service_request_detail_screen.dart';

class ServiceRequestsScreen extends StatefulWidget {
  const ServiceRequestsScreen({super.key});

  @override
  State<ServiceRequestsScreen> createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends State<ServiceRequestsScreen> {
  List<ServiceRequest> _requests = const [];
  Map<String, ServiceModel> _services = const {};
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
        AppRuntime.serviceRequests.fetchAll(),
        AppRuntime.services.fetchAll(),
      ]);
      if (!mounted) return;
      final services = results[1] as List<ServiceModel>;
      setState(() {
        _requests = results[0] as List<ServiceRequest>;
        _services = {for (final item in services) item.id: item};
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
      appBar: AppBar(title: const Text('My Service Requests')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _FailureState(onRetry: _load)
          : RefreshIndicator(
              onRefresh: _load,
              child: _requests.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _requests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final request = _requests[index];
                        return _RequestCard(
                          request: request,
                          serviceName: _services[request.serviceId]?.nameMr,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceRequestDetailScreen(
                                requestId: request.id,
                                serviceName:
                                    _services[request.serviceId]?.nameMr,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.serviceName,
    required this.onTap,
  });

  final ServiceRequest request;
  final String? serviceName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppTheme.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      serviceName ?? 'Service',
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _StatusBadge(status: request.status),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                request.requestNumber,
                style: GoogleFonts.notoSans(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Updated ${_formatDate(request.updatedAt)}',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: GoogleFonts.notoSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Unable to load service requests.'),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => ListView(
    children: const [
      SizedBox(height: 180),
      Icon(Icons.assignment_outlined, size: 56, color: AppTheme.textTertiary),
      SizedBox(height: 14),
      Center(child: Text('No service requests found.')),
    ],
  );
}

String _formatDate(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/'
    '${value.month.toString().padLeft(2, '0')}/${value.year}';

Color _statusColor(String status) {
  switch (status) {
    case 'COMPLETED':
    case 'APPROVED':
      return AppTheme.success;
    case 'REJECTED':
    case 'CANCELLED':
      return AppTheme.error;
    case 'IN_PROGRESS':
    case 'UNDER_REVIEW':
      return AppTheme.info;
    default:
      return AppTheme.warning;
  }
}
