import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class QuickServicesWidget extends StatelessWidget {
  const QuickServicesWidget({super.key});

  static const List<Map<String, dynamic>> _popularServices = [
    {
      'nameMr': 'जन्म दाखला',
      'nameEn': 'Birth Certificate',
      'icon': Icons.child_care_rounded,
      'color': Color(0xFFFF8100),
      'bgColor': Color(0xFFFFF3E0),
    },
    {
      'nameMr': 'रहिवासी दाखला',
      'nameEn': 'Residence Cert.',
      'icon': Icons.home_work_rounded,
      'color': Color(0xFF1B7A3E),
      'bgColor': Color(0xFFE8F5E9),
    },
    {
      'nameMr': 'मालमत्ता कर',
      'nameEn': 'Property Tax',
      'icon': Icons.villa_rounded,
      'color': Color(0xFF6A1B9A),
      'bgColor': Color(0xFFF3E5F5),
    },
    {
      'nameMr': 'पाणी कर',
      'nameEn': 'Water Tax',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFF0277BD),
      'bgColor': Color(0xFFE1F5FE),
    },
    {
      'nameMr': 'उत्पन्न दाखला',
      'nameEn': 'Income Cert.',
      'icon': Icons.account_balance_wallet_rounded,
      'color': Color(0xFFE65100),
      'bgColor': Color(0xFFFBE9E7),
    },
    {
      'nameMr': 'बांधकाम परवाना',
      'nameEn': 'Building Permit',
      'icon': Icons.construction_rounded,
      'color': Color(0xFFBF360C),
      'bgColor': Color(0xFFFBE9E7),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: _popularServices.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final svc = _popularServices[index];
          return _ServiceChip(service: svc);
        },
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final Map<String, dynamic> service;
  const _ServiceChip({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/services-screen'),
      child: Container(
        width: 82,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: service['bgColor'] as Color,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                service['icon'] as IconData,
                color: service['color'] as Color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                service['nameMr'] as String,
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
