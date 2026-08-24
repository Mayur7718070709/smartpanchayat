import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/scheme_model.dart';
import '../../theme/app_theme.dart';

class SchemeDetailScreen extends StatelessWidget {
  final SchemeModel scheme;

  const SchemeDetailScreen({required this.scheme, super.key});

  Color get _categoryColor {
    switch (scheme.category) {
      case 'housing':
        return AppTheme.primary;
      case 'employment':
        return AppTheme.secondary;
      case 'agriculture':
        return const Color(0xFF2E7D32);
      case 'health':
        return const Color(0xFFD32F2F);
      case 'education':
        return const Color(0xFF7B1FA2);
      case 'women':
        return const Color(0xFFE91E63);
      case 'sanitation':
        return AppTheme.accent;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData get _categoryIcon {
    switch (scheme.category) {
      case 'housing':
        return Icons.home_rounded;
      case 'employment':
        return Icons.work_rounded;
      case 'agriculture':
        return Icons.agriculture_rounded;
      case 'health':
        return Icons.local_hospital_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'women':
        return Icons.woman_rounded;
      case 'sanitation':
        return Icons.cleaning_services_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('URL उघडता आली नाही / Could not open URL'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('URL उघडता आली नाही / Could not open URL'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppTheme.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'योजना माहिती / Scheme Details',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppTheme.dividerLight),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(color),
                  // Disclaimer banner
                  _buildDisclaimerBanner(),
                  // Sections
                  _buildSection(
                    icon: Icons.info_outline_rounded,
                    titleMr: 'योजनेबद्दल',
                    titleEn: 'About the Scheme',
                    color: color,
                    child: _buildTextContent(scheme.aboutMr, scheme.aboutEn),
                  ),
                  _buildSection(
                    icon: Icons.person_outline_rounded,
                    titleMr: 'कोण अर्ज करू शकतो?',
                    titleEn: 'Who Can Apply',
                    color: color,
                    child: _buildTextContent(
                      scheme.whoCanApplyMr,
                      scheme.whoCanApplyEn,
                    ),
                  ),
                  _buildSection(
                    icon: Icons.card_giftcard_rounded,
                    titleMr: 'लाभ',
                    titleEn: 'Benefits',
                    color: color,
                    child: _buildTextContent(
                      scheme.benefitsMr,
                      scheme.benefitsEn,
                    ),
                  ),
                  _buildSection(
                    icon: Icons.checklist_rounded,
                    titleMr: 'पात्रता',
                    titleEn: 'Eligibility',
                    color: color,
                    child: _buildTextContent(
                      scheme.eligibilityMr,
                      scheme.eligibilityEn,
                    ),
                  ),
                  _buildSection(
                    icon: Icons.folder_outlined,
                    titleMr: 'आवश्यक कागदपत्रे',
                    titleEn: 'Required Documents',
                    color: color,
                    child: _buildDocumentsList(),
                  ),
                  _buildSection(
                    icon: Icons.assignment_outlined,
                    titleMr: 'अर्ज कसा करावा?',
                    titleEn: 'How to Apply',
                    color: color,
                    child: _buildTextContent(
                      scheme.howToApplyMr,
                      scheme.howToApplyEn,
                    ),
                  ),
                  _buildSection(
                    icon: Icons.language_rounded,
                    titleMr: 'अधिकृत स्रोत',
                    titleEn: 'Official Source',
                    color: color,
                    child: _buildOfficialSource(context),
                  ),
                  _buildLastUpdatedRow(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // CTA
          _buildCTA(context, color),
        ],
      ),
    );
  }

  Widget _buildHeader(Color color) {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Icon(_categoryIcon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheme.nameMr,
                  style: GoogleFonts.notoSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  scheme.nameEn,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      size: 13,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        scheme.departmentEn,
                        style: GoogleFonts.notoSans(
                          fontSize: 11,
                          color: AppTheme.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '${scheme.categoryLabel} / ${scheme.categoryLabelEn}',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
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

  Widget _buildDisclaimerBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warningContainer,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppTheme.warning.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'माहिती स्रोत / Information Source',
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onWarningContainer,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  scheme.informationSourceEn.isEmpty
                      ? scheme.informationSource
                      : '${scheme.informationSource}\n${scheme.informationSourceEn}',
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppTheme.onWarningContainer,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ही माहिती सामान्य मार्गदर्शनासाठी आहे. अधिकृत माहितीसाठी संबंधित सरकारी विभागाशी संपर्क साधा.',
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: AppTheme.onWarningContainer.withAlpha(180),
                    height: 1.4,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'This information is for general guidance. For official information, contact the relevant government department.',
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: AppTheme.onWarningContainer.withAlpha(180),
                    height: 1.4,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String titleMr,
    required String titleEn,
    required Color color,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppTheme.outlineVariantLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(icon, color: color, size: 17),
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
            ),
          ),
          Divider(height: 1, color: AppTheme.dividerLight),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildTextContent(String mr, String en) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mr,
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppTheme.textPrimary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          en,
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsList() {
    return Column(
      children: scheme.requiredDocuments.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: _categoryColor.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _categoryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  entry.key < scheme.requiredDocumentsEn.length
                      ? '${entry.value}\n${scheme.requiredDocumentsEn[entry.key]}'
                      : entry.value,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOfficialSource(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(context, scheme.officialSourceUrl),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: AppTheme.primary.withAlpha(60)),
        ),
        child: Row(
          children: [
            Icon(Icons.open_in_new_rounded, size: 18, color: AppTheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheme.officialSourceLabelEn.isEmpty
                        ? scheme.officialSourceLabel
                        : '${scheme.officialSourceLabel} / ${scheme.officialSourceLabelEn}',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    'अधिकृत सरकारी वेबसाइट / Official Government Website',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: AppTheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdatedRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Icon(Icons.update_rounded, size: 14, color: AppTheme.textTertiary),
          const SizedBox(width: 6),
          Text(
            'शेवटचे अपडेट / Last Updated: ',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: AppTheme.textTertiary,
            ),
          ),
          Text(
            scheme.lastUpdated,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTA(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(top: BorderSide(color: AppTheme.dividerLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => _launchUrl(context, scheme.applyUrl),
          icon: const Icon(Icons.open_in_new_rounded, size: 18),
          label: Text(
            'अर्ज करा / Learn More',
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ),
      ),
    );
  }
}
