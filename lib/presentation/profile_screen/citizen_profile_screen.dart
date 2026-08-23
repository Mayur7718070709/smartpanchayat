import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_runtime.dart';
import '../../core/citizens/citizen_profile.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';

class CitizenProfileScreen extends StatefulWidget {
  const CitizenProfileScreen({super.key});

  @override
  State<CitizenProfileScreen> createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends State<CitizenProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  Object? _loadError;
  CitizenProfile? _profile;

  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _addressController;
  late TextEditingController _villageController;
  late TextEditingController _talukaController;
  late TextEditingController _districtController;
  late TextEditingController _pincodeController;
  late TextEditingController _wardController;
  late TextEditingController _wardNoController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profile = MockData.citizenProfile;
    _nameController = TextEditingController(text: profile['name'] as String);
    _mobileController = TextEditingController(
      text: profile['mobile'] as String,
    );
    _emailController = TextEditingController(text: 'mayur.patil@example.com');
    _dobController = TextEditingController(text: '15/08/1990');
    _genderController = TextEditingController(text: 'पुरुष / Male');
    _addressController = TextEditingController(text: 'मु. नेर्ले, पो. नेर्ले');
    _villageController = TextEditingController(text: 'नेर्ले');
    _talukaController = TextEditingController(
      text: profile['taluka'] as String,
    );
    _districtController = TextEditingController(
      text: profile['district'] as String,
    );
    _pincodeController = TextEditingController(text: '415019');
    _wardController = TextEditingController(text: 'वार्ड क्र. ३ / Ward No. 3');
    _wardNoController = TextEditingController(text: '3');
    if (AppRuntime.usesRealApi) {
      for (final controller in [
        _nameController,
        _mobileController,
        _emailController,
        _dobController,
        _genderController,
        _addressController,
        _villageController,
        _talukaController,
        _districtController,
        _pincodeController,
        _wardController,
        _wardNoController,
      ]) {
        controller.clear();
      }
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final profile = await AppRuntime.citizenProfile.fetch();
      if (!mounted) return;
      _profile = profile;
      _nameController.text = profile.fullName;
      _mobileController.text = AppRuntime.auth.currentUserPhone ?? '';
      _emailController.text = AppRuntime.auth.currentUserEmail ?? '';
      _dobController.text = _formatDate(profile.dateOfBirth);
      _genderController.text = profile.gender ?? '';
      _addressController.text = profile.address ?? '';
      _wardController.text = profile.ward ?? '';
      _wardNoController.text = profile.ward ?? '';
    } catch (error) {
      if (!mounted) return;
      _loadError = error;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime? value) => value == null
      ? ''
      : '${value.day.toString().padLeft(2, '0')}/'
            '${value.month.toString().padLeft(2, '0')}/${value.year}';

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _villageController.dispose();
    _talukaController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    _wardController.dispose();
    _wardNoController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (AppRuntime.usesRealApi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updates are not available yet.')),
      );
      return;
    }
    if (_isEditing) {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'प्रोफाइल अपडेट केली / Profile updated',
              style: GoogleFonts.notoSans(fontSize: 13, color: Colors.white),
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else {
      setState(() => _isEditing = true);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'लॉगआउट / Logout',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'तुम्हाला खरोखर लॉगआउट करायचे आहे का?\nAre you sure you want to logout?',
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'रद्द करा / Cancel',
              style: GoogleFonts.notoSans(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (AppRuntime.usesRealApi) {
                await AppRuntime.auth.signOut();
                if (!mounted) return;
              }
              context.go(AppRoutes.loginScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'लॉगआउट',
              style: GoogleFonts.notoSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'भाषा निवडा / Select Language',
              style: GoogleFonts.notoSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _languageOption('मराठी', 'Marathi', true),
            _languageOption('English', 'English', false),
            _languageOption('हिंदी', 'Hindi', false),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String label, String sublabel, bool selected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryContainer
              : AppTheme.surfaceVariantLight,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.language_rounded,
          color: selected ? AppTheme.primary : AppTheme.textSecondary,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: GoogleFonts.notoSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        sublabel,
        style: GoogleFonts.notoSans(
          fontSize: 12,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: AppTheme.primary)
          : null,
      onTap: () => Navigator.pop(context),
    );
  }

  void _showInfoSheet(String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.outlineLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: Text(
                    content,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (AppRuntime.usesRealApi && _isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (AppRuntime.usesRealApi && _loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Citizen Profile')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unable to load citizen profile.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    final profile = AppRuntime.usesRealApi
        ? <String, dynamic>{
            'name': _profile?.fullName ?? '',
            'mobile': AppRuntime.auth.currentUserPhone ?? '',
            'panchayatName': '—',
          }
        : MockData.citizenProfile;
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(profile),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildSectionHeader(
                    'व्यक्तिगत माहिती',
                    'Personal Information',
                    Icons.person_outline_rounded,
                  ),
                  _buildPersonalInfoCard(),
                  const SizedBox(height: 16),
                  _buildSectionHeader(
                    'पत्ता',
                    'Address',
                    Icons.location_on_outlined,
                  ),
                  _buildAddressCard(),
                  const SizedBox(height: 16),
                  _buildSectionHeader('वार्ड', 'Ward', Icons.map_outlined),
                  _buildWardCard(),
                  const SizedBox(height: 16),
                  _buildSettingsList(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> profile) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      actions: [
        TextButton.icon(
          onPressed: _toggleEdit,
          icon: Icon(
            _isEditing ? Icons.check_rounded : Icons.edit_rounded,
            size: 18,
            color: Colors.white,
          ),
          label: Text(
            _isEditing ? 'जतन करा' : 'संपादित करा',
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryDark,
                AppTheme.primary,
                AppTheme.primaryLight,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        color: AppTheme.primaryContainer,
                      ),
                      child: ClipOval(
                        child: AppRuntime.usesRealApi
                            ? const Icon(
                                Icons.person_rounded,
                                size: 40,
                                color: AppTheme.primary,
                              )
                            : Image.network(
                                'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=200',
                                fit: BoxFit.cover,
                                semanticLabel: 'Citizen profile photo',
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person_rounded,
                                  size: 40,
                                  color: AppTheme.primary,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  profile['name'] as String,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone_rounded,
                      size: 13,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppRuntime.usesRealApi
                          ? profile['mobile'] as String
                          : '+91 ${profile['mobile']}',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.account_balance_rounded,
                      size: 13,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile['panchayatName'] as String,
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String marathi, String english, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(
            marathi,
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '/ $english',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildField(
            'नाव / Name',
            _nameController,
            Icons.person_outline_rounded,
            editable: true,
          ),
          _buildDivider(),
          _buildField(
            'मोबाइल / Mobile',
            _mobileController,
            Icons.phone_outlined,
            editable: false,
            hint: 'Read only',
          ),
          _buildDivider(),
          _buildField(
            'ईमेल / Email',
            _emailController,
            Icons.email_outlined,
            editable: true,
          ),
          _buildDivider(),
          _buildField(
            'जन्मतारीख / Date of Birth',
            _dobController,
            Icons.cake_outlined,
            editable: true,
          ),
          _buildDivider(),
          _buildField(
            'लिंग / Gender',
            _genderController,
            Icons.wc_rounded,
            editable: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildField(
            'पत्ता / Address',
            _addressController,
            Icons.home_outlined,
            editable: true,
          ),
          _buildDivider(),
          _buildField(
            'गाव / Village',
            _villageController,
            Icons.location_city_outlined,
            editable: true,
          ),
          _buildDivider(),
          _buildField(
            'तालुका / Taluka',
            _talukaController,
            Icons.map_outlined,
            editable: false,
          ),
          _buildDivider(),
          _buildField(
            'जिल्हा / District',
            _districtController,
            Icons.account_balance_outlined,
            editable: false,
          ),
          _buildDivider(),
          _buildField(
            'पिनकोड / Pincode',
            _pincodeController,
            Icons.pin_drop_outlined,
            editable: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWardCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildField(
            'वार्ड / Ward',
            _wardController,
            Icons.grid_view_rounded,
            editable: false,
          ),
          _buildDivider(),
          _buildField(
            'वार्ड क्रमांक / Ward Number',
            _wardNoController,
            Icons.tag_rounded,
            editable: false,
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool editable = true,
    String? hint,
  }) {
    final canEdit = _isEditing && editable;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: canEdit ? AppTheme.primary : AppTheme.textTertiary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppTheme.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                canEdit
                    ? TextFormField(
                        controller: controller,
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          border: const UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppTheme.primary,
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppTheme.outlineLight,
                            ),
                          ),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'आवश्यक आहे' : null,
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.text,
                              style: GoogleFonts.notoSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!editable && hint == null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Fixed',
                                style: GoogleFonts.notoSans(
                                  fontSize: 10,
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ),
                          if (hint != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.infoContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                hint,
                                style: GoogleFonts.notoSans(
                                  fontSize: 10,
                                  color: AppTheme.info,
                                ),
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

  Widget _buildDivider() =>
      Divider(height: 1, color: AppTheme.dividerLight, indent: 46);

  Widget _buildSettingsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            Icons.report_problem_outlined,
            AppTheme.warning,
            'माझ्या तक्रारी',
            'My Complaints',
            () => context.go(AppRoutes.complaintsScreen),
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.miscellaneous_services_outlined,
            AppTheme.primary,
            'माझ्या सेवा विनंत्या',
            'My Service Requests',
            () => context.push(AppRoutes.serviceRequestsScreen),
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.payment_rounded,
            AppTheme.success,
            'पेमेंट इतिहास',
            'Payment History',
            () => context.push(AppRoutes.paymentHistoryScreen),
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.notifications_outlined,
            AppTheme.info,
            'सूचना',
            'Notifications',
            () => context.go(AppRoutes.notificationsScreen),
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.language_rounded,
            AppTheme.secondary,
            'भाषा',
            'Language',
            _showLanguageSheet,
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.help_outline_rounded,
            AppTheme.accent,
            'मदत आणि समर्थन',
            'Help & Support',
            () => _showInfoSheet(
              'मदत आणि समर्थन / Help & Support',
              'तांत्रिक समस्यांसाठी किंवा अधिक माहितीसाठी कृपया ग्रामपंचायत कार्यालयाशी संपर्क साधा.\n\nFor technical issues or more information, please contact your Gram Panchayat office.\n\nहेल्पलाइन / Helpline: 1800-XXX-XXXX\nईमेल / Email: support@smartpanchayat.gov.in\nवेळ / Hours: सोमवार–शुक्रवार, सकाळी ९ – सायंकाळी ५',
            ),
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.privacy_tip_outlined,
            AppTheme.primaryDark,
            'गोपनीयता धोरण',
            'Privacy Policy',
            () => _showInfoSheet(
              'गोपनीयता धोरण / Privacy Policy',
              'Smart Panchayat आपल्या वैयक्तिक माहितीचे संरक्षण करण्यासाठी वचनबद्ध आहे. आपली माहिती फक्त ग्रामपंचायत सेवा पुरवण्यासाठी वापरली जाते आणि तृतीय पक्षाशी शेअर केली जात नाही.\n\nSmart Panchayat is committed to protecting your personal information. Your data is used only for providing Gram Panchayat services and is not shared with third parties.\n\nआपल्याला आपली माहिती हटवण्याचा अधिकार आहे. अधिक माहितीसाठी ग्रामपंचायत कार्यालयाशी संपर्क साधा.',
            ),
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.description_outlined,
            AppTheme.textSecondary,
            'अटी व शर्ती',
            'Terms & Conditions',
            () => _showInfoSheet(
              'अटी व शर्ती / Terms & Conditions',
              'Smart Panchayat वापरण्याच्या अटी:\n\n१. हे अॅप फक्त नोंदणीकृत नागरिकांसाठी आहे.\n२. खोटी माहिती देणे कायद्याने दंडनीय आहे.\n३. आपले खाते सुरक्षित ठेवण्याची जबाबदारी आपली आहे.\n४. ग्रामपंचायत कोणत्याही वेळी सेवा बंद करण्याचा अधिकार राखून ठेवते.\n\nTerms of use for Smart Panchayat:\n1. This app is for registered citizens only.\n2. Providing false information is punishable by law.\n3. You are responsible for keeping your account secure.\n4. The Gram Panchayat reserves the right to discontinue services at any time.',
            ),
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.logout_rounded,
            AppTheme.error,
            'लॉगआउट',
            'Logout',
            _showLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    Color color,
    String marathi,
    String english,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withAlpha(31),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    marathi,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? AppTheme.error
                          : AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    english,
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppTheme.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
