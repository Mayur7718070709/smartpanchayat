import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/payment_model.dart';
import '../../core/app_runtime.dart';
import '../../theme/app_theme.dart';
import './payment_success_screen.dart';
import './payment_failed_screen.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final PaymentSummaryData summaryData;

  const PaymentProcessingScreen({required this.summaryData, super.key});

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnim;
  late Animation<double> _rotateAnim;

  int _currentStep = 0;
  final List<String> _steps = [
    'कनेक्शन सुरक्षित करत आहे...\nSecuring connection...',
    'पेमेंट गेटवेशी संपर्क...\nContacting payment gateway...',
    'व्यवहार प्रक्रिया करत आहे...\nProcessing transaction...',
    'पुष्टी मिळवत आहे...\nFetching confirmation...',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotateAnim = Tween<double>(begin: 0, end: 1).animate(_rotateController);

    if (!AppRuntime.usesRealApi) _simulateProcessing();
  }

  void _simulateProcessing() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) setState(() => _currentStep = i);
    }
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // For demo: navigate to success. In production, replace with Razorpay callback.
    final bool paymentSuccess = true; // TODO: Replace with Razorpay result
    if (paymentSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
            amount: widget.summaryData.totalAmount,
            date: DateTime.now(),
            service: widget.summaryData.service,
            receiptNumber:
                'RCP/NRL/${DateTime.now().year}/${DateTime.now().millisecondsSinceEpoch % 10000}',
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PaymentFailedScreen(
            amount: widget.summaryData.totalAmount,
            service: widget.summaryData.service,
            requestId: widget.summaryData.requestId,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppRuntime.usesRealApi) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Payment'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Payments are not available yet. No transaction was created.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _buildAnimatedIcon(),
                const SizedBox(height: 40),
                _buildTitle(),
                const SizedBox(height: 40),
                _buildStepsList(),
                const Spacer(),
                _buildAmountBadge(),
                const SizedBox(height: 24),
                _buildDoNotCloseNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return ScaleTransition(
      scale: _pulseAnim,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryContainer,
            ),
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withAlpha(26),
            ),
          ),
          RotationTransition(
            turns: _rotateAnim,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary,
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: const Icon(
                Icons.payment_rounded,
                size: 36,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'पेमेंट प्रक्रिया सुरू आहे',
          style: GoogleFonts.notoSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Payment Processing',
          style: GoogleFonts.notoSans(
            fontSize: 15,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepsList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final isDone = i < _currentStep;
          final isCurrent = i == _currentStep;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppTheme.success
                        : isCurrent
                        ? AppTheme.primary
                        : AppTheme.surfaceVariantLight,
                  ),
                  child: Icon(
                    isDone
                        ? Icons.check_rounded
                        : isCurrent
                        ? Icons.sync_rounded
                        : Icons.circle_outlined,
                    size: 16,
                    color: isDone || isCurrent
                        ? Colors.white
                        : AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _steps[i].split('\n').first,
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      color: isDone
                          ? AppTheme.success
                          : isCurrent
                          ? AppTheme.primary
                          : AppTheme.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAmountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.currency_rupee_rounded,
            size: 20,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            widget.summaryData.totalAmount.toStringAsFixed(2),
            style: GoogleFonts.notoSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '• ${widget.summaryData.service.labelEn}',
            style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildDoNotCloseNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 14,
          color: AppTheme.textTertiary,
        ),
        const SizedBox(width: 6),
        Text(
          'हे पेज बंद करू नका / Do not close this page',
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }
}
