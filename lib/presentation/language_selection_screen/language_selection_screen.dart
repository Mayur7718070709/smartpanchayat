import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedLanguage;
  bool _isSaving = false;
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
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

  Future<void> _saveAndContinue() async {
    if (_selectedLanguage == null) return;
    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', _selectedLanguage!);
    if (!mounted) return;
    setState(() => _isSaving = false);
    context.go(AppRoutes.loginScreen);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  _buildHeader(),
                  const SizedBox(height: 48),
                  _buildLanguageCard(
                    language: 'mr',
                    primaryLabel: 'मराठी',
                    secondaryLabel: 'Marathi',
                    description: 'मराठी भाषेत सुरू ठेवा',
                    flagEmoji: '🇮🇳',
                  ),
                  const SizedBox(height: 16),
                  _buildLanguageCard(
                    language: 'en',
                    primaryLabel: 'English',
                    secondaryLabel: 'इंग्रजी',
                    description: 'Continue in English',
                    flagEmoji: '🇬🇧',
                  ),
                  const Spacer(),
                  _buildContinueButton(),
                  const SizedBox(height: 16),
                  _buildFooterNote(),
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
      children: [
        // Logo mark
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withAlpha(60),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.translate_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'भाषा निवडा',
          style: GoogleFonts.notoSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Select Language',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'तुमची पसंतीची भाषा निवडा\nChoose your preferred language',
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppTheme.textTertiary,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLanguageCard({
    required String language,
    required String primaryLabel,
    required String secondaryLabel,
    required String description,
    required String flagEmoji,
  }) {
    final isSelected = _selectedLanguage == language;
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = language),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.outlineLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withAlpha(30),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Flag / emoji
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary.withAlpha(20)
                    : AppTheme.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(flagEmoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),
            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryLabel,
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppTheme.primaryDark
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    secondaryLabel,
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: isSelected
                          ? AppTheme.primary.withAlpha(180)
                          : AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.outlineLight,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = _selectedLanguage != null;
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isEnabled && !_isSaving ? _saveAndContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          disabledBackgroundColor: AppTheme.outlineLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: isEnabled ? 2 : 0,
        ),
        child: _isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                _selectedLanguage == 'mr'
                    ? 'पुढे जा / Continue'
                    : 'Continue / पुढे जा',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildFooterNote() {
    return Text(
      'तुम्ही नंतर सेटिंग्जमध्ये भाषा बदलू शकता\nYou can change language later in Settings',
      style: GoogleFonts.notoSans(
        fontSize: 11,
        color: AppTheme.textTertiary,
        height: 1.6,
      ),
      textAlign: TextAlign.center,
    );
  }
}
