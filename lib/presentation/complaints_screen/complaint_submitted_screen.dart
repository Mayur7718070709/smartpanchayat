import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/complaint_model.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import './track_complaint_screen.dart';

class ComplaintSubmittedScreen extends StatefulWidget {
  final String? recordId;
  final String complaintId;
  final ComplaintCategory category;
  final String description;
  final String? location;

  const ComplaintSubmittedScreen({
    this.recordId,
    required this.complaintId,
    required this.category,
    required this.description,
    this.location,
    super.key,
  });

  @override
  State<ComplaintSubmittedScreen> createState() =>
      _ComplaintSubmittedScreenState();
}

class _ComplaintSubmittedScreenState extends State<ComplaintSubmittedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildSuccessIcon(),
                    const SizedBox(height: 28),
                    _buildSuccessTitle(),
                    const SizedBox(height: 28),
                    _buildComplaintIdCard(now),
                    const SizedBox(height: 20),
                    _buildDetailsCard(now),
                    const SizedBox(height: 20),
                    _buildNextStepsCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.successContainer,
          boxShadow: [
            BoxShadow(
              color: AppTheme.success.withAlpha(51),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          size: 64,
          color: AppTheme.success,
        ),
      ),
    );
  }

  Widget _buildSuccessTitle() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          Text(
            'तक्रार यशस्वीरित्या नोंदवली!',
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Complaint Submitted Successfully!',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'तुमची तक्रार प्राप्त झाली आहे. लवकरच कार्यवाही सुरू होईल.',
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: AppTheme.textTertiary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintIdCard(DateTime now) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.confirmation_number_outlined,
                    size: 20,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        'तक्रार क्रमांक / Complaint ID',
                        style: GoogleFonts.notoSans(
                          fontSize: 11,
                          color: AppTheme.primary,
                        ),
                      ),
                      Text(
                        widget.complaintId,
                        style: GoogleFonts.notoSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: widget.complaintId),
                      );
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Complaint ID copied / क्रमांक कॉपी केला',
                            style: GoogleFonts.notoSans(fontSize: 13),
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.copy_rounded,
                      size: 18,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.category_rounded,
              'श्रेणी / Category',
              widget.category.labelEn,
              widget.category.color,
            ),
            const Divider(height: 20, color: AppTheme.dividerLight),
            _buildInfoRow(
              Icons.calendar_today_rounded,
              'तारीख / Date',
              '${now.day}/${now.month}/${now.year}',
              AppTheme.textSecondary,
            ),
            const Divider(height: 20, color: AppTheme.dividerLight),
            _buildInfoRow(
              Icons.access_time_rounded,
              'वेळ / Time',
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
              AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: AppTheme.textTertiary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.notoSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(DateTime now) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'तक्रारीचे वर्णन / Description',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.description,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
            if (widget.location != null) ...[
              const Divider(height: 20, color: AppTheme.dividerLight),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.location!,
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.infoContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.info.withAlpha(60)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppTheme.info,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'पुढील प्रक्रिया / What Happens Next',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStep('1', 'तुमची तक्रार संबंधित अधिकाऱ्यांना पाठवली जाईल'),
            _buildStep('2', 'अधिकारी तुमच्याशी संपर्क साधतील'),
            _buildStep('3', 'समस्येचे निराकरण केले जाईल'),
            _buildStep('4', 'तुम्हाला अपडेट मिळेल'),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.info,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                num,
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppTheme.onInfoContainer,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final newComplaint = ComplaintModel(
      id: widget.recordId ?? 'new_${widget.complaintId}',
      complaintId: widget.complaintId,
      category: widget.category,
      description: widget.description,
      location: widget.location,
      currentStatus: ComplaintStatus.submitted,
      submittedAt: DateTime.now(),
      timeline: [
        ComplaintTimelineEvent(
          status: ComplaintStatus.submitted,
          dateTime: DateTime.now(),
          officerRemark: 'तक्रार प्राप्त झाली. लवकरच कार्यवाही होईल.',
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TrackComplaintScreen(complaint: newComplaint),
                  ),
                );
              },
              icon: const Icon(Icons.track_changes_rounded, size: 20),
              label: Text(
                'तक्रार ट्रॅक करा / Track Complaint',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.feedbackScreen),
              icon: const Icon(Icons.star_outline_rounded, size: 18),
              label: Text(
                'अभिप्राय द्या / Give Feedback',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accent,
                side: const BorderSide(color: AppTheme.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'मुख्यपृष्ठावर जा / Go to Home',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
