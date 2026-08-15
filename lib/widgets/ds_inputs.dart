// ============================================================
// Smart Panchayat Design System — Input Components
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ──────────────────────────────────────────────────────────
// TEXT FIELD
// ──────────────────────────────────────────────────────────
class DSTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const DSTextField({
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.validator,
    this.textInputAction,
    this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelLarge),
        const SizedBox(height: AppTheme.spacingXS),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onTap: onTap,
          validator: validator,
          textInputAction: textInputAction,
          focusNode: focusNode,
          style: GoogleFonts.notoSans(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helperText,
            helperStyle: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: AppTheme.textSecondary)
                : null,
            suffix: suffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            filled: true,
            fillColor: enabled
                ? AppTheme.surfaceLight
                : AppTheme.surfaceVariantLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.outlineLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.outlineLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.outlineVariantLight),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────
// DROPDOWN FIELD
// ──────────────────────────────────────────────────────────
class DSDropdownField<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<DSDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? errorText;
  final bool enabled;
  final IconData? prefixIcon;

  const DSDropdownField({
    required this.label,
    required this.items,
    this.hint,
    this.value,
    this.onChanged,
    this.errorText,
    this.enabled = true,
    this.prefixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelLarge),
        const SizedBox(height: AppTheme.spacingXS),
        DropdownButtonFormField<T>(
          initialValue: value,
          onChanged: enabled ? onChanged : null,
          style: GoogleFonts.notoSans(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppTheme.textPrimary,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppTheme.textSecondary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: AppTheme.textSecondary)
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            filled: true,
            fillColor: enabled
                ? AppTheme.surfaceLight
                : AppTheme.surfaceVariantLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.outlineLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.outlineLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              borderSide: const BorderSide(color: AppTheme.error),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item.value,
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        Icon(
                          item.icon,
                          size: 18,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        item.label,
                        style: GoogleFonts.notoSans(
                          fontSize: 15,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class DSDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const DSDropdownItem({required this.value, required this.label, this.icon});
}

// ──────────────────────────────────────────────────────────
// SEARCH BAR
// ──────────────────────────────────────────────────────────
class DSSearchBar extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool autofocus;

  const DSSearchBar({
    required this.hint,
    this.onChanged,
    this.onClear,
    this.controller,
    this.autofocus = false,
    super.key,
  });

  @override
  State<DSSearchBar> createState() => _DSSearchBarState();
}

class _DSSearchBarState extends State<DSSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.minTouchTarget + 4,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(color: AppTheme.outlineLight),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search_rounded,
            color: AppTheme.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              onChanged: widget.onChanged,
              style: GoogleFonts.notoSans(
                fontSize: 15,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.notoSans(
                  fontSize: 15,
                  color: AppTheme.textTertiary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (_hasText)
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onChanged?.call('');
                widget.onClear?.call();
              },
              child: Container(
                width: AppTheme.minTouchTarget,
                height: AppTheme.minTouchTarget,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.close_rounded,
                  color: AppTheme.textSecondary,
                  size: 18,
                ),
              ),
            )
          else
            const SizedBox(width: 16),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// OTP INPUT FIELD
// ──────────────────────────────────────────────────────────
class DSOtpField extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const DSOtpField({
    required this.length,
    required this.controllers,
    required this.focusNodes,
    this.onCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          width: 52,
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: index == length - 1 ? 0 : 8),
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.notoSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: AppTheme.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                borderSide: const BorderSide(color: AppTheme.outlineLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                borderSide: const BorderSide(color: AppTheme.outlineLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                borderSide: const BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < length - 1) {
                focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                focusNodes[index - 1].requestFocus();
              }
              final otp = controllers.map((c) => c.text).join();
              if (otp.length == length) {
                onCompleted?.call(otp);
              }
            },
          ),
        );
      }),
    );
  }
}
