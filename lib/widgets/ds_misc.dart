// ============================================================
// Smart Panchayat Design System — Misc Components
// App Bar, File Upload, Rating, Info Tile
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ──────────────────────────────────────────────────────────
// SMART PANCHAYAT APP BAR
// ──────────────────────────────────────────────────────────
class DSAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final Color? backgroundColor;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const DSAppBar({
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.backgroundColor,
    this.centerTitle = false,
    this.bottom,
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    bottom != null
        ? kToolbarHeight + bottom!.preferredSize.height
        : kToolbarHeight,
  );

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      backgroundColor: backgroundColor ?? AppTheme.surfaceLight,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: const Color(0x1A000000),
      centerTitle: centerTitle,
      leading:
          leading ??
          (showBackButton && canPop
              ? IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  tooltip: 'मागे जा',
                  style: IconButton.styleFrom(
                    minimumSize: const Size(
                      AppTheme.minTouchTarget,
                      AppTheme.minTouchTarget,
                    ),
                  ),
                )
              : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
        ],
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}

// ──────────────────────────────────────────────────────────
// FILE UPLOAD COMPONENT
// ──────────────────────────────────────────────────────────
class DSFileUpload extends StatelessWidget {
  final String label;
  final String hint;
  final List<DSUploadedFile> files;
  final VoidCallback onPickFile;
  final ValueChanged<int>? onRemoveFile;
  final int maxFiles;
  final List<String> allowedExtensions;
  final bool isLoading;

  const DSFileUpload({
    required this.label,
    required this.hint,
    required this.files,
    required this.onPickFile,
    this.onRemoveFile,
    this.maxFiles = 5,
    this.allowedExtensions = const ['pdf', 'jpg', 'png', 'jpeg'],
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final canAddMore = files.length < maxFiles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelLarge),
        const SizedBox(height: AppTheme.spacingXS),
        // Upload zone
        if (canAddMore)
          GestureDetector(
            onTap: isLoading ? null : onPickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.spacingXXL,
                horizontal: AppTheme.spacingLG,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withAlpha(77),
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(
                  color: AppTheme.primary.withAlpha(102),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  isLoading
                      ? const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppTheme.primary,
                          ),
                        )
                      : const Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: AppTheme.primary,
                        ),
                  const SizedBox(height: AppTheme.spacingSM),
                  Text(
                    hint,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    allowedExtensions.map((e) => e.toUpperCase()).join(', '),
                    style: AppTheme.captionLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        // Uploaded files list
        if (files.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingMD),
          ...List.generate(files.length, (index) {
            final file = files[index];
            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacingSM),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMD,
                vertical: AppTheme.spacingMD,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                border: Border.all(color: AppTheme.outlineVariantLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getFileColor(file.extension).withAlpha(26),
                      borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                    ),
                    child: Icon(
                      _getFileIcon(file.extension),
                      size: 20,
                      color: _getFileColor(file.extension),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          style: AppTheme.sectionHeadingSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (file.size != null)
                          Text(file.size!, style: AppTheme.captionMedium),
                      ],
                    ),
                  ),
                  if (onRemoveFile != null)
                    IconButton(
                      onPressed: () => onRemoveFile!(index),
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(
                          AppTheme.minTouchTarget,
                          AppTheme.minTouchTarget,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  IconData _getFileIcon(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      default:
        return Icons.attach_file_rounded;
    }
  }

  Color _getFileColor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return AppTheme.error;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return AppTheme.secondary;
      case 'doc':
      case 'docx':
        return AppTheme.primary;
      default:
        return AppTheme.textSecondary;
    }
  }
}

class DSUploadedFile {
  final String name;
  final String extension;
  final String? size;
  final String? path;

  const DSUploadedFile({
    required this.name,
    required this.extension,
    this.size,
    this.path,
  });
}

// ──────────────────────────────────────────────────────────
// RATING COMPONENT
// ──────────────────────────────────────────────────────────
class DSRating extends StatefulWidget {
  final int initialRating;
  final int maxRating;
  final ValueChanged<int>? onRatingChanged;
  final bool readOnly;
  final double size;
  final String? label;

  const DSRating({
    this.initialRating = 0,
    this.maxRating = 5,
    this.onRatingChanged,
    this.readOnly = false,
    this.size = 36,
    this.label,
    super.key,
  });

  @override
  State<DSRating> createState() => _DSRatingState();
}

class _DSRatingState extends State<DSRating> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTheme.labelLarge),
          const SizedBox(height: AppTheme.spacingSM),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.maxRating, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= _currentRating;
            return GestureDetector(
              onTap: widget.readOnly
                  ? null
                  : () {
                      setState(() => _currentRating = starIndex);
                      widget.onRatingChanged?.call(starIndex);
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: widget.size,
                  color: isFilled
                      ? const Color(0xFFF59E0B)
                      : AppTheme.outlineLight,
                ),
              ),
            );
          }),
        ),
        if (!widget.readOnly && _currentRating > 0) ...[
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            _getRatingLabel(_currentRating),
            style: AppTheme.captionLarge.copyWith(
              color: const Color(0xFFF59E0B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'खूप वाईट';
      case 2:
        return 'वाईट';
      case 3:
        return 'ठीक आहे';
      case 4:
        return 'चांगले';
      case 5:
        return 'उत्कृष्ट';
      default:
        return '';
    }
  }
}

// ──────────────────────────────────────────────────────────
// INFO TILE (Key-Value display)
// ──────────────────────────────────────────────────────────
class DSInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final bool isLast;

  const DSInfoTile({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.isLast = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMD),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: iconColor ?? AppTheme.textSecondary,
                ),
                const SizedBox(width: AppTheme.spacingMD),
              ],
              Expanded(flex: 2, child: Text(label, style: AppTheme.bodySmall)),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  style: AppTheme.sectionHeadingSmall,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppTheme.dividerLight),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────
// SECTION HEADER
// ──────────────────────────────────────────────────────────
class DSSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  const DSSectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTheme.sectionHeadingLarge)),
        if (trailing != null) trailing!,
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              minimumSize: const Size(0, AppTheme.minTouchTarget),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              actionLabel!,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────
// DIVIDER WITH LABEL
// ──────────────────────────────────────────────────────────
class DSDividerWithLabel extends StatelessWidget {
  final String label;

  const DSDividerWithLabel({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.dividerLight)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
          child: Text(label, style: AppTheme.captionLarge),
        ),
        const Expanded(child: Divider(color: AppTheme.dividerLight)),
      ],
    );
  }
}
