import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _wardController = TextEditingController();
  bool _isLoading = false;
  bool _hasProfilePhoto = false;

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
    _nameController.dispose();
    _addressController.dispose();
    _wardController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Mock save — replace with real persistence
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(AppRoutes.panchayatConfirmationScreen);
  }

  void _pickPhoto() {
    // Mock photo selection — shows a snackbar for demo
    setState(() => _hasProfilePhoto = !_hasProfilePhoto);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _hasProfilePhoto
              ? 'फोटो निवडला / Photo selected (Demo)'
              : 'फोटो काढला / Photo removed',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppTheme.secondary,
      ),
    );
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildProfilePhotoSection(),
                    const SizedBox(height: 28),
                    _buildFormFields(),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'पायरी ३ / Step 3 of 5',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondary,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'प्रोफाइल सेट करा',
          style: GoogleFonts.notoSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Setup Your Profile',
          style: GoogleFonts.notoSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'तुमची माहिती भरा. ही माहिती ग्रामपंचायत सेवांसाठी वापरली जाईल.',
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppTheme.textTertiary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePhotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickPhoto,
            child: Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hasProfilePhoto
                        ? AppTheme.primaryContainer
                        : AppTheme.surfaceVariantLight,
                    border: Border.all(
                      color: _hasProfilePhoto
                          ? AppTheme.primary
                          : AppTheme.outlineLight,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _hasProfilePhoto
                      ? ClipOval(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
                            fit: BoxFit.cover,
                            semanticLabel:
                                'Profile photo of a person with neutral expression',
                          ),
                        )
                      : const Icon(
                          Icons.person_rounded,
                          size: 44,
                          color: AppTheme.textTertiary,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _hasProfilePhoto
                ? 'फोटो बदला / Change Photo'
                : 'फोटो जोडा (ऐच्छिक) / Add Photo (Optional)',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('पूर्ण नाव *', 'Full Name *'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _nameController,
          hint: 'उदा. राजेश कुमार पाटील',
          hintEn: 'e.g. Rajesh Kumar Patil',
          icon: Icons.person_outline_rounded,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'कृपया पूर्ण नाव टाका / Please enter full name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildFieldLabel('पत्ता *', 'Address *'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _addressController,
          hint: 'उदा. मु. पो. नेर्ले, ता. वेल्हे',
          hintEn: 'e.g. Village, Taluka, District',
          icon: Icons.location_on_outlined,
          maxLines: 2,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'कृपया पत्ता टाका / Please enter address';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildFieldLabel('वार्ड *', 'Ward *'),
        const SizedBox(height: 8),
        _buildWardDropdown(),
      ],
    );
  }

  Widget _buildFieldLabel(String marathi, String english) {
    return Row(
      children: [
        Text(
          marathi,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '/ $english',
          style: GoogleFonts.notoSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String hintEn,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.notoSans(fontSize: 15, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: '$hint\n$hintEn',
        hintStyle: GoogleFonts.notoSans(
          fontSize: 13,
          color: AppTheme.textTertiary,
          height: 1.5,
        ),
        prefixIcon: Icon(icon, color: AppTheme.textTertiary, size: 20),
        filled: true,
        fillColor: AppTheme.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.outlineLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error, width: 2),
        ),
      ),
    );
  }

  Widget _buildWardDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _wardController.text.isEmpty ? null : _wardController.text,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'कृपया वार्ड निवडा / Please select ward';
        }
        return null;
      },
      onChanged: (val) {
        if (val != null) _wardController.text = val;
      },
      style: GoogleFonts.notoSans(fontSize: 15, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: 'वार्ड निवडा / Select Ward',
        hintStyle: GoogleFonts.notoSans(
          fontSize: 13,
          color: AppTheme.textTertiary,
        ),
        prefixIcon: const Icon(
          Icons.map_outlined,
          color: AppTheme.textTertiary,
          size: 20,
        ),
        filled: true,
        fillColor: AppTheme.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.outlineLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
      ),
      items:
          [
                'वार्ड १ / Ward 1',
                'वार्ड २ / Ward 2',
                'वार्ड ३ / Ward 3',
                'वार्ड ४ / Ward 4',
                'वार्ड ५ / Ward 5',
                'वार्ड ६ / Ward 6',
                'वार्ड ७ / Ward 7',
              ]
              .map(
                (w) => DropdownMenuItem(
                  value: w,
                  child: Text(
                    w,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
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
                  Text(
                    'पुढे जा / Continue',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final isActive = i == 2; // Step 3 (0-indexed)
        final isDone = i < 2;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primary
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
