import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/notice_model.dart';
import '../../theme/app_theme.dart';

class NoticeDetailScreen extends StatelessWidget {
  final NoticeModel notice;

  const NoticeDetailScreen({required this.notice, super.key});

  Color get _categoryColor {
    switch (notice.category) {
      case 'emergency':
        return const Color(0xFFFF4D00);
      case 'important':
        return AppTheme.warning;
      case 'government':
        return AppTheme.primary;
      case 'event':
        return AppTheme.secondary;
      case 'general':
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData get _categoryIcon {
    switch (notice.category) {
      case 'emergency':
        return Icons.warning_amber_rounded;
      case 'important':
        return Icons.priority_high_rounded;
      case 'government':
        return Icons.account_balance_rounded;
      case 'event':
        return Icons.event_rounded;
      case 'general':
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final months = [
          '',
          'जानेवारी',
          'फेब्रुवारी',
          'मार्च',
          'एप्रिल',
          'मे',
          'जून',
          'जुलै',
          'ऑगस्ट',
          'सप्टेंबर',
          'ऑक्टोबर',
          'नोव्हेंबर',
          'डिसेंबर',
        ];
        final month = int.tryParse(parts[1]) ?? 0;
        return '${parts[2]} ${months[month]} ${parts[0]}';
      }
    } catch (_) {}
    return dateStr;
  }

  @override
  Widget build(BuildContext context) {
    final isEmergency = notice.category == 'emergency';
    final isImportant = notice.category == 'important';
    final needsTreatment = isEmergency || isImportant;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'सूचना तपशील',
          style: GoogleFonts.notoSans(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppTheme.dividerLight),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency / Important visual treatment
            if (needsTreatment)
              _AlertBanner(notice: notice, color: _categoryColor),

            // Main notice card
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: needsTreatment
                      ? _categoryColor.withAlpha(77)
                      : AppTheme.outlineVariantLight,
                  width: needsTreatment ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (needsTreatment)
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: _categoryColor.withAlpha(179),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category chip + date
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _categoryColor.withAlpha(26),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _categoryIcon,
                                    size: 13,
                                    color: _categoryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    notice.categoryLabel,
                                    style: GoogleFonts.notoSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _categoryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              notice.categoryLabelEn,
                              style: GoogleFonts.notoSans(
                                fontSize: 11,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          notice.title,
                          style: GoogleFonts.notoSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notice.titleEn,
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Divider(color: AppTheme.dividerLight),
                        const SizedBox(height: 12),
                        // Published date
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          labelMr: 'प्रकाशित तारीख',
                          labelEn: 'Published Date',
                          value: _formatDate(notice.date),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.person_outline_rounded,
                          labelMr: 'जारी केले',
                          labelEn: 'Issued By',
                          value: notice.issuedBy,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Full content
            _SectionCard(
              title: 'सूचनेचा मजकूर',
              titleEn: 'Notice Content',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.fullContent,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: AppTheme.dividerLight),
                  const SizedBox(height: 10),
                  Text(
                    notice.fullContentEn,
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Panchayat info
            _SectionCard(
              title: 'ग्रामपंचायत माहिती',
              titleEn: 'Panchayat Information',
              child: Column(
                children: [
                  _PanchayatInfoRow(
                    icon: Icons.account_balance_rounded,
                    labelMr: 'ग्रामपंचायत',
                    value: notice.panchayatName,
                    valueEn: notice.panchayatNameEn,
                  ),
                  const SizedBox(height: 10),
                  _PanchayatInfoRow(
                    icon: Icons.location_city_rounded,
                    labelMr: 'जिल्हा',
                    value: notice.district,
                    valueEn: 'District',
                  ),
                  const SizedBox(height: 10),
                  _PanchayatInfoRow(
                    icon: Icons.map_outlined,
                    labelMr: 'तालुका',
                    value: notice.taluka,
                    valueEn: 'Taluka',
                  ),
                ],
              ),
            ),

            // Attachment
            if (notice.attachmentUrl != null) ...[
              const SizedBox(height: 14),
              _AttachmentCard(notice: notice),
            ],

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Alert Banner ──────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final NoticeModel notice;
  final Color color;

  const _AlertBanner({required this.notice, required this.color});

  @override
  Widget build(BuildContext context) {
    final isEmergency = notice.category == 'emergency';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEmergency
                  ? Icons.warning_amber_rounded
                  : Icons.priority_high_rounded,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEmergency ? 'आपत्कालीन सूचना' : 'महत्त्वाची सूचना',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  isEmergency ? 'Emergency Notice' : 'Important Notice',
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: color.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final String titleEn;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.titleEn,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariantLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '/ $titleEn',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 20,
            indent: 16,
            endIndent: 16,
            color: AppTheme.dividerLight,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Info Row ──────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String labelMr;
  final String labelEn;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$labelMr / $labelEn',
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppTheme.textTertiary,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Panchayat Info Row ────────────────────────────────────────
class _PanchayatInfoRow extends StatelessWidget {
  final IconData icon;
  final String labelMr;
  final String value;
  final String valueEn;

  const _PanchayatInfoRow({
    required this.icon,
    required this.labelMr,
    required this.value,
    required this.valueEn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelMr,
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
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

// ── Attachment Card ───────────────────────────────────────────
class _AttachmentCard extends StatelessWidget {
  final NoticeModel notice;

  const _AttachmentCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariantLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Text(
                  'संलग्न दस्तऐवज',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '/ Attachment',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 20,
            indent: 16,
            endIndent: 16,
            color: AppTheme.dividerLight,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.outlineVariantLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 20,
                          color: AppTheme.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notice.attachmentName ?? 'Document.pdf',
                              style: GoogleFonts.notoSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'PDF दस्तऐवज',
                              style: GoogleFonts.notoSans(
                                fontSize: 11,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = notice.attachmentUrl;
                      if (url == null ||
                          !await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          )) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Attachment could not be opened.'),
                          ),
                        );
                        return;
                      }
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'दस्तऐवज उघडत आहे… / Opening document…',
                            style: GoogleFonts.notoSans(fontSize: 13),
                          ),
                          backgroundColor: AppTheme.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text(
                      'दस्तऐवज पहा / View Document',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
