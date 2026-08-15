import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/service_model.dart';
import '../../theme/app_theme.dart';
import './application_review_screen.dart';

class ApplicationFormScreen extends StatefulWidget {
  final ServiceModel service;

  const ApplicationFormScreen({required this.service, super.key});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};
  final Map<String, String?> _uploadedFiles = {};
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'अर्ज फॉर्म',
              style: GoogleFonts.notoSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              widget.service.nameEn,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildServiceHeader(),
            const SizedBox(height: 16),
            _buildFormFields(),
            const SizedBox(height: 16),
            _buildTermsCheckbox(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildServiceHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.service.color.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.service.color.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.service.color.withAlpha(31),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.service.icon,
              color: widget.service.color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.nameMr,
                  style: GoogleFonts.notoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  widget.service.nameEn,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (widget.service.fee > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.accentContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '₹${widget.service.fee.toStringAsFixed(0)}',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    if (widget.service.formFields.isEmpty) {
      return _buildDefaultFormFields();
    }
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
          Text(
            'अर्जाचा तपशील / Application Details',
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.service.formFields.asMap().entries.map((entry) {
            final field = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildDynamicField(field),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDefaultFormFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildTextField(
            id: 'full_name',
            labelMr: 'पूर्ण नाव',
            labelEn: 'Full Name',
            required: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            id: 'contact',
            labelMr: 'संपर्क क्रमांक',
            labelEn: 'Contact Number',
            required: true,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicField(ServiceFormField field) {
    switch (field.type) {
      case 'text':
        return _buildTextField(
          id: field.id,
          labelMr: field.labelMr,
          labelEn: field.labelEn,
          required: field.required,
          hint: field.hint,
        );
      case 'number':
        return _buildTextField(
          id: field.id,
          labelMr: field.labelMr,
          labelEn: field.labelEn,
          required: field.required,
          keyboardType: TextInputType.number,
        );
      case 'date':
        return _buildDateField(field);
      case 'dropdown':
        return _buildDropdownField(field);
      case 'radio':
        return _buildRadioField(field);
      case 'checkbox':
        return _buildCheckboxField(field);
      case 'document':
        return _buildUploadField(field, isPhoto: false);
      case 'photo':
        return _buildUploadField(field, isPhoto: true);
      default:
        return _buildTextField(
          id: field.id,
          labelMr: field.labelMr,
          labelEn: field.labelEn,
          required: field.required,
        );
    }
  }

  Widget _buildTextField({
    required String id,
    required String labelMr,
    required String labelEn,
    bool required = true,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(labelMr: labelMr, labelEn: labelEn, required: required),
        const SizedBox(height: 6),
        TextFormField(
          keyboardType: keyboardType,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
          decoration: _inputDecoration(hint ?? labelEn),
          validator: required
              ? (v) => (v == null || v.trim().isEmpty)
                    ? '$labelEn is required'
                    : null
              : null,
          onSaved: (v) => _formValues[id] = v?.trim() ?? '',
          onChanged: (v) => _formValues[id] = v.trim(),
        ),
      ],
    );
  }

  Widget _buildDateField(ServiceFormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          labelMr: field.labelMr,
          labelEn: field.labelEn,
          required: field.required,
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: ColorScheme.light(primary: widget.service.color),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              setState(() {
                _formValues[field.id] =
                    '${picked.day}/${picked.month}/${picked.year}';
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.outlineLight),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(width: 10),
                Text(
                  _formValues[field.id] as String? ??
                      'तारीख निवडा / Select Date',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: _formValues[field.id] != null
                        ? AppTheme.textPrimary
                        : AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(ServiceFormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          labelMr: field.labelMr,
          labelEn: field.labelEn,
          required: field.required,
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _formValues[field.id] as String?,
          decoration: _inputDecoration('निवडा / Select'),
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
          items: field.options
              .map(
                (opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(opt, style: GoogleFonts.notoSans(fontSize: 14)),
                ),
              )
              .toList(),
          validator: field.required
              ? (v) => v == null ? '${field.labelEn} is required' : null
              : null,
          onChanged: (v) => setState(() => _formValues[field.id] = v),
          onSaved: (v) => _formValues[field.id] = v ?? '',
        ),
      ],
    );
  }

  Widget _buildRadioField(ServiceFormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          labelMr: field.labelMr,
          labelEn: field.labelEn,
          required: field.required,
        ),
        const SizedBox(height: 8),
        ...field.options.map(
          (opt) => RadioListTile<String>(
            value: opt,
            groupValue: _formValues[field.id] as String?,
            title: Text(
              opt,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
            activeColor: widget.service.color,
            contentPadding: EdgeInsets.zero,
            dense: true,
            onChanged: (v) => setState(() => _formValues[field.id] = v),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxField(ServiceFormField field) {
    final selected = (_formValues[field.id] as List<String>?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          labelMr: field.labelMr,
          labelEn: field.labelEn,
          required: field.required,
        ),
        const SizedBox(height: 8),
        ...field.options.map((opt) {
          final isChecked = selected.contains(opt);
          return CheckboxListTile(
            value: isChecked,
            title: Text(
              opt,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
            activeColor: widget.service.color,
            contentPadding: EdgeInsets.zero,
            dense: true,
            onChanged: (v) {
              setState(() {
                final list = List<String>.from(selected);
                v == true ? list.add(opt) : list.remove(opt);
                _formValues[field.id] = list;
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildUploadField(ServiceFormField field, {required bool isPhoto}) {
    final uploaded = _uploadedFiles[field.id];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          labelMr: field.labelMr,
          labelEn: field.labelEn,
          required: field.required,
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _uploadedFiles[field.id] = isPhoto
                  ? 'photo_${field.id}.jpg'
                  : 'document_${field.id}.pdf';
              _formValues[field.id] = _uploadedFiles[field.id];
            });
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: uploaded != null
                  ? AppTheme.successContainer
                  : AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: uploaded != null
                    ? AppTheme.success
                    : AppTheme.outlineLight,
                style: uploaded != null ? BorderStyle.solid : BorderStyle.solid,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  uploaded != null
                      ? Icons.check_circle_rounded
                      : (isPhoto
                            ? Icons.add_a_photo_outlined
                            : Icons.upload_file_outlined),
                  size: 22,
                  color: uploaded != null
                      ? AppTheme.success
                      : AppTheme.textTertiary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    uploaded ??
                        (isPhoto
                            ? 'फोटो अपलोड करा / Upload Photo'
                            : 'कागदपत्र अपलोड करा / Upload Document'),
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: uploaded != null
                          ? AppTheme.success
                          : AppTheme.textTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (uploaded != null)
                  GestureDetector(
                    onTap: () => setState(() {
                      _uploadedFiles.remove(field.id);
                      _formValues.remove(field.id);
                    }),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppTheme.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariantLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _agreedToTerms,
            activeColor: widget.service.color,
            onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'मी वरील माहिती सत्य असल्याचे प्रमाणित करतो/करते.\nI certify that the above information is true and correct.',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
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
            if (!_agreedToTerms) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'कृपया अटी व शर्ती मान्य करा / Please agree to terms',
                    style: GoogleFonts.notoSans(fontSize: 13),
                  ),
                  backgroundColor: AppTheme.warning,
                ),
              );
              return;
            }
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ApplicationReviewScreen(
                    service: widget.service,
                    formValues: Map<String, dynamic>.from(_formValues),
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.service.color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            'पुढे जा / Continue',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.notoSans(
        fontSize: 13,
        color: AppTheme.textTertiary,
      ),
      filled: true,
      fillColor: AppTheme.surfaceVariantLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.outlineLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.outlineLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: widget.service.color, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.error),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String labelMr;
  final String labelEn;
  final bool required;

  const _FieldLabel({
    required this.labelMr,
    required this.labelEn,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$labelMr / $labelEn',
          style: GoogleFonts.notoSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        if (required)
          Text(
            ' *',
            style: GoogleFonts.notoSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.error,
            ),
          ),
      ],
    );
  }
}
