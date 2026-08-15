import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LoginFormWidget extends StatelessWidget {
  final TextEditingController mobileController;
  final bool isLoading;
  final VoidCallback onSendOtp;

  const LoginFormWidget({
    required this.mobileController,
    required this.isLoading,
    required this.onSendOtp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'आपला मोबाइल नंबर टाका',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Enter your mobile number',
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: const Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
            letterSpacing: 2,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.surfaceVariantLight,
            labelText: 'मोबाइल नंबर / Mobile Number',
            labelStyle: GoogleFonts.notoSans(
              fontSize: 14,
              color: const Color(0xFF757575),
            ),
            prefixIcon: Container(
              width: 56,
              margin: const EdgeInsets.only(left: 4, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇮🇳', style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 4),
                  Text(
                    '+91',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 72),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.outlineLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.outlineVariantLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.error),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'कृपया मोबाइल नंबर टाका / Please enter mobile number';
            }
            if (value.length != 10) {
              return 'कृपया १० अंकी नंबर टाका / Enter 10 digit number';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OTP पाठवा',
                        style: GoogleFonts.notoSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '/ Send OTP',
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withAlpha(217),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
