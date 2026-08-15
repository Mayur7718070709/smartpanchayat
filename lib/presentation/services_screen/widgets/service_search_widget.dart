import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ServiceSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ServiceSearchWidget({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  @override
  State<ServiceSearchWidget> createState() => _ServiceSearchWidgetState();
}

class _ServiceSearchWidgetState extends State<ServiceSearchWidget> {
  bool _isFocused = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isFocused ? AppTheme.primary : AppTheme.outlineVariantLight,
          width: _isFocused ? 2 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppTheme.primary.withAlpha(31),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: GoogleFonts.notoSans(
          fontSize: 14,
          color: const Color(0xFF212121),
        ),
        decoration: InputDecoration(
          hintText: 'सेवा शोधा / Search services...',
          hintStyle: GoogleFonts.notoSans(
            fontSize: 14,
            color: const Color(0xFF9E9E9E),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _isFocused ? AppTheme.primary : const Color(0xFF9E9E9E),
            size: 22,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Color(0xFF757575),
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
