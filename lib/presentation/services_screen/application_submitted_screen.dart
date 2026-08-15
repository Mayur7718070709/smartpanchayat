import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/service_model.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class ApplicationSubmittedScreen extends StatefulWidget {
  final ServiceModel service;
  final String requestId;
  final DateTime submittedDate;

  const ApplicationSubmittedScreen({
    required this.service,
    required this.requestId,
    required this.submittedDate,
    super.key,
  });

  @override
  State<ApplicationSubmittedScreen> createState() =>
      _ApplicationSubmittedScreenState();
}

class _ApplicationSubmittedScreenState extends State<ApplicationSubmittedScreen>
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

  String _formatDate(DateTime date) {
    const months = [
      'जानेवारी',
      'फेब्रुवारी',
      'मार्च',
      'एप्रिल',
      'मे',
      'जून',
      'जुलै',
      'ऑगस्ट',
      'सप्टेंबर',
      'ऑक्टोबर',
      'नोव्हेंबर',
      'डिसेंबर',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildRequestCard(),
                    const SizedBox(height: 20),
                    _buildStatusTimeline(),
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
            'अर्ज यशस्वीरित्या सादर झाला!',
            style: GoogleFonts.notoSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Application Submitted Successfully!',
            style: GoogleFonts.notoSans(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'तुमचा अर्ज प्राप्त झाला आहे. लवकरच प्रक्रिया सुरू होईल.',
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

  Widget _buildRequestCard() {
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
            // Request ID
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
                        'विनंती क्रमांक / Request ID',
                        style: GoogleFonts.notoSans(
                          fontSize: 11,
                          color: AppTheme.primary,
                        ),
                      ),
                      Text(
                        widget.requestId,
                        style: GoogleFonts.notoSans(
                          fontSize: 20,
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
                      Clipboard.setData(ClipboardData(text: widget.requestId));
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Request ID copied / क्रमांक कॉपी केला',
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
            Container(height: 1, color: AppTheme.dividerLight),
            const SizedBox(height: 16),
            // Details grid
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    icon: Icons.calendar_today_outlined,
                    labelMr: 'तारीख',
                    labelEn: 'Date',
                    value: _formatDate(widget.submittedDate),
                    color: AppTheme.info,
                  ),
                ),
                Container(width: 1, height: 50, color: AppTheme.dividerLight),
                Expanded(
                  child: _DetailItem(
                    icon: widget.service.icon,
                    labelMr: 'सेवा',
                    labelEn: 'Service',
                    value: widget.service.nameMr,
                    color: widget.service.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: AppTheme.dividerLight),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    icon: Icons.timer_outlined,
                    labelMr: 'प्रक्रिया वेळ',
                    labelEn: 'Processing',
                    value: '${widget.service.processingDays} दिवस',
                    color: AppTheme.warning,
                  ),
                ),
                Container(width: 1, height: 50, color: AppTheme.dividerLight),
                Expanded(
                  child: _DetailItem(
                    icon: Icons.pending_actions_rounded,
                    labelMr: 'स्थिती',
                    labelEn: 'Status',
                    value: 'प्रलंबित',
                    color: AppTheme.statusPending,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
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
              'अर्जाची स्थिती / Application Status',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _StatusStep(
              icon: Icons.check_circle_rounded,
              labelMr: 'अर्ज सादर',
              labelEn: 'Submitted',
              isActive: true,
              isCompleted: true,
            ),
            _StatusStep(
              icon: Icons.hourglass_top_rounded,
              labelMr: 'कागदपत्रे तपासणी',
              labelEn: 'Document Verification',
              isActive: false,
              isCompleted: false,
            ),
            _StatusStep(
              icon: Icons.approval_rounded,
              labelMr: 'मंजुरी प्रक्रिया',
              labelEn: 'Approval Process',
              isActive: false,
              isCompleted: false,
            ),
            _StatusStep(
              icon: Icons.task_alt_rounded,
              labelMr: 'पूर्ण',
              labelEn: 'Completed',
              isActive: false,
              isCompleted: false,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.secondaryContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.secondary.withAlpha(51)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppTheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'पुढील पायऱ्या / Next Steps',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• तुमच्या नोंदणीकृत मोबाइलवर SMS येईल\n• ${widget.service.processingDays} दिवसांत प्रक्रिया पूर्ण होईल\n• Track Request वापरून स्थिती तपासा',
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppTheme.onSecondaryContainer,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'विनंती क्रमांक: ${widget.requestId} — ट्रॅकिंग लवकरच उपलब्ध होईल',
                      style: GoogleFonts.notoSans(fontSize: 13),
                    ),
                    backgroundColor: AppTheme.primary,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.track_changes_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'विनंती ट्रॅक करा / Track Request',
                    style: GoogleFonts.notoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
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
            height: 44,
            child: TextButton(
              onPressed: () => context.go('/home-screen'),
              child: Text(
                'मुख्यपृष्ठावर जा / Go to Home',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String labelMr;
  final String labelEn;
  final String value;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$labelMr / $labelEn',
            style: GoogleFonts.notoSans(
              fontSize: 10,
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final IconData icon;
  final String labelMr;
  final String labelEn;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;

  const _StatusStep({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    required this.isActive,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCompleted
        ? AppTheme.success
        : isActive
        ? AppTheme.primary
        : AppTheme.textTertiary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppTheme.successContainer
                    : isActive
                    ? AppTheme.primaryContainer
                    : AppTheme.surfaceVariantLight,
                border: Border.all(color: color, width: 1.5),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: isCompleted
                    ? AppTheme.success.withAlpha(51)
                    : AppTheme.outlineLight,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelMr,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: isActive || isCompleted
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: isActive || isCompleted
                      ? AppTheme.textPrimary
                      : AppTheme.textTertiary,
                ),
              ),
              Text(
                labelEn,
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
              SizedBox(height: isLast ? 0 : 12),
            ],
          ),
        ),
      ],
    );
  }
}
