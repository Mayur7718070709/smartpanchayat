import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/service_model.dart';
import '../../../theme/app_theme.dart';

class ServiceCardWidget extends StatefulWidget {
  final ServiceModel service;
  final VoidCallback onApply;

  const ServiceCardWidget({
    required this.service,
    required this.onApply,
    super.key,
  });

  @override
  State<ServiceCardWidget> createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = widget.service;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) => _scaleController.reverse(),
        onTapCancel: () => _scaleController.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: service.color.withAlpha(20),
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onApply();
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon container — top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: service.color.withAlpha(31),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            service.icon,
                            color: service.color,
                            size: 26,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: service.color.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            service.categoryLabel,
                            style: GoogleFonts.notoSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: service.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Marathi name — bold primary
                    Text(
                      service.nameMr,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF212121),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // English name — caption
                    Text(
                      service.nameEn,
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: const Color(0xFF757575),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Fee + processing time row
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 12,
                          color: const Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${service.processingDays}d',
                          style: GoogleFonts.notoSans(
                            fontSize: 11,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          service.fee == 0
                              ? 'मोफत'
                              : '₹${service.fee.toStringAsFixed(0)}',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: service.fee == 0
                                ? AppTheme.secondary
                                : AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Apply button
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          widget.onApply();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: service.color,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                          textStyle: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Text(
                          'अर्ज करा / Apply',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
