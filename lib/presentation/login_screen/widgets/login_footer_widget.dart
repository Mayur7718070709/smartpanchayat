import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: const Color(0xFF757575),
            ),
            children: [
              const TextSpan(text: 'पुढे जाऊन आपण आमच्या '),
              TextSpan(
                text: 'सेवा अटी',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
              const TextSpan(text: ' व '),
              TextSpan(
                text: 'गोपनीयता धोरण',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
              const TextSpan(text: ' मान्य करता'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.business_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Mexon Intelligence Pvt. Ltd.',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: const Color(0xFF9E9E9E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
