// ============================================================
// Smart Panchayat Design System — Dialogs, Sheets & Snackbars
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ──────────────────────────────────────────────────────────
// CONFIRMATION DIALOG
// ──────────────────────────────────────────────────────────
class DSConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final DSDialogType type;
  final IconData? icon;

  const DSConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'रद्द करा',
    this.onCancel,
    this.type = DSDialogType.warning,
    this.icon,
    super.key,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'रद्द करा',
    DSDialogType type = DSDialogType.warning,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DSConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        type: type,
        icon: icon,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _getDialogConfig(type);
    final dialogIcon = icon ?? config.icon;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: config.bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(dialogIcon, size: 36, color: config.iconColor),
            ),
            const SizedBox(height: AppTheme.spacingXL),
            Text(
              title,
              style: AppTheme.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingSM),
            Text(
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXXL),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        onCancel ?? () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      side: const BorderSide(color: AppTheme.outlineLight),
                      minimumSize: const Size(0, AppTheme.buttonHeightMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      ),
                    ),
                    child: Text(
                      cancelLabel,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.actionColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, AppTheme.buttonHeightMedium),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      ),
                    ),
                    child: Text(
                      confirmLabel,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
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
    );
  }
}

enum DSDialogType { info, warning, error, success }

class _DialogConfig {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color actionColor;
  const _DialogConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.actionColor,
  });
}

_DialogConfig _getDialogConfig(DSDialogType type) {
  switch (type) {
    case DSDialogType.info:
      return const _DialogConfig(
        icon: Icons.info_outline_rounded,
        iconColor: AppTheme.primary,
        bgColor: AppTheme.primaryContainer,
        actionColor: AppTheme.primary,
      );
    case DSDialogType.warning:
      return const _DialogConfig(
        icon: Icons.warning_amber_rounded,
        iconColor: AppTheme.warning,
        bgColor: AppTheme.warningContainer,
        actionColor: AppTheme.warning,
      );
    case DSDialogType.error:
      return const _DialogConfig(
        icon: Icons.error_outline_rounded,
        iconColor: AppTheme.error,
        bgColor: AppTheme.errorContainer,
        actionColor: AppTheme.error,
      );
    case DSDialogType.success:
      return const _DialogConfig(
        icon: Icons.check_circle_outline_rounded,
        iconColor: AppTheme.success,
        bgColor: AppTheme.successContainer,
        actionColor: AppTheme.success,
      );
  }
}

// ──────────────────────────────────────────────────────────
// BOTTOM SHEET WRAPPER
// ──────────────────────────────────────────────────────────
class DSBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final bool showDragHandle;
  final EdgeInsetsGeometry? padding;

  const DSBottomSheet({
    required this.child,
    this.title,
    this.subtitle,
    this.showDragHandle = true,
    this.padding,
    super.key,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? subtitle,
    bool isDismissible = true,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          DSBottomSheet(title: title, subtitle: subtitle, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) ...[
            const SizedBox(height: AppTheme.spacingMD),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.outlineLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
            ),
          ],
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingXXL,
                AppTheme.spacingXL,
                AppTheme.spacingXXL,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title!, style: AppTheme.headingSmall),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(
                            AppTheme.minTouchTarget,
                            AppTheme.minTouchTarget,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(subtitle!, style: AppTheme.bodySmall),
                  ],
                  const SizedBox(height: AppTheme.spacingLG),
                  const Divider(height: 1),
                ],
              ),
            ),
          ],
          Padding(
            padding:
                padding ??
                EdgeInsets.fromLTRB(
                  AppTheme.spacingXXL,
                  AppTheme.spacingXL,
                  AppTheme.spacingXXL,
                  AppTheme.spacingXXL +
                      MediaQuery.of(context).viewInsets.bottom,
                ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// SNACKBAR HELPER
// ──────────────────────────────────────────────────────────
class DSSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    DSSnackbarType type = DSSnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final config = _getSnackbarConfig(type);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(config.icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        ),
        duration: duration,
        margin: const EdgeInsets.all(AppTheme.spacingLG),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }
}

enum DSSnackbarType { info, success, warning, error }

class _SnackbarConfig {
  final IconData icon;
  final Color bgColor;
  const _SnackbarConfig({required this.icon, required this.bgColor});
}

_SnackbarConfig _getSnackbarConfig(DSSnackbarType type) {
  switch (type) {
    case DSSnackbarType.success:
      return const _SnackbarConfig(
        icon: Icons.check_circle_outline_rounded,
        bgColor: AppTheme.success,
      );
    case DSSnackbarType.warning:
      return const _SnackbarConfig(
        icon: Icons.warning_amber_rounded,
        bgColor: AppTheme.warning,
      );
    case DSSnackbarType.error:
      return const _SnackbarConfig(
        icon: Icons.error_outline_rounded,
        bgColor: AppTheme.error,
      );
    case DSSnackbarType.info:
    default:
      return const _SnackbarConfig(
        icon: Icons.info_outline_rounded,
        bgColor: Color(0xFF1E293B),
      );
  }
}
