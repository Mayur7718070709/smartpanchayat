import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../core/app_runtime.dart';
import '../../widgets/star_rating_widget.dart';
import './feedback_thank_you_screen.dart';
import './feedback_availability_screen.dart';

class FeedbackCategory {
  final String id;
  final String marathi;
  final String english;
  final IconData icon;

  const FeedbackCategory({
    required this.id,
    required this.marathi,
    required this.english,
    required this.icon,
  });
}

const List<FeedbackCategory> feedbackCategories = [
  FeedbackCategory(
    id: 'service_quality',
    marathi: 'सेवा गुणवत्ता',
    english: 'Service Quality',
    icon: Icons.star_half_rounded,
  ),
  FeedbackCategory(
    id: 'response_time',
    marathi: 'प्रतिसाद वेळ',
    english: 'Response Time',
    icon: Icons.timer_outlined,
  ),
  FeedbackCategory(
    id: 'staff_support',
    marathi: 'कर्मचारी सहाय्य',
    english: 'Staff Support',
    icon: Icons.support_agent_rounded,
  ),
  FeedbackCategory(
    id: 'overall_experience',
    marathi: 'एकूण अनुभव',
    english: 'Overall Experience',
    icon: Icons.thumb_up_outlined,
  ),
];

class FeedbackScreen extends StatefulWidget {
  final String? serviceTitle;
  final String? requestId;
  final String? serviceType;

  const FeedbackScreen({
    super.key,
    this.serviceTitle,
    this.requestId,
    this.serviceType,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final Map<String, int> _categoryRatings = {
    'service_quality': 0,
    'response_time': 0,
    'staff_support': 0,
    'overall_experience': 0,
  };
  int _overallRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _overallRating > 0;

  Future<void> _submitFeedback() async {
    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'कृपया एकूण रेटिंग द्या / Please give an overall rating',
            style: GoogleFonts.notoSans(fontSize: 13, color: Colors.white),
          ),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const FeedbackThankYouScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (AppRuntime.usesRealApi) {
      return const FeedbackAvailabilityScreen();
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'अभिप्राय द्या',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Submit Feedback',
              style: GoogleFonts.notoSans(
                fontSize: 11,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.serviceTitle != null) _buildServiceBanner(),
                  _buildOverallRatingCard(),
                  const SizedBox(height: 16),
                  _buildCategoryRatingsCard(),
                  const SizedBox(height: 16),
                  _buildCommentCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildServiceBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.serviceTitle ?? '',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.requestId != null)
                  Text(
                    'Request ID: ${widget.requestId}',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: AppTheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRatingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'तुमचा अनुभव कसा होता?',
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'How was your experience?',
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          StarRatingWidget(
            rating: _overallRating,
            starSize: 44,
            onRatingChanged: (r) => setState(() => _overallRating = r),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _overallRating > 0
                ? Container(
                    key: ValueKey(_overallRating),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: getRatingColor(_overallRating).withAlpha(31),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getRatingLabel(_overallRating),
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: getRatingColor(_overallRating),
                      ),
                    ),
                  )
                : Text(
                    'वर तारे टॅप करा / Tap stars above',
                    key: const ValueKey('empty'),
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRatingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'श्रेणीनुसार रेटिंग',
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            'Rate by Category (Optional)',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ...feedbackCategories.map((cat) => _buildCategoryRow(cat)),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(FeedbackCategory cat) {
    final rating = _categoryRatings[cat.id] ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(cat.icon, size: 18, color: AppTheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.marathi,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  cat.english,
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          StarRatingWidget(
            rating: rating,
            starSize: 22,
            onRatingChanged: (r) =>
                setState(() => _categoryRatings[cat.id] = r),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'टिप्पणी (ऐच्छिक)',
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            'Comment (Optional)',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 4,
            maxLength: 300,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:
                  'आपला अनुभव येथे लिहा...\nWrite your experience here...',
              hintStyle: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppTheme.textTertiary,
              ),
              filled: true,
              fillColor: AppTheme.surfaceVariantLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitFeedback,
          style: ElevatedButton.styleFrom(
            backgroundColor: _canSubmit
                ? AppTheme.primary
                : AppTheme.outlineLight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'अभिप्राय सबमिट करा / Submit Feedback',
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
