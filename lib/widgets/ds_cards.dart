import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import './ds_status_badge.dart';

// ============================================================
// Smart Panchayat Design System — Card Components
// ============================================================

// ──────────────────────────────────────────────────────────
// BASE CARD
// ──────────────────────────────────────────────────────────
class DSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? borderRadius;
  final bool hasBorder;
  final bool hasShadow;

  const DSCard({
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.hasBorder = true,
    this.hasShadow = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppTheme.radiusMD;
    final bg = backgroundColor ?? AppTheme.surfaceLight;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppTheme.spacingLG),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: hasBorder
                ? Border.all(color: AppTheme.outlineVariantLight, width: 1)
                : null,
            boxShadow: hasShadow ? AppTheme.shadowMD : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// SERVICE CARD
// ──────────────────────────────────────────────────────────
class DSServiceCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBgColor;
  final VoidCallback? onTap;
  final String? badgeText;
  final bool isAvailable;

  const DSServiceCard({
    required this.title,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.iconBgColor,
    this.onTap,
    this.badgeText,
    this.isAvailable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final iColor = iconColor ?? AppTheme.primary;
    final iBgColor = iconBgColor ?? AppTheme.primaryContainer;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5,
      child: Material(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        child: InkWell(
          onTap: isAvailable ? onTap : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingLG),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(color: AppTheme.outlineVariantLight, width: 1),
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
                        color: iBgColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      ),
                      child: Icon(icon, color: iColor, size: 24),
                    ),
                    if (badgeText != null) ...[
                      const Spacer(),
                      DSStatusBadge.custom(
                        label: badgeText!,
                        backgroundColor: AppTheme.accentContainer,
                        textColor: AppTheme.accentDark,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMD),
                Text(
                  title,
                  style: AppTheme.sectionHeadingSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    subtitle!,
                    style: AppTheme.captionLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// NOTICE CARD
// ──────────────────────────────────────────────────────────
class DSNoticeCard extends StatelessWidget {
  final String title;
  final String? description;
  final String date;
  final DSNoticeType type;
  final VoidCallback? onTap;
  final bool isNew;

  const DSNoticeCard({
    required this.title,
    required this.date,
    required this.type,
    this.description,
    this.onTap,
    this.isNew = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getNoticeConfig(type);

    return Material(
      color: AppTheme.surfaceLight,
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLG),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(color: AppTheme.outlineVariantLight, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: config.bgColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Icon(config.icon, color: config.iconColor, size: 22),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTheme.sectionHeadingSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isNew) ...[
                          const SizedBox(width: 8),
                          DSStatusBadge.custom(
                            label: 'नवीन',
                            backgroundColor: AppTheme.primaryContainer,
                            textColor: AppTheme.primary,
                          ),
                        ],
                      ],
                    ),
                    if (description != null) ...[
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        description!,
                        style: AppTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppTheme.spacingSM),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(date, style: AppTheme.captionMedium),
                        const Spacer(),
                        DSStatusBadge.custom(
                          label: config.label,
                          backgroundColor: config.bgColor,
                          textColor: config.iconColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DSNoticeType { general, urgent, tender, meeting, holiday }

class _NoticeConfig {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  const _NoticeConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
  });
}

_NoticeConfig _getNoticeConfig(DSNoticeType type) {
  switch (type) {
    case DSNoticeType.urgent:
      return const _NoticeConfig(
        icon: Icons.priority_high_rounded,
        iconColor: AppTheme.error,
        bgColor: AppTheme.errorContainer,
        label: 'तातडीचे',
      );
    case DSNoticeType.tender:
      return const _NoticeConfig(
        icon: Icons.description_outlined,
        iconColor: AppTheme.info,
        bgColor: AppTheme.infoContainer,
        label: 'निविदा',
      );
    case DSNoticeType.meeting:
      return const _NoticeConfig(
        icon: Icons.groups_outlined,
        iconColor: AppTheme.secondary,
        bgColor: AppTheme.secondaryContainer,
        label: 'सभा',
      );
    case DSNoticeType.holiday:
      return const _NoticeConfig(
        icon: Icons.celebration_outlined,
        iconColor: AppTheme.accent,
        bgColor: AppTheme.accentContainer,
        label: 'सुट्टी',
      );
    case DSNoticeType.general:
    default:
      return const _NoticeConfig(
        icon: Icons.info_outline_rounded,
        iconColor: AppTheme.primary,
        bgColor: AppTheme.primaryContainer,
        label: 'सामान्य',
      );
  }
}

// ──────────────────────────────────────────────────────────
// SCHEME CARD
// ──────────────────────────────────────────────────────────
class DSSchemeCard extends StatelessWidget {
  final String title;
  final String description;
  final String? eligibility;
  final String? deadline;
  final Color? accentColor;
  final VoidCallback? onApply;
  final VoidCallback? onLearnMore;

  const DSSchemeCard({
    required this.title,
    required this.description,
    this.eligibility,
    this.deadline,
    this.accentColor,
    this.onApply,
    this.onLearnMore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppTheme.secondary;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.outlineVariantLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header strip
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusMD),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withAlpha(26),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusFull,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_outlined,
                            size: 12,
                            color: color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'सरकारी योजना',
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (deadline != null) ...[
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 12,
                            color: AppTheme.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            deadline!,
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.warning,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMD),
                Text(
                  title,
                  style: AppTheme.sectionHeadingLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  description,
                  style: AppTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (eligibility != null) ...[
                  const SizedBox(height: AppTheme.spacingMD),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMD),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'पात्रता: $eligibility',
                            style: AppTheme.captionLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppTheme.spacingLG),
                Row(
                  children: [
                    if (onLearnMore != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onLearnMore,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: color,
                            side: BorderSide(color: color, width: 1.5),
                            minimumSize: const Size(0, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusSM,
                              ),
                            ),
                          ),
                          child: Text(
                            'अधिक माहिती',
                            style: GoogleFonts.notoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (onLearnMore != null && onApply != null)
                      const SizedBox(width: AppTheme.spacingSM),
                    if (onApply != null)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onApply,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 44),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusSM,
                              ),
                            ),
                          ),
                          child: Text(
                            'अर्ज करा',
                            style: GoogleFonts.notoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// COMPLAINT CARD
// ──────────────────────────────────────────────────────────
class DSComplaintCard extends StatelessWidget {
  final String complaintId;
  final String title;
  final String category;
  final String date;
  final DSComplaintStatus status;
  final String? lastUpdate;
  final VoidCallback? onTap;

  const DSComplaintCard({
    required this.complaintId,
    required this.title,
    required this.category,
    required this.date,
    required this.status,
    this.lastUpdate,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getComplaintConfig(status);

    return Material(
      color: AppTheme.surfaceLight,
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLG),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(color: AppTheme.outlineVariantLight, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#$complaintId',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  // Status badge with icon (not color-only)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
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
                          config.label,
                          style: GoogleFonts.notoSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: config.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSM),
              Text(
                title,
                style: AppTheme.sectionHeadingSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(category, style: AppTheme.captionLarge),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(date, style: AppTheme.captionMedium),
                ],
              ),
              if (lastUpdate != null) ...[
                const SizedBox(height: AppTheme.spacingSM),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSM),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.update_rounded,
                        size: 12,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lastUpdate!,
                          style: AppTheme.captionLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum DSComplaintStatus { pending, inProgress, resolved, rejected }

class _ComplaintConfig {
  final IconData icon;
  final Color textColor;
  final Color bgColor;
  final String label;
  const _ComplaintConfig({
    required this.icon,
    required this.textColor,
    required this.bgColor,
    required this.label,
  });
}

_ComplaintConfig _getComplaintConfig(DSComplaintStatus status) {
  switch (status) {
    case DSComplaintStatus.pending:
      return const _ComplaintConfig(
        icon: Icons.hourglass_empty_rounded,
        textColor: AppTheme.statusPending,
        bgColor: AppTheme.warningContainer,
        label: 'प्रलंबित',
      );
    case DSComplaintStatus.inProgress:
      return const _ComplaintConfig(
        icon: Icons.sync_rounded,
        textColor: AppTheme.statusInProgress,
        bgColor: AppTheme.primaryContainer,
        label: 'प्रक्रियेत',
      );
    case DSComplaintStatus.resolved:
      return const _ComplaintConfig(
        icon: Icons.check_circle_outline_rounded,
        textColor: AppTheme.statusResolved,
        bgColor: AppTheme.successContainer,
        label: 'निराकरण',
      );
    case DSComplaintStatus.rejected:
      return const _ComplaintConfig(
        icon: Icons.cancel_outlined,
        textColor: AppTheme.statusRejected,
        bgColor: AppTheme.errorContainer,
        label: 'नाकारले',
      );
  }
}
