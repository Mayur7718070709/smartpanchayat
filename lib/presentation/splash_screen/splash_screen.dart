import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_runtime.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeOut);
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );
    _taglineFade = CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOut,
    );

    _runAnimationSequence();
  }

  Future<void> _runAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _taglineController.forward();
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) _navigateNext();
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLanguage = prefs.getString('selected_language') != null;
    if (!mounted) return;
    if (!hasLanguage) {
      context.go(AppRoutes.languageSelectionScreen);
      return;
    }

    if (AppRuntime.usesRealApi && AppRuntime.auth.hasSession) {
      try {
        final authContext = await AppRuntime.authContext.fetch();
        if (authContext.isReadyCitizen && mounted) {
          context.go(AppRoutes.homeScreen);
          return;
        }
      } catch (_) {
        // A persisted Supabase session is not sufficient by itself. FastAPI
        // must resolve an active tenant-scoped citizen context.
      }
      await AppRuntime.auth.signOut();
      if (!mounted) return;
    }
    context.go(AppRoutes.loginScreen);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D3B9E), Color(0xFF1A56DB), Color(0xFF1B7A3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative civic pattern background
              Positioned.fill(child: _buildCivicPattern()),
              // Main content
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: _buildLogo(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // App name
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textFade,
                          child: _buildAppName(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tagline
                      FadeTransition(
                        opacity: _taglineFade,
                        child: _buildTagline(),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom civic identity strip
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _taglineFade,
                  child: _buildBottomStrip(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCivicPattern() {
    return CustomPaint(painter: _CivicPatternPainter());
  }

  Widget _buildLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer decorative ring
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primary.withAlpha(40),
                width: 2,
              ),
            ),
          ),
          // Inner ring
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryContainer, Color(0xFFDCE8FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Icon
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_rounded,
                color: AppTheme.primary,
                size: 34,
              ),
              const SizedBox(height: 2),
              Text(
                'GP',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryDark,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppName() {
    return Column(
      children: [
        Text(
          'स्मार्ट पंचायत',
          style: GoogleFonts.notoSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Smart Panchayat',
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white.withAlpha(200),
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(40), width: 1),
      ),
      child: Text(
        'Smart Governance.\nConnected Citizens.\nDigital Villages.',
        style: GoogleFonts.notoSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.white.withAlpha(230),
          height: 1.7,
          letterSpacing: 0.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBottomStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(color: Colors.black.withAlpha(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tricolor dots — Indian flag colors
          _colorDot(const Color(0xFFFF9933)),
          const SizedBox(width: 6),
          _colorDot(Colors.white),
          const SizedBox(width: 6),
          _colorDot(const Color(0xFF138808)),
          const SizedBox(width: 12),
          Text(
            'Powered by Mexon Intelligence',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: Colors.white.withAlpha(160),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _CivicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw subtle concentric circles for civic/government feel
    for (int i = 1; i <= 6; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.15),
        i * 45.0,
        paint,
      );
    }
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.75),
        i * 35.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
