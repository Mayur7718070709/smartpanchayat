import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating;
  final int maxRating;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<int>? onRatingChanged;
  final bool readOnly;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.starSize = 36.0,
    this.activeColor = const Color(0xFFF59E0B),
    this.inactiveColor = const Color(0xFFCBD5E1),
    this.onRatingChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: readOnly ? null : () => onRatingChanged?.call(starIndex),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                starIndex <= rating
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                key: ValueKey('star_${starIndex}_${starIndex <= rating}'),
                size: starSize,
                color: starIndex <= rating ? activeColor : inactiveColor,
              ),
            ),
          ),
        );
      }),
    );
  }
}

String getRatingLabel(int rating) {
  switch (rating) {
    case 1:
      return 'खूप वाईट / Very Poor';
    case 2:
      return 'वाईट / Poor';
    case 3:
      return 'ठीक / Average';
    case 4:
      return 'चांगले / Good';
    case 5:
      return 'उत्कृष्ट / Excellent';
    default:
      return '';
  }
}

Color getRatingColor(int rating) {
  switch (rating) {
    case 1:
      return AppTheme.error;
    case 2:
      return AppTheme.warning;
    case 3:
      return AppTheme.accent;
    case 4:
      return AppTheme.secondary;
    case 5:
      return AppTheme.success;
    default:
      return AppTheme.textTertiary;
  }
}
