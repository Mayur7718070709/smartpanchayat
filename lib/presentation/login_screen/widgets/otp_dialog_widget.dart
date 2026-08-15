import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../data/mock_data.dart';

class OtpDialogWidget extends StatefulWidget {
  final String mobile;
  final VoidCallback onVerified;

  const OtpDialogWidget({
    required this.mobile,
    required this.onVerified,
    super.key,
  });

  @override
  State<OtpDialogWidget> createState() => _OtpDialogWidgetState();
}

class _OtpDialogWidgetState extends State<OtpDialogWidget> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 30;
  bool _isVerifying = false;
  String? _errorMessage;
  Timer? _timer;

  // TODO: Replace with real OTP verification service
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
      } else {
        if (mounted) setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_enteredOtp.length < 6) {
      setState(() => _errorMessage = 'कृपया ६ अंकी OTP टाका');
      return;
    }
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });
    // TODO: Replace with real OTP verification
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    if (_enteredOtp == MockData.mockOtp) {
      widget.onVerified();
    } else {
      setState(() {
        _isVerifying = false;
        _errorMessage =
            'चुकीचा OTP / Invalid OTP — Demo साठी ${MockData.mockOtp} वापरा';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskedMobile =
        '${widget.mobile.substring(0, 2)}XXXXXX${widget.mobile.substring(8)}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sms_rounded,
                color: AppTheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'OTP टाका / Enter OTP',
              style: GoogleFonts.notoSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '+91 $maskedMobile वर OTP पाठवला',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: const Color(0xFF757575),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 44,
                  height: 56,
                  child: TextFormField(
                    controller: _otpControllers[i],
                    focusNode: _focusNodes[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: GoogleFonts.notoSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: AppTheme.surfaceVariantLight,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppTheme.outlineLight,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppTheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty && i < 5) {
                        _focusNodes[i + 1].requestFocus();
                      }
                      if (val.isEmpty && i > 0) {
                        _focusNodes[i - 1].requestFocus();
                      }
                      setState(() => _errorMessage = null);
                    },
                  ),
                );
              }),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppTheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _secondsRemaining > 0
                      ? 'पुन्हा OTP: ${_secondsRemaining}s'
                      : 'OTP मिळाले नाही? / Didn\'t receive?',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: const Color(0xFF757575),
                  ),
                ),
                if (_secondsRemaining <= 0) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _startTimer,
                    child: Text(
                      'पुन्हा पाठवा / Resend',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'सत्यापित करा / Verify',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
