import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LoginLogoWidget extends StatelessWidget {
  const LoginLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ashoka Chakra inspired government seal
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withAlpha(77),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(102),
                    width: 2,
                  ),
                ),
              ),
              // Center icon — Panchayat/Government symbol
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'GP',
                    style: GoogleFonts.notoSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'स्मार्ट पंचायत',
          style: GoogleFonts.notoSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Smart Panchayat',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF757575),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'नेर्ले ग्रामपंचायत, पुणे',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.accent,
            ),
          ),
        ),
      ],
    );
  }
}
