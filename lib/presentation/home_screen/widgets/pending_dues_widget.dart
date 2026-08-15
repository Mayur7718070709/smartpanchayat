import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class PendingDuesWidget extends StatelessWidget {
  final double amount;
  final int pendingComplaints;
  final int activeApplications;

  const PendingDuesWidget({
    required this.amount,
    required this.pendingComplaints,
    required this.activeApplications,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariantLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              icon: Icons.payments_rounded,
              iconColor: AppTheme.accent,
              bgColor: AppTheme.accentContainer,
              value: '₹${amount.toStringAsFixed(0)}',
              labelMr: 'थकबाकी',
              labelEn: 'Dues',
              isAlert: amount > 0,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _StatChip(
              icon: Icons.report_problem_rounded,
              iconColor: AppTheme.statusPending,
              bgColor: AppTheme.statusPending.withAlpha(26),
              value: '$pendingComplaints',
              labelMr: 'तक्रारी',
              labelEn: 'Complaints',
              isAlert: pendingComplaints > 0,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _StatChip(
              icon: Icons.assignment_turned_in_rounded,
              iconColor: AppTheme.primary,
              bgColor: AppTheme.primaryContainer,
              value: '$activeApplications',
              labelMr: 'अर्ज',
              labelEn: 'Applications',
              isAlert: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 48,
      color: AppTheme.outlineVariantLight,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String value;
  final String labelMr;
  final String labelEn;
  final bool isAlert;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.labelMr,
    required this.labelEn,
    required this.isAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isAlert ? iconColor : const Color(0xFF212121),
          ),
        ),
        Text(
          labelMr,
          style: GoogleFonts.notoSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        Text(
          labelEn,
          style: GoogleFonts.notoSans(
            fontSize: 10,
            color: const Color(0xFF757575),
          ),
        ),
      ],
    );
  }
}
