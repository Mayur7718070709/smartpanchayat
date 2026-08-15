// ============================================================
// Smart Panchayat Design System — Status Badge
// Accessibility: Always uses icon + text, never color-only
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum DSBadgeStatus {
  pending,
  inProgress,
  resolved,
  rejected,
  active,
  inactive,
  newItem,
  urgent,
  approved,
  expired,
}

class DSStatusBadge extends StatelessWidget {
  final DSBadgeStatus? status;
  final String? customLabel;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool showIcon;

  const DSStatusBadge({
    this.status,
    this.customLabel,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.showIcon = true,
    super.key,
  });

  /// Named constructor for custom badge
  const DSStatusBadge.custom({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    bool showIcon = false,
    super.key,
  }) : status = null,
       customLabel = label,
       backgroundColor = backgroundColor,
       textColor = textColor,
       icon = icon,
       showIcon = showIcon;

  @override
  Widget build(BuildContext context) {
    final config = status != null ? _getConfig(status!) : null;
    final bgColor =
        backgroundColor ?? config?.bgColor ?? AppTheme.surfaceVariantLight;
    final fgColor = textColor ?? config?.textColor ?? AppTheme.textSecondary;
    final label = customLabel ?? config?.label ?? '';
    final badgeIcon = icon ?? config?.icon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && badgeIcon != null) ...[
            Icon(badgeIcon, size: 12, color: fgColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fgColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
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

_BadgeConfig _getConfig(DSBadgeStatus status) {
  switch (status) {
    case DSBadgeStatus.pending:
      return const _BadgeConfig(
        label: 'प्रलंबित',
        bgColor: AppTheme.warningContainer,
        textColor: AppTheme.statusPending,
        icon: Icons.hourglass_empty_rounded,
      );
    case DSBadgeStatus.inProgress:
      return const _BadgeConfig(
        label: 'प्रक्रियेत',
        bgColor: AppTheme.primaryContainer,
        textColor: AppTheme.statusInProgress,
        icon: Icons.sync_rounded,
      );
    case DSBadgeStatus.resolved:
      return const _BadgeConfig(
        label: 'निराकरण',
        bgColor: AppTheme.successContainer,
        textColor: AppTheme.statusResolved,
        icon: Icons.check_circle_outline_rounded,
      );
    case DSBadgeStatus.rejected:
      return const _BadgeConfig(
        label: 'नाकारले',
        bgColor: AppTheme.errorContainer,
        textColor: AppTheme.statusRejected,
        icon: Icons.cancel_outlined,
      );
    case DSBadgeStatus.active:
      return const _BadgeConfig(
        label: 'सक्रिय',
        bgColor: AppTheme.successContainer,
        textColor: AppTheme.statusActive,
        icon: Icons.radio_button_checked_rounded,
      );
    case DSBadgeStatus.inactive:
      return const _BadgeConfig(
        label: 'निष्क्रिय',
        bgColor: Color(0xFFF1F5F9),
        textColor: AppTheme.statusInactive,
        icon: Icons.radio_button_unchecked_rounded,
      );
    case DSBadgeStatus.newItem:
      return const _BadgeConfig(
        label: 'नवीन',
        bgColor: AppTheme.primaryContainer,
        textColor: AppTheme.primary,
        icon: Icons.fiber_new_rounded,
      );
    case DSBadgeStatus.urgent:
      return const _BadgeConfig(
        label: 'तातडीचे',
        bgColor: AppTheme.errorContainer,
        textColor: AppTheme.error,
        icon: Icons.priority_high_rounded,
      );
    case DSBadgeStatus.approved:
      return const _BadgeConfig(
        label: 'मंजूर',
        bgColor: AppTheme.successContainer,
        textColor: AppTheme.success,
        icon: Icons.verified_outlined,
      );
    case DSBadgeStatus.expired:
      return const _BadgeConfig(
        label: 'कालबाह्य',
        bgColor: Color(0xFFF1F5F9),
        textColor: AppTheme.statusInactive,
        icon: Icons.event_busy_outlined,
      );
  }
}
