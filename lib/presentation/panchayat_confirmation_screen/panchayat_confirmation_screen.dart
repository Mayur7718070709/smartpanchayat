import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class PanchayatConfirmationScreen extends StatefulWidget {
  const PanchayatConfirmationScreen({super.key});

  @override
  State<PanchayatConfirmationScreen> createState() =>
      _PanchayatConfirmationScreenState();
}

class _PanchayatConfirmationScreenState
    extends State<PanchayatConfirmationScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock Panchayat Data
  static const _panchayatData = {
    'name_mr': 'नेर्ले ग्रामपंचायत',
    'name_en': 'Nerle Gram Panchayat',
    'village_mr': 'नेर्ले',
    'village_en': 'Nerle',
    'taluka_mr': 'वेल्हे',
    'taluka_en': 'Velhe',
    'district_mr': 'पुणे',
    'district_en': 'Pune',
    'state_mr': 'महाराष्ट्र',
    'state_en': 'Maharashtra',
    'pincode': '412212',
    'gp_code': 'MH-PN-VL-0042',
    'total_wards': '7',
    'population': '~2,400',
    'sarpanch': 'श्री. विजय रामचंद्र पाटील',
    'established': '1962',
  };

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndContinue() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(AppRoutes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildPanchayatCard(),
                  const SizedBox(height: 20),
                  _buildDetailsGrid(),
                  const SizedBox(height: 20),
                  _buildMockNotice(),
                  const SizedBox(height: 32),
                  _buildContinueButton(),
                  const SizedBox(height: 16),
                  _buildStepIndicator(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.accentContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'पायरी ५ / Step 5 of 5',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.accent,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'तुमची ग्रामपंचायत',
          style: GoogleFonts.notoSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your Gram Panchayat',
          style: GoogleFonts.notoSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'खालील ग्रामपंचायत तुमच्या मोबाइल नंबरशी जोडलेली आहे. कृपया पुष्टी करा.',
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppTheme.textTertiary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildPanchayatCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Panchayat Logo
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryContainer,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance_rounded,
                      color: AppTheme.primary,
                      size: 26,
                    ),
                    Text(
                      'GP',
                      style: GoogleFonts.notoSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryDark,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _panchayatData['name_mr']!,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _panchayatData['name_en']!,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${_panchayatData['village_mr']}, ${_panchayatData['district_mr']}, ${_panchayatData['state_mr']}',
                        style: GoogleFonts.notoSans(
                          fontSize: 12,
                          color: Colors.white.withAlpha(190),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    final details = [
      {
        'icon': Icons.villa_rounded,
        'label_mr': 'गाव',
        'label_en': 'Village',
        'value':
            '${_panchayatData['village_mr']} (${_panchayatData['village_en']})',
      },
      {
        'icon': Icons.map_rounded,
        'label_mr': 'तालुका',
        'label_en': 'Taluka',
        'value':
            '${_panchayatData['taluka_mr']} (${_panchayatData['taluka_en']})',
      },
      {
        'icon': Icons.location_city_rounded,
        'label_mr': 'जिल्हा',
        'label_en': 'District',
        'value':
            '${_panchayatData['district_mr']} (${_panchayatData['district_en']})',
      },
      {
        'icon': Icons.flag_rounded,
        'label_mr': 'राज्य',
        'label_en': 'State',
        'value':
            '${_panchayatData['state_mr']} (${_panchayatData['state_en']})',
      },
      {
        'icon': Icons.pin_drop_rounded,
        'label_mr': 'पिनकोड',
        'label_en': 'Pincode',
        'value': _panchayatData['pincode']!,
      },
      {
        'icon': Icons.grid_3x3_rounded,
        'label_mr': 'GP कोड',
        'label_en': 'GP Code',
        'value': _panchayatData['gp_code']!,
      },
      {
        'icon': Icons.people_rounded,
        'label_mr': 'लोकसंख्या',
        'label_en': 'Population',
        'value': _panchayatData['population']!,
      },
      {
        'icon': Icons.how_to_vote_rounded,
        'label_mr': 'वार्ड',
        'label_en': 'Total Wards',
        'value': _panchayatData['total_wards']!,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariantLight),
      ),
      child: Column(
        children: List.generate(details.length, (i) {
          final d = details[i];
          final isLast = i == details.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        d['icon'] as IconData,
                        color: AppTheme.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${d['label_mr']} / ${d['label_en']}',
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: AppTheme.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            d['value'] as String,
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(height: 1, color: AppTheme.dividerLight, indent: 64),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMockNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondary.withAlpha(50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_rounded,
            color: AppTheme.secondary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ही माहिती ग्रामपंचायत नोंदणी डेटाबेसमधून आली आहे. चुकीची माहिती असल्यास ग्रामसेवकाशी संपर्क करा.\n\nThis information is from the GP registration database. Contact Gramsevak for corrections.',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.secondaryDark,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _confirmAndContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue to Smart Panchayat',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final isActive = i == 4; // Step 5 (0-indexed)
        final isDone = i < 4;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.secondary
                : isDone
                ? AppTheme.secondary
                : AppTheme.outlineLight,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
