import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<ServiceRequestDocument> _documents = const [];
  List<ServiceRequestCorrection> _corrections = const [];
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
        AppRuntime.serviceRequests.fetchDocuments(widget.requestId),
        AppRuntime.serviceRequests.fetchCorrections(widget.requestId),
      ]);
      if (!mounted) return;
      setState(() {
        _request = results[0] as ServiceRequest;
        _history = results[1] as List<ServiceRequestStatusHistory>;
        _documents = results[2] as List<ServiceRequestDocument>;
        _corrections = results[3] as List<ServiceRequestCorrection>;
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
                  _documentSection(),
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

  Widget _documentSection() => Card(
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documents & certificate',
            style: GoogleFonts.notoSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (_corrections
              .where((item) => item.status == 'OPEN')
              .isNotEmpty) ...[
            const SizedBox(height: 8),
            ..._corrections
                .where((item) => item.status == 'OPEN')
                .map(
                  (item) => Text(
                    'Correction required${item.documentCode == null ? '' : ' (${item.documentCode})'}: ${item.reason}',
                    style: const TextStyle(color: AppTheme.error),
                  ),
                ),
          ],
          const SizedBox(height: 8),
          if (_documents.isEmpty)
            const Text('No documents uploaded.')
          else
            ..._documents.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined),
                title: Text(item.filename),
                subtitle: Text(
                  '${item.documentCode} • ${item.status.replaceAll('_', ' ')}${item.rejectionReason == null ? '' : '\n${item.rejectionReason}'}',
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: _uploadDocument,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload / resubmit document'),
          ),
          if (_request?.status == 'COMPLETED')
            FilledButton.icon(
              onPressed: _openCertificate,
              icon: const Icon(Icons.download),
              label: const Text('Download final certificate'),
            ),
        ],
      ),
    ),
  );

  Future<void> _uploadDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );
    final file = result?.files.single;
    if (file?.bytes == null || !mounted) return;
    final codeController = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document code'),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(hintText: 'Example: birth-proof'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, codeController.text.trim()),
            child: const Text('Upload'),
          ),
        ],
      ),
    );
    codeController.dispose();
    if (code == null || code.isEmpty) return;
    final extension = file!.extension?.toLowerCase();
    final mime = extension == 'pdf'
        ? 'application/pdf'
        : extension == 'png'
        ? 'image/png'
        : 'image/jpeg';
    try {
      await AppRuntime.serviceRequests.uploadDocument(
        widget.requestId,
        code,
        file.name,
        mime,
        file.bytes!,
      );
      await _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document upload failed. Please retry.'),
          ),
        );
      }
    }
  }

  Future<void> _openCertificate() async {
    try {
      final url = await AppRuntime.serviceRequests.certificateUrl(
        widget.requestId,
      );
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw StateError('open failed');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Certificate is not available yet.')),
        );
      }
    }
  }

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
