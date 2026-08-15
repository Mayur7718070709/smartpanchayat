// ============================================================
// Smart Panchayat Design System — Button Components
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ──────────────────────────────────────────────────────────
// PRIMARY BUTTON
// ──────────────────────────────────────────────────────────
class DSPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final DSButtonSize size;

  const DSPrimaryButton({
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = DSButtonSize.large,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = _heightForSize(size);
    final fontSize = _fontSizeForSize(size);
    final hPad = _hPadForSize(size);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: AppTheme.onPrimary,
          disabledBackgroundColor: AppTheme.outlineVariantLight,
          disabledForegroundColor: AppTheme.textTertiary,
          minimumSize: Size(0, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.onPrimary,
                ),
              )
            : Row(
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: fontSize + 4),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.notoSans(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(trailingIcon, size: fontSize + 4),
                  ],
                ],
              ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// SECONDARY BUTTON (Green)
// ──────────────────────────────────────────────────────────
class DSSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final DSButtonSize size;

  const DSSecondaryButton({
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = DSButtonSize.large,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = _heightForSize(size);
    final fontSize = _fontSizeForSize(size);
    final hPad = _hPadForSize(size);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondary,
          foregroundColor: AppTheme.onSecondary,
          disabledBackgroundColor: AppTheme.outlineVariantLight,
          disabledForegroundColor: AppTheme.textTertiary,
          minimumSize: Size(0, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.onSecondary,
                ),
              )
            : Row(
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: fontSize + 4),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.notoSans(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// OUTLINED BUTTON
// ──────────────────────────────────────────────────────────
class DSOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final DSButtonSize size;
  final Color? borderColor;
  final Color? textColor;

  const DSOutlinedButton({
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = DSButtonSize.large,
    this.borderColor,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = _heightForSize(size);
    final fontSize = _fontSizeForSize(size);
    final hPad = _hPadForSize(size);
    final fgColor = textColor ?? AppTheme.primary;
    final bdColor = borderColor ?? AppTheme.primary;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: fgColor,
          disabledForegroundColor: AppTheme.textTertiary,
          minimumSize: Size(0, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
          side: BorderSide(color: bdColor, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: fgColor,
                ),
              )
            : Row(
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: fontSize + 4),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.notoSans(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// TEXT BUTTON
// ──────────────────────────────────────────────────────────
class DSTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final Color? color;
  final DSButtonSize size;

  const DSTextButton({
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.color,
    this.size = DSButtonSize.medium,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = _fontSizeForSize(size);
    final fgColor = color ?? AppTheme.primary;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: fgColor,
        minimumSize: const Size(0, AppTheme.minTouchTarget),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: fontSize + 2),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// ICON BUTTON (Accessible)
// ──────────────────────────────────────────────────────────
class DSIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double size;

  const DSIconButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 24,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        child: Container(
          width: AppTheme.minTouchTarget,
          height: AppTheme.minTouchTarget,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: size, color: color ?? AppTheme.textPrimary),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// ACCENT BUTTON (Saffron — for important actions)
// ──────────────────────────────────────────────────────────
class DSAccentButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool isFullWidth;

  const DSAccentButton({
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: AppTheme.buttonHeightMedium,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accent,
          foregroundColor: AppTheme.onAccent,
          minimumSize: const Size(0, AppTheme.buttonHeightMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.onAccent,
                ),
              )
            : Row(
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// HELPERS
// ──────────────────────────────────────────────────────────
enum DSButtonSize { small, medium, large }

double _heightForSize(DSButtonSize size) {
  switch (size) {
    case DSButtonSize.small:
      return AppTheme.buttonHeightSmall;
    case DSButtonSize.medium:
      return AppTheme.buttonHeightMedium;
    case DSButtonSize.large:
      return AppTheme.buttonHeightLarge;
  }
}

double _fontSizeForSize(DSButtonSize size) {
  switch (size) {
    case DSButtonSize.small:
      return 12;
    case DSButtonSize.medium:
      return 14;
    case DSButtonSize.large:
      return 16;
  }
}

double _hPadForSize(DSButtonSize size) {
  switch (size) {
    case DSButtonSize.small:
      return 16;
    case DSButtonSize.medium:
      return 20;
    case DSButtonSize.large:
      return 24;
  }
}
