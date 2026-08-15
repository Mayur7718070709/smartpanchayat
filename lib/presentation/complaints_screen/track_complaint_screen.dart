import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/complaint_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ds_states.dart';

class TrackComplaintScreen extends StatefulWidget {
  final ComplaintModel complaint;

  const TrackComplaintScreen({required this.complaint, super.key});

  @override
  State<TrackComplaintScreen> createState() => _TrackComplaintScreenState();
}

class _TrackComplaintScreenState extends State<TrackComplaintScreen> {
  bool _isLoading = false;
  int? _userRating;
  final _additionalInfoController = TextEditingController();
  bool _showAddInfo = false;
  bool _infoSubmitted = false;

  bool get _canRate =>
      widget.complaint.currentStatus == ComplaintStatus.resolved ||
      widget.complaint.currentStatus == ComplaintStatus.closed;

  bool get _canReopen =>
      widget.complaint.canReopen &&
      (widget.complaint.currentStatus == ComplaintStatus.resolved ||
          widget.complaint.currentStatus == ComplaintStatus.closed);

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _submitAdditionalInfo() async {
    if (_additionalInfoController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _isLoading = false;
      _infoSubmitted = true;
      _showAddInfo = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'माहिती जोडली / Information added successfully',
            style: GoogleFonts.notoSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _submitRating(int rating) async {
    setState(() => _userRating = rating);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'रेटिंग दिल्याबद्दल धन्यवाद! / Thank you for your rating!',
            style: GoogleFonts.notoSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _reopenComplaint() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'तक्रार पुन्हा उघडा',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'तुम्हाला ही तक्रार पुन्हा उघडायची आहे का?\nDo you want to reopen this complaint?',
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'नाही / No',
              style: GoogleFonts.notoSans(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'हो, पुन्हा उघडा',
              style: GoogleFonts.notoSans(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'तक्रार पुन्हा उघडली / Complaint reopened',
            style: GoogleFonts.notoSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.warning,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'तक्रार ट्रॅक करा',
              style: GoogleFonts.notoSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '#${widget.complaint.complaintId}',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const DSLoadingState(message: 'प्रक्रिया होत आहे...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildComplaintHeader(),
                  const SizedBox(height: 16),
                  _buildTimeline(),
                  const SizedBox(height: 16),
                  if (_canRate) _buildRatingSection(),
                  if (_canRate) const SizedBox(height: 16),
                  _buildAddInfoSection(),
                  const SizedBox(height: 16),
                  if (_canReopen) _buildReopenButton(),
                  if (_canReopen) const SizedBox(height: 16),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildComplaintHeader() {
    final statusColor = widget.complaint.currentStatus.color;
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.complaint.category.color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.complaint.category.icon,
                  color: widget.complaint.category.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.complaint.category.labelEn,
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      widget.complaint.category.labelMr,
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withAlpha(80)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.complaint.currentStatus.icon,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.complaint.currentStatus.labelEn,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: AppTheme.dividerLight),
          Text(
            widget.complaint.description,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          if (widget.complaint.location != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 14,
                  color: AppTheme.error,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.complaint.location!,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 14,
                color: AppTheme.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                'Submitted: ${_formatDateTime(widget.complaint.submittedAt)}',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final allStatuses = ComplaintStatus.values;
    final currentIndex = allStatuses.indexOf(widget.complaint.currentStatus);

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'तक्रार स्थिती / Complaint Timeline',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(allStatuses.length, (index) {
            final status = allStatuses[index];
            final isCompleted = index <= currentIndex;
            final isCurrent = index == currentIndex;
            final isLast = index == allStatuses.length - 1;

            // Find matching timeline event
            final event = widget.complaint.timeline
                .where((e) => e.status == status)
                .firstOrNull;

            return _buildTimelineItem(
              status: status,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isLast: isLast,
              event: event,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required ComplaintStatus status,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
    ComplaintTimelineEvent? event,
  }) {
    final color = isCompleted ? status.color : AppTheme.outlineLight;
    final bgColor = isCompleted
        ? status.color.withAlpha(26)
        : AppTheme.surfaceVariantLight;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot + line
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color,
                      width: isCurrent ? 2.5 : 1.5,
                    ),
                  ),
                  child: Icon(
                    status.icon,
                    size: 16,
                    color: isCompleted ? status.color : AppTheme.textTertiary,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted
                          ? status.color.withAlpha(80)
                          : AppTheme.outlineLight,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        status.labelEn,
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: isCurrent
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isCompleted
                              ? AppTheme.textPrimary
                              : AppTheme.textTertiary,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: status.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Current',
                            style: GoogleFonts.notoSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    status.labelMr,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: isCompleted
                          ? AppTheme.textSecondary
                          : AppTheme.textTertiary,
                    ),
                  ),
                  if (event != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(event.dateTime),
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    if (event.officerName != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_rounded,
                            size: 12,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.officerName!,
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: AppTheme.textTertiary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (event.officerRemark != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: status.color.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: status.color.withAlpha(50)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.format_quote_rounded,
                              size: 14,
                              color: status.color,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                event.officerRemark!,
                                style: GoogleFonts.notoSans(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    final alreadyRated = widget.complaint.rating != null || _userRating != null;
    final displayRating = _userRating ?? widget.complaint.rating;

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppTheme.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'तक्रार निराकरणाचे मूल्यांकन करा',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            'Rate the resolution / Rate Complaint Resolution',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          if (alreadyRated)
            Row(
              children: [
                ...List.generate(5, (i) {
                  return Icon(
                    i < (displayRating ?? 0)
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppTheme.accent,
                    size: 32,
                  );
                }),
                const SizedBox(width: 12),
                Text(
                  'धन्यवाद! / Thank you!',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: AppTheme.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => _submitRating(i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star_border_rounded,
                      color: AppTheme.accent,
                      size: 36,
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildAddInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'अतिरिक्त माहिती जोडा',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Add Additional Information',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!_infoSubmitted)
                TextButton.icon(
                  onPressed: () => setState(() => _showAddInfo = !_showAddInfo),
                  icon: Icon(
                    _showAddInfo ? Icons.close_rounded : Icons.add_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _showAddInfo ? 'रद्द करा' : 'जोडा',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                  ),
                ),
            ],
          ),
          if (_infoSubmitted) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.successContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.success,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'माहिती यशस्वीरित्या जोडली / Info added',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_showAddInfo && !_infoSubmitted) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _additionalInfoController,
              maxLines: 3,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'अतिरिक्त माहिती लिहा... / Enter additional info...',
                hintStyle: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppTheme.textTertiary,
                ),
                filled: true,
                fillColor: AppTheme.surfaceVariantLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.outlineLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.outlineLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppTheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _submitAdditionalInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'माहिती सादर करा / Submit Info',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReopenButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: _reopenComplaint,
        icon: const Icon(Icons.refresh_rounded, size: 20),
        label: Text(
          'तक्रार पुन्हा उघडा / Reopen Complaint',
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.warning,
          side: const BorderSide(color: AppTheme.warning, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
