import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_runtime.dart';
import '../../models/complaint_model.dart';
import '../../theme/app_theme.dart';
import './complaint_submitted_screen.dart';

class CreateComplaintScreen extends StatefulWidget {
  const CreateComplaintScreen({super.key});

  @override
  State<CreateComplaintScreen> createState() => _CreateComplaintScreenState();
}

class _CreateComplaintScreenState extends State<CreateComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  ComplaintCategory? _selectedCategory;
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  bool _hasPhoto = false;
  XFile? _photo;
  bool _isSubmitting = false;

  static const List<ComplaintCategory> _categories = ComplaintCategory.values;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'कृपया तक्रारीची श्रेणी निवडा / Please select a category',
            style: GoogleFonts.notoSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    ComplaintModel? created;
    try {
      if (AppRuntime.usesRealApi) {
        created = await AppRuntime.complaints.create(
          category: _selectedCategory!,
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          idempotencyKey: _newUuid(),
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 1200));
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaint could not be submitted. Please try again.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    if (created != null && _photo != null) {
      try {
        final bytes = await _photo!.readAsBytes();
        final mime = _photo!.name.toLowerCase().endsWith('.png')
            ? 'image/png'
            : 'image/jpeg';
        await AppRuntime.complaints.uploadAttachment(created.id, bytes, mime);
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Complaint saved, but the photo could not be uploaded.',
            ),
            backgroundColor: AppTheme.warning,
          ),
        );
      }
    }

    if (!mounted) return;

    final complaintId =
        created?.complaintId ??
        'CMP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ComplaintSubmittedScreen(
          recordId: created?.id,
          complaintId: complaintId,
          category: _selectedCategory!,
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
        ),
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
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  @override
  Widget build(BuildContext context) {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'नवीन तक्रार',
              style: GoogleFonts.notoSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'New Complaint',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel(
                      'श्रेणी निवडा',
                      'Select Category',
                      isRequired: true,
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryGrid(),
                    const SizedBox(height: 20),
                    _buildSectionLabel(
                      'तक्रारीचे वर्णन',
                      'Description',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    _buildDescriptionField(),
                    const SizedBox(height: 20),
                    _buildSectionLabel(
                      'फोटो जोडा',
                      'Add Photo',
                      isRequired: false,
                    ),
                    const SizedBox(height: 8),
                    _buildPhotoUpload(),
                    const SizedBox(height: 20),
                    _buildSectionLabel(
                      'स्थान (पर्यायी)',
                      'Location (Optional)',
                      isRequired: false,
                    ),
                    const SizedBox(height: 8),
                    _buildLocationField(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String mr, String en, {required bool isRequired}) {
    return Row(
      children: [
        Text(
          mr,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '/ $en',
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppTheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? cat.color.withAlpha(26)
                  : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? cat.color : AppTheme.outlineLight,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: cat.color.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : const [
                      BoxShadow(
                        color: Color(0x08000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cat.icon,
                  color: isSelected ? cat.color : AppTheme.textSecondary,
                  size: 26,
                ),
                const SizedBox(height: 6),
                Text(
                  cat.labelEn,
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? cat.color : AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      maxLength: 500,
      style: GoogleFonts.notoSans(fontSize: 14, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText:
            'तक्रारीचे तपशीलवार वर्णन लिहा...\nDescribe your complaint in detail...',
        hintStyle: GoogleFonts.notoSans(
          fontSize: 13,
          color: AppTheme.textTertiary,
        ),
        filled: true,
        fillColor: AppTheme.surfaceLight,
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
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'कृपया तक्रारीचे वर्णन लिहा / Please enter description';
        }
        if (v.trim().length < 10) {
          return 'किमान 10 अक्षरे लिहा / Minimum 10 characters required';
        }
        return null;
      },
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: () async {
        if (_photo != null) {
          setState(() {
            _photo = null;
            _hasPhoto = false;
          });
        } else {
          final selected = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
            maxWidth: 1920,
          );
          if (selected == null || !mounted) return;
          setState(() {
            _photo = selected;
            _hasPhoto = true;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _hasPhoto
                  ? 'फोटो जोडला / Photo added'
                  : 'फोटो काढला / Photo removed',
              style: GoogleFonts.notoSans(fontSize: 13),
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: AppTheme.primary,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100,
        decoration: BoxDecoration(
          color: _hasPhoto ? AppTheme.successContainer : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hasPhoto ? AppTheme.success : AppTheme.outlineLight,
            style: BorderStyle.solid,
            width: _hasPhoto ? 2 : 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _hasPhoto
                    ? Icons.check_circle_rounded
                    : Icons.add_a_photo_rounded,
                color: _hasPhoto ? AppTheme.success : AppTheme.textTertiary,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                _hasPhoto
                    ? 'फोटो जोडला ✓ / Photo Added ✓'
                    : 'फोटो जोडण्यासाठी टॅप करा\nTap to add photo',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: _hasPhoto ? AppTheme.success : AppTheme.textTertiary,
                  fontWeight: _hasPhoto ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      style: GoogleFonts.notoSans(fontSize: 14, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: 'स्थानाचे वर्णन लिहा... / Enter location...',
        hintStyle: GoogleFonts.notoSans(
          fontSize: 13,
          color: AppTheme.textTertiary,
        ),
        prefixIcon: const Icon(
          Icons.location_on_rounded,
          color: AppTheme.textTertiary,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.my_location_rounded,
            color: AppTheme.primary,
            size: 20,
          ),
          onPressed: () {
            _locationController.text = 'नेर्ले गाव, वेल्हे तालुका, सांगली';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'स्थान मिळाले / Location detected',
                  style: GoogleFonts.notoSans(fontSize: 13),
                ),
                duration: const Duration(seconds: 1),
                backgroundColor: AppTheme.success,
              ),
            );
          },
        ),
        filled: true,
        fillColor: AppTheme.surfaceLight,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitComplaint,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.onPrimary,
            disabledBackgroundColor: AppTheme.primaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: _isSubmitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'सादर होत आहे... / Submitting...',
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  'तक्रार सादर करा / Submit Complaint',
                  style: GoogleFonts.notoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
