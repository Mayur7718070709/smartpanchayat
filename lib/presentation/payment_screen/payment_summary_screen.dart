import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/payment_model.dart';
import '../../core/app_runtime.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_payment_data.dart';
import './payment_processing_screen.dart';
import './payment_availability_screen.dart';

class PaymentSummaryScreen extends StatelessWidget {
  final PaymentSummaryData? summaryData;

  const PaymentSummaryScreen({this.summaryData, super.key});

  @override
  Widget build(BuildContext context) {
    if (AppRuntime.usesRealApi) {
      return const PaymentAvailabilityScreen();
    }
    final data = summaryData ?? MockPaymentData.sampleSummary;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'पेमेंट सारांश',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Payment Summary',
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceHeader(data),
                  const SizedBox(height: 20),
                  _buildSummaryCard(context, data),
                  const SizedBox(height: 20),
                  _buildChargesCard(data),
                  const SizedBox(height: 20),
                  _buildSecurePaymentNote(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomCTA(context, data),
        ],
      ),
    );
  }

  Widget _buildServiceHeader(PaymentSummaryData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [data.service.color, data.service.color.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: data.service.color.withAlpha(51),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(data.service.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.service.labelMr,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  data.service.labelEn,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${data.totalAmount.toStringAsFixed(0)}',
                style: GoogleFonts.notoSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'एकूण रक्कम',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: Colors.white.withAlpha(204),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, PaymentSummaryData data) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'विनंती तपशील / Request Details',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.confirmation_number_outlined,
            labelMr: 'विनंती क्रमांक',
            labelEn: 'Request ID',
            value: data.requestId,
            onCopy: () {
              Clipboard.setData(ClipboardData(text: data.requestId));
              HapticFeedback.lightImpact();
            },
          ),
          const Divider(height: 20, color: AppTheme.dividerLight),
          _buildDetailRow(
            icon: Icons.person_rounded,
            labelMr: 'नागरिक',
            labelEn: 'Citizen',
            value: '${data.citizenNameMr} / ${data.citizenName}',
          ),
          const Divider(height: 20, color: AppTheme.dividerLight),
          _buildDetailRow(
            icon: Icons.miscellaneous_services_rounded,
            labelMr: 'सेवा',
            labelEn: 'Service',
            value: '${data.service.labelMr} / ${data.service.labelEn}',
          ),
          const Divider(height: 20, color: AppTheme.dividerLight),
          _buildDetailRow(
            icon: Icons.currency_rupee_rounded,
            labelMr: 'मूळ रक्कम',
            labelEn: 'Base Amount',
            value: '₹${data.baseAmount.toStringAsFixed(2)}',
            valueColor: AppTheme.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String labelMr,
    required String labelEn,
    required String value,
    Color? valueColor,
    VoidCallback? onCopy,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$labelMr / $labelEn',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (onCopy != null)
          GestureDetector(
            onTap: onCopy,
            child: const Icon(
              Icons.copy_rounded,
              size: 16,
              color: AppTheme.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildChargesCard(PaymentSummaryData data) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'शुल्क तपशील / Charge Breakdown',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildChargeRow(
            label: data.service.labelMr,
            labelEn: data.service.labelEn,
            amount: data.baseAmount,
          ),
          ...data.charges.map(
            (c) => Column(
              children: [
                const Divider(height: 16, color: AppTheme.dividerLight),
                _buildChargeRow(
                  label: c.labelMr,
                  labelEn: c.label,
                  amount: c.amount,
                  isCharge: true,
                ),
              ],
            ),
          ),
          const Divider(
            height: 20,
            color: AppTheme.outlineLight,
            thickness: 1.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'एकूण देय रक्कम',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Total Payable Amount',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '₹${data.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.notoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChargeRow({
    required String label,
    required String labelEn,
    required double amount,
    bool isCharge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                labelEn,
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isCharge ? AppTheme.textSecondary : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurePaymentNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.successContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.success.withAlpha(51)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_rounded, size: 20, color: AppTheme.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'सुरक्षित पेमेंट / Secure Payment',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.success,
                  ),
                ),
                Text(
                  'तुमचे पेमेंट सुरक्षित आहे. Your payment is encrypted and secure.',
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppTheme.onSuccessContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA(BuildContext context, PaymentSummaryData data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'एकूण रक्कम / Total',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '₹${data.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.notoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PaymentProcessingScreen(summaryData: data),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment_rounded, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Proceed to Payment',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
