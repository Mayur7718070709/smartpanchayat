import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/service_model.dart';
import '../../core/app_runtime.dart';
import '../../theme/app_theme.dart';
import './application_submitted_screen.dart';

class ApplicationReviewScreen extends StatelessWidget {
  final ServiceModel service;
  final Map<String, dynamic> formValues;

  const ApplicationReviewScreen({
    required this.service,
    required this.formValues,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'अर्ज तपासा',
              style: GoogleFonts.notoSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Review Application',
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildReviewBanner(),
                const SizedBox(height: 16),
                _buildServiceSummary(),
                const SizedBox(height: 16),
                _buildFormReview(),
                const SizedBox(height: 16),
                if (service.fee > 0) _buildFeeCard(),
                if (service.fee > 0) const SizedBox(height: 16),
                _buildDeclarationCard(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildSubmitBar(context),
        ],
      ),
    );
  }

  Widget _buildReviewBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.infoContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.info.withAlpha(51)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppTheme.info,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'कृपया सादर करण्यापूर्वी सर्व माहिती तपासा.\nPlease review all information before submitting.',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.info,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            titleMr: 'सेवा तपशील',
            titleEn: 'Service Details',
            icon: Icons.miscellaneous_services_rounded,
            color: service.color,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: service.color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(service.icon, color: service.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.nameMr,
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      service.nameEn,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: AppTheme.dividerLight),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReviewMetaItem(
                  icon: Icons.timer_outlined,
                  label: 'प्रक्रिया वेळ / Processing',
                  value: '${service.processingDays} दिवस / days',
                ),
              ),
              Expanded(
                child: _ReviewMetaItem(
                  icon: Icons.currency_rupee_rounded,
                  label: 'शुल्क / Fee',
                  value: service.fee == 0
                      ? 'मोफत / Free'
                      : '₹${service.fee.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormReview() {
    final displayFields = formValues.entries
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            titleMr: 'भरलेली माहिती',
            titleEn: 'Entered Information',
            icon: Icons.list_alt_rounded,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 14),
          if (displayFields.isEmpty)
            Text(
              'कोणतीही माहिती भरली नाही / No information entered',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppTheme.textTertiary,
              ),
            )
          else
            ...displayFields.asMap().entries.map((entry) {
              final idx = entry.key;
              final e = entry.value;
              final fieldDef = service.formFields
                  .where((f) => f.id == e.key)
                  .firstOrNull;
              final label = fieldDef != null
                  ? '${fieldDef.labelMr} / ${fieldDef.labelEn}'
                  : e.key;
              final isFile =
                  e.value.toString().contains('.pdf') ||
                  e.value.toString().contains('.jpg');
              return Column(
                children: [
                  if (idx > 0)
                    Container(
                      height: 1,
                      color: AppTheme.dividerLight,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          label,
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: isFile
                            ? Row(
                                children: [
                                  Icon(
                                    e.value.toString().contains('.jpg')
                                        ? Icons.image_outlined
                                        : Icons.description_outlined,
                                    size: 16,
                                    color: AppTheme.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'अपलोड केले / Uploaded',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.success,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                e.value is List
                                    ? (e.value as List).join(', ')
                                    : e.value.toString(),
                                style: GoogleFonts.notoSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildFeeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accent.withAlpha(51)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.currency_rupee_rounded,
            color: AppTheme.accent,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'देय शुल्क / Payable Fee',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '₹${service.fee.toStringAsFixed(0)}',
                  style: GoogleFonts.notoSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.accent,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'सादर करताना / On Submit',
              style: GoogleFonts.notoSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclarationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariantLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 20,
            color: AppTheme.secondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'मी घोषित करतो/करते की वरील सर्व माहिती सत्य आणि अचूक आहे.\nI declare that all the above information is true and accurate.',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: service.color),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            child: Text(
              'संपादित करा\nEdit',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: service.color,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  if (!AppRuntime.usesRealApi) {
                    final requestId =
                        'GP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApplicationSubmittedScreen(
                          service: service,
                          requestId: requestId,
                          submittedDate: DateTime.now(),
                        ),
                      ),
                    );
                    return;
                  }
                  try {
                    final request = await AppRuntime.serviceRequests.create(
                      serviceId: service.id,
                      formData: formValues,
                      idempotencyKey: _newUuid(),
                    );
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApplicationSubmittedScreen(
                          service: service,
                          requestId: request.requestNumber,
                          submittedDate:
                              request.submittedAt ?? request.createdAt,
                        ),
                      ),
                    );
                  } catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Application failed: $error')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: service.color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'अर्ज सादर करा / Submit Application',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _newUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}

class _SectionHeader extends StatelessWidget {
  final String titleMr;
  final String titleEn;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.titleMr,
    required this.titleEn,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleMr,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              titleEn,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewMetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReviewMetaItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textTertiary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  color: AppTheme.textTertiary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
