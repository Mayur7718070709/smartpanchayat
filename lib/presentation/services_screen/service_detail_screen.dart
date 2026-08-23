import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_runtime.dart';
import '../../models/service_model.dart';
import '../../theme/app_theme.dart';
import './application_form_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailScreen({required this.service, super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late ServiceModel _service;
  bool _isLoading = false;
  Object? _loadError;

  ServiceModel get service => _service;

  @override
  void initState() {
    super.initState();
    _service = widget.service;
    if (AppRuntime.usesRealApi) _loadService();
  }

  Future<void> _loadService() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final service = await AppRuntime.services.fetchById(widget.service.id);
      if (!mounted) return;
      _service = service;
    } catch (error) {
      if (!mounted) return;
      _loadError = error;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Service Details')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unable to load service details.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadService,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCards(context),
                  const SizedBox(height: 16),
                  _buildDescriptionCard(),
                  const SizedBox(height: 16),
                  _buildEligibilityCard(),
                  const SizedBox(height: 16),
                  _buildDocumentsCard(),
                  const SizedBox(height: 16),
                  _buildProcessingCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildApplyBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: service.color,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [service.color, service.color.withAlpha(200)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(service.icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            service.categoryLabel,
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          service.nameMr,
                          style: GoogleFonts.notoSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          service.nameEn,
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            icon: Icons.timer_outlined,
            labelMr: 'प्रक्रिया वेळ',
            labelEn: 'Processing',
            value: '${service.processingDays} दिवस',
            color: AppTheme.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoTile(
            icon: Icons.currency_rupee_rounded,
            labelMr: 'शुल्क',
            labelEn: 'Fee',
            value: service.fee == 0
                ? 'मोफत'
                : '₹${service.fee.toStringAsFixed(0)}',
            color: service.fee == 0 ? AppTheme.secondary : AppTheme.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoTile(
            icon: Icons.category_outlined,
            labelMr: 'प्रकार',
            labelEn: 'Category',
            value: service.categoryLabel,
            color: service.color,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return _SectionCard(
      icon: Icons.info_outline_rounded,
      titleMr: 'सेवेबद्दल',
      titleEn: 'About Service',
      color: AppTheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.descriptionEn,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.description,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityCard() {
    if (service.eligibilityEn.isEmpty && service.eligibilityMr.isEmpty) {
      return const SizedBox.shrink();
    }
    return _SectionCard(
      icon: Icons.how_to_reg_outlined,
      titleMr: 'पात्रता',
      titleEn: 'Eligibility',
      color: AppTheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 18,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  service.eligibilityEn,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 18,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  service.eligibilityMr,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard() {
    if (service.requiredDocuments.isEmpty) return const SizedBox.shrink();
    return _SectionCard(
      icon: Icons.folder_open_rounded,
      titleMr: 'आवश्यक कागदपत्रे',
      titleEn: 'Required Documents',
      color: AppTheme.accent,
      child: Column(
        children: service.requiredDocuments.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.accentContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.value,
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
      ),
    );
  }

  Widget _buildProcessingCard() {
    return _SectionCard(
      icon: Icons.schedule_rounded,
      titleMr: 'प्रक्रिया माहिती',
      titleEn: 'Processing Information',
      color: AppTheme.info,
      child: Column(
        children: [
          _ProcessStep(
            step: '1',
            mr: 'अर्ज सादर करा',
            en: 'Submit Application',
            color: AppTheme.info,
          ),
          _ProcessStep(
            step: '2',
            mr: 'कागदपत्रे तपासणी',
            en: 'Document Verification',
            color: AppTheme.info,
          ),
          _ProcessStep(
            step: '3',
            mr: 'मंजुरी प्रक्रिया (${service.processingDays} दिवस)',
            en: 'Approval Process (${service.processingDays} days)',
            color: AppTheme.info,
          ),
          _ProcessStep(
            step: '4',
            mr: 'दाखला/प्रमाणपत्र वितरण',
            en: 'Certificate Delivery',
            color: AppTheme.info,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildApplyBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            if (AppRuntime.usesRealApi) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Online applications are not available yet.'),
                ),
              );
              return;
            }
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ApplicationFormScreen(service: service),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: service.color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_document, size: 20),
              const SizedBox(width: 8),
              Text(
                'अर्ज करा / Apply Now',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String labelMr;
  final String labelEn;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$labelMr\n$labelEn',
            style: GoogleFonts.notoSans(
              fontSize: 10,
              color: AppTheme.textTertiary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String titleMr;
  final String titleEn;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleMr,
                    style: GoogleFonts.notoSans(
                      fontSize: 15,
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
          const SizedBox(height: 14),
          Container(height: 1, color: AppTheme.dividerLight),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final String step;
  final String mr;
  final String en;
  final Color color;
  final bool isLast;

  const _ProcessStep({
    required this.step,
    required this.mr,
    required this.en,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: Center(
                child: Text(
                  step,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 28, color: color.withAlpha(51)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mr,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  en,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: isLast ? 0 : 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
