import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_runtime.dart';
import '../../core/network/api_exception.dart';
import '../../data/mock_data.dart';
import '../../models/complaint_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ds_states.dart';
import './create_complaint_screen.dart';
import './track_complaint_screen.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  bool _isLoading = true;
  bool _isOffline = false;
  bool _hasError = false;
  bool _featureUnavailable = false;
  List<ComplaintModel> _complaints = [];

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _isOffline = false;
      _featureUnavailable = false;
    });

    try {
      if (AppRuntime.usesRealApi) {
        final complaints = await AppRuntime.complaints.list();
        if (!mounted) return;
        setState(() {
          _complaints = complaints;
          _isLoading = false;
        });
        return;
      }
      final result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        setState(() {
          _isOffline = true;
          _isLoading = false;
        });
        return;
      }

      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {
        _complaints = MockData.mockComplaints;
        _isLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _featureUnavailable =
            error.code == ApiErrorCode.databaseContractGap ||
            error.code == ApiErrorCode.featureNotEnabled;
        _hasError = !_featureUnavailable;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'तक्रारी',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Complaints',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadComplaints,
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.primary),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreateComplaintScreen()),
          );
          if (result == true) _loadComplaints();
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'नवीन तक्रार',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const DSLoadingState(
        message: 'तक्रारी लोड होत आहेत...\nLoading complaints...',
      );
    }

    if (_isOffline) {
      return _buildOfflineState();
    }

    if (_featureUnavailable) {
      return const DSErrorState(
        title: 'Complaints unavailable',
        message:
            'The production complaint workflow is awaiting approved Panchayat lifecycle and security rules.',
      );
    }

    if (_hasError) {
      return DSErrorState(
        title: 'त्रुटी आली',
        message: 'तक्रारी लोड करताना समस्या आली. कृपया पुन्हा प्रयत्न करा.',
        retryLabel: 'पुन्हा प्रयत्न करा',
        onRetry: _loadComplaints,
      );
    }

    if (_complaints.isEmpty) {
      return DSEmptyState(
        icon: Icons.report_problem_outlined,
        title: 'कोणतीही तक्रार नाही',
        subtitle:
            'तुम्ही अजून कोणतीही तक्रार नोंदवलेली नाही.\nNo complaints registered yet.',
        actionLabel: 'नवीन तक्रार नोंदवा',
        onAction: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreateComplaintScreen()),
          );
          if (result == true) _loadComplaints();
        },
        iconColor: AppTheme.statusPending,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadComplaints,
      color: AppTheme.primary,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _buildSummaryRow(),
          const SizedBox(height: 16),
          ..._complaints.map((c) => _buildComplaintCard(c)),
        ],
      ),
    );
  }

  Widget _buildOfflineState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppTheme.warningContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: AppTheme.warning,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'इंटरनेट कनेक्शन नाही',
              style: AppTheme.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'No internet connection. Please check your network and try again.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _loadComplaints,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                'पुन्हा प्रयत्न करा',
                style: GoogleFonts.notoSans(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.onPrimary,
                minimumSize: const Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    final pending = _complaints
        .where(
          (c) =>
              c.currentStatus == ComplaintStatus.submitted ||
              c.currentStatus == ComplaintStatus.assigned ||
              c.currentStatus == ComplaintStatus.inProgress,
        )
        .length;
    final resolved = _complaints
        .where(
          (c) =>
              c.currentStatus == ComplaintStatus.resolved ||
              c.currentStatus == ComplaintStatus.closed,
        )
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryChip(
            label: 'एकूण / Total',
            value: '${_complaints.length}',
            color: AppTheme.primary,
            bgColor: AppTheme.primaryContainer,
            icon: Icons.list_alt_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryChip(
            label: 'प्रलंबित / Pending',
            value: '$pending',
            color: AppTheme.warning,
            bgColor: AppTheme.warningContainer,
            icon: Icons.hourglass_empty_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryChip(
            label: 'निराकरण / Resolved',
            value: '$resolved',
            color: AppTheme.success,
            bgColor: AppTheme.successContainer,
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryChip({
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(ComplaintModel complaint) {
    final statusColor = complaint.currentStatus.color;
    final statusBg = statusColor.withAlpha(26);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => TrackComplaintScreen(complaint: complaint),
          ),
        );
        if (result == true) _loadComplaints();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: complaint.category.color.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      complaint.category.icon,
                      color: complaint.category.color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                complaint.category.labelEn,
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                complaint.currentStatus.labelEn,
                                style: GoogleFonts.notoSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          complaint.description,
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantLight,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.confirmation_number_outlined,
                    size: 14,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '#${complaint.complaintId}',
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(complaint.submittedAt),
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppTheme.textTertiary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
