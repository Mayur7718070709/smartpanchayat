import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_runtime.dart';
import '../../core/auth/phone_auth_service.dart';
import '../../core/network/api_exception.dart';
import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/login_footer_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_logo_widget.dart';
import './widgets/otp_dialog_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  bool _isLoading = false;
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
      curve: Curves.easeOutCubic,
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
    _mobileController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (AppRuntime.usesRealApi) {
        await AppRuntime.auth.sendOtp(_mobileController.text);
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
      }
      if (mounted) _showOtpDialog();
    } on PhoneAuthFailure catch (error) {
      _showError(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => OtpDialogWidget(
        mobile: _mobileController.text,
        verifyOtp: _verifyOtp,
        resendOtp: _resendOtp,
        onVerified: () {
          Navigator.of(context).pop();
          context.go(
            AppRuntime.usesRealApi
                ? AppRoutes.homeScreen
                : AppRoutes.profileSetupScreen,
          );
        },
      ),
    );
  }

  Future<void> _verifyOtp(String otp) async {
    if (!AppRuntime.usesRealApi) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (otp != MockData.mockOtp) {
        throw PhoneAuthFailure(
          'Invalid OTP — use ${MockData.mockOtp} for the demo.',
        );
      }
      return;
    }

    await AppRuntime.auth.verifyOtp(_mobileController.text, otp);
    try {
      final authContext = await AppRuntime.authContext.fetch();
      if (!authContext.isReadyCitizen) {
        throw const PhoneAuthFailure(
          'This account is not linked to an active citizen profile.',
        );
      }
    } on ApiException catch (error) {
      await AppRuntime.auth.signOut();
      throw PhoneAuthFailure(error.message);
    } on PhoneAuthFailure {
      await AppRuntime.auth.signOut();
      rethrow;
    }
  }

  Future<void> _resendOtp() async {
    if (AppRuntime.usesRealApi) {
      await AppRuntime.auth.resendOtp(_mobileController.text);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 0 : 24,
                  vertical: 24,
                ),
                child: isTablet
                    ? _buildTabletLayout(theme)
                    : _buildPhoneLayout(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneLayout(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const LoginLogoWidget(),
          const SizedBox(height: 32),
          LoginFormWidget(
            mobileController: _mobileController,
            isLoading: _isLoading,
            onSendOtp: _sendOtp,
          ),
          if (!AppRuntime.usesRealApi) ...[
            const SizedBox(height: 24),
            _buildMockCredentialBox(),
          ],
          const SizedBox(height: 16),
          const LoginFooterWidget(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Center(
      child: SizedBox(
        width: 480,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginLogoWidget(),
                const SizedBox(height: 32),
                LoginFormWidget(
                  mobileController: _mobileController,
                  isLoading: _isLoading,
                  onSendOtp: _sendOtp,
                ),
                if (!AppRuntime.usesRealApi) ...[
                  const SizedBox(height: 24),
                  _buildMockCredentialBox(),
                ],
                const SizedBox(height: 16),
                const LoginFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMockCredentialBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Demo साठी वापरा / Use for Demo',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _credentialRow('मोबाइल / Mobile:', '9876543210'),
          const SizedBox(height: 4),
          _credentialRow('OTP:', MockData.mockOtp),
        ],
      ),
    );
  }

  Widget _credentialRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: AppTheme.primaryDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppTheme.primaryDark,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$value कॉपी केले'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          child: const Icon(
            Icons.copy_rounded,
            size: 14,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}
