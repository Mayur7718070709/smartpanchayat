import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// Keep backward-compatible BadgeStatus enum for existing code
enum BadgeStatus { pending, inProgress, resolved, active, inactive }

class StatusBadgeWidget extends StatelessWidget {
  final BadgeStatus status;
  final String? customLabel;

  const StatusBadgeWidget({required this.status, this.customLabel, super.key});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 12, color: config.textColor),
          const SizedBox(width: 4),
          Text(
            customLabel ?? config.label,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: config.textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getConfig(BadgeStatus status) {
    switch (status) {
      case BadgeStatus.pending:
        return const _BadgeConfig(
          label: 'प्रलंबित',
          bgColor: AppTheme.warningContainer,
          textColor: AppTheme.statusPending,
          icon: Icons.hourglass_empty_rounded,
        );
      case BadgeStatus.inProgress:
        return const _BadgeConfig(
          label: 'प्रक्रियेत',
          bgColor: AppTheme.primaryContainer,
          textColor: AppTheme.statusInProgress,
          icon: Icons.sync_rounded,
        );
      case BadgeStatus.resolved:
        return const _BadgeConfig(
          label: 'निराकरण',
          bgColor: AppTheme.successContainer,
          textColor: AppTheme.statusResolved,
          icon: Icons.check_circle_outline_rounded,
        );
      case BadgeStatus.active:
        return const _BadgeConfig(
          label: 'सक्रिय',
          bgColor: AppTheme.successContainer,
          textColor: AppTheme.statusActive,
          icon: Icons.radio_button_checked_rounded,
        );
      case BadgeStatus.inactive:
        return const _BadgeConfig(
          label: 'निष्क्रिय',
          bgColor: Color(0xFFF1F5F9),
          textColor: AppTheme.statusInactive,
          icon: Icons.radio_button_unchecked_rounded,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  const _BadgeConfig({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.icon,
  });
}
