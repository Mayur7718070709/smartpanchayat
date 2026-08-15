import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/payment_model.dart';
import '../../theme/app_theme.dart';
import './payment_history_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String transactionId;
  final double amount;
  final DateTime date;
  final PaymentService service;
  final String receiptNumber;

  const PaymentSuccessScreen({
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.service,
    required this.receiptNumber,
    super.key,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
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
    final h = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;
    final m = date.minute.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day} ${months[date.month - 1]} ${date.year}, $h:$m $ampm';
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
                      const SizedBox(height: 24),
                      _buildSuccessIcon(),
                      const SizedBox(height: 24),
                      _buildSuccessTitle(),
                      const SizedBox(height: 28),
                      _buildTransactionCard(),
                      const SizedBox(height: 20),
                      _buildReceiptCard(),
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

  Widget _buildSuccessIcon() {
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
              color: AppTheme.successContainer,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.success.withAlpha(51),
                  blurRadius: 28,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            size: 72,
            color: AppTheme.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessTitle() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          Text(
            'पेमेंट यशस्वी!',
            style: GoogleFonts.notoSans(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Payment Successful',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.successContainer,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '₹${widget.amount.toStringAsFixed(2)}',
              style: GoogleFonts.notoSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'व्यवहार तपशील / Transaction Details',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.tag_rounded,
              labelMr: 'व्यवहार क्रमांक',
              labelEn: 'Transaction ID',
              value: widget.transactionId,
              canCopy: true,
            ),
            const Divider(height: 20, color: AppTheme.dividerLight),
            _buildInfoRow(
              icon: Icons.currency_rupee_rounded,
              labelMr: 'रक्कम',
              labelEn: 'Amount',
              value: '₹${widget.amount.toStringAsFixed(2)}',
            ),
            const Divider(height: 20, color: AppTheme.dividerLight),
            _buildInfoRow(
              icon: Icons.calendar_today_rounded,
              labelMr: 'तारीख व वेळ',
              labelEn: 'Date & Time',
              value: _formatDate(widget.date),
            ),
            const Divider(height: 20, color: AppTheme.dividerLight),
            _buildInfoRow(
              icon: widget.service.icon,
              labelMr: 'सेवा',
              labelEn: 'Service',
              value: '${widget.service.labelMr} / ${widget.service.labelEn}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptCard() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withAlpha(51)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 24,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'पावती क्रमांक / Receipt Number',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.receiptNumber,
                    style: GoogleFonts.notoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.receiptNumber));
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Receipt number copied',
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
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String labelMr,
    required String labelEn,
    required String value,
    bool canCopy = false,
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
        if (canCopy)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              HapticFeedback.lightImpact();
            },
            child: const Icon(
              Icons.copy_rounded,
              size: 16,
              color: AppTheme.primary,
            ),
          ),
      ],
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement view receipt (open PDF/receipt detail)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'पावती पाहणे / View Receipt — Coming soon',
                          style: GoogleFonts.notoSans(fontSize: 13),
                        ),
                        backgroundColor: AppTheme.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: Text(
                    'View Receipt',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement download receipt (generate PDF)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'पावती डाउनलोड / Download Receipt — Coming soon',
                          style: GoogleFonts.notoSans(fontSize: 13),
                        ),
                        backgroundColor: AppTheme.success,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: Text(
                    'Download Receipt',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const PaymentHistoryScreen()),
                (route) => route.isFirst,
              );
            },
            child: Text(
              'पेमेंट इतिहास पाहा / View Payment History',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
