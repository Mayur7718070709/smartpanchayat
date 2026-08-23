import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/payment_model.dart';
import '../../theme/app_theme.dart';

class PaymentFailedScreen extends StatefulWidget {
  final double amount;
  final PaymentService service;
  final String requestId;

  const PaymentFailedScreen({
    required this.amount,
    required this.service,
    required this.requestId,
    super.key,
  });

  @override
  State<PaymentFailedScreen> createState() => _PaymentFailedScreenState();
}

class _PaymentFailedScreenState extends State<PaymentFailedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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

  void _showContactSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outlineLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'संपर्क करा / Contact Support',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.phone_rounded,
              label: 'हेल्पलाइन / Helpline',
              value: '1800-XXX-XXXX',
              color: AppTheme.primary,
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.email_rounded,
              label: 'ईमेल / Email',
              value: 'support@panchayat.gov.in',
              color: AppTheme.secondary,
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.access_time_rounded,
              label: 'वेळ / Hours',
              value: 'सोम–शुक्र, सकाळी १० – सायंकाळी ५',
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppTheme.textTertiary,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                      _buildFailedIcon(),
                      const SizedBox(height: 28),
                      _buildFailedTitle(),
                      const SizedBox(height: 28),
                      _buildDetailsCard(),
                      const SizedBox(height: 20),
                      _buildPossibleReasonsCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFailedIcon() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.errorContainer,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.error.withAlpha(51),
                  blurRadius: 28,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.cancel_rounded,
            size: 72,
            color: AppTheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildFailedTitle() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          Text(
            'पेमेंट अयशस्वी',
            style: GoogleFonts.notoSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Payment could not be completed.',
            style: GoogleFonts.notoSans(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'तुमच्या खात्यातून कोणतीही रक्कम कापली गेली नाही.',
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: AppTheme.textTertiary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'No amount has been deducted from your account.',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
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
            _buildDetailRow(
              icon: Icons.confirmation_number_outlined,
              labelMr: 'विनंती क्रमांक',
              labelEn: 'Request ID',
              value: widget.requestId,
            ),
            const Divider(height: 20, color: AppTheme.dividerLight),
            _buildDetailRow(
              icon: widget.service.icon,
              labelMr: 'सेवा',
              labelEn: 'Service',
              value: '${widget.service.labelMr} / ${widget.service.labelEn}',
            ),
            const Divider(height: 20, color: AppTheme.dividerLight),
            _buildDetailRow(
              icon: Icons.currency_rupee_rounded,
              labelMr: 'रक्कम',
              labelEn: 'Amount',
              value: '₹${widget.amount.toStringAsFixed(2)}',
            ),
            const Divider(height: 20, color: AppTheme.dividerLight),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.cancel_rounded,
                    size: 18,
                    color: AppTheme.error,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'स्थिती / Status',
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    Text(
                      'अयशस्वी / Failed',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String labelMr,
    required String labelEn,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$labelMr / $labelEn',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPossibleReasonsCard() {
    final reasons = [
      ('नेटवर्क समस्या', 'Network issue or timeout'),
      ('अपुरी शिल्लक', 'Insufficient balance'),
      ('बँक सर्व्हर समस्या', 'Bank server error'),
      ('चुकीची माहिती', 'Incorrect payment details'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.warningContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warning.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline_rounded, size: 18, color: AppTheme.warning),
              const SizedBox(width: 8),
              Text(
                'संभाव्य कारणे / Possible Reasons',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...reasons.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 6, color: AppTheme.warning),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${r.$1} — ${r.$2}',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppTheme.onWarningContainer,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.replay_rounded, size: 20),
              label: Text(
                'Try Again',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => _showContactSupport(context),
              icon: const Icon(Icons.support_agent_rounded, size: 20),
              label: Text(
                'Contact Support',
                style: GoogleFonts.notoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: const BorderSide(color: AppTheme.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
