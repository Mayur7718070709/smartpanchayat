// ============================================================
// Smart Panchayat Design System — AppTheme
// Mexon Intelligence Pvt. Ltd.
// THEME LOCK: light — civic blue primary, green secondary
// Scaffold.backgroundColor = AppTheme.backgroundLight — ALL screens
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ──────────────────────────────────────────────────────────
  // COLOR TOKENS
  // ──────────────────────────────────────────────────────────

  // Primary — Civic Blue (trustworthy, government-grade)
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF4D7FE8);
  static const Color primaryDark = Color(0xFF0D3B9E);
  static const Color primaryContainer = Color(0xFFDCE8FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF001A6B);

  // Secondary — Village Green (development, nature, public services)
  static const Color secondary = Color(0xFF1B7A3E);
  static const Color secondaryLight = Color(0xFF4CAF72);
  static const Color secondaryDark = Color(0xFF0F5229);
  static const Color secondaryContainer = Color(0xFFCCF0D8);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF00210B);

  // Accent — Saffron (used sparingly for important actions)
  static const Color accent = Color(0xFFFF8100);
  static const Color accentLight = Color(0xFFFFAA4D);
  static const Color accentDark = Color(0xFFCC6600);
  static const Color accentContainer = Color(0xFFFFE8CC);
  static const Color onAccent = Color(0xFFFFFFFF);

  // Semantic — Error
  static const Color error = Color(0xFFB91C1C);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFFE4E4);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  // Semantic — Warning
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color onWarningContainer = Color(0xFF78350F);

  // Semantic — Success
  static const Color success = Color(0xFF15803D);
  static const Color successLight = Color(0xFF22C55E);
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color onSuccessContainer = Color(0xFF14532D);

  // Semantic — Info
  static const Color info = Color(0xFF0369A1);
  static const Color infoContainer = Color(0xFFE0F2FE);
  static const Color onInfoContainer = Color(0xFF0C4A6E);

  // Status Badges
  static const Color statusPending = Color(0xFFD97706);
  static const Color statusInProgress = Color(0xFF1A56DB);
  static const Color statusResolved = Color(0xFF15803D);
  static const Color statusRejected = Color(0xFFB91C1C);
  static const Color statusActive = Color(0xFF1B7A3E);
  static const Color statusInactive = Color(0xFF6B7280);
  static const Color statusNew = Color(0xFF7C3AED);

  // Neutral / Surface
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF3F6FA);
  static const Color surfaceElevated = Color(0xFFF8FAFC);
  static const Color backgroundLight = Color(0xFFEEF2F7);
  static const Color outlineLight = Color(0xFFCBD5E1);
  static const Color outlineVariantLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFE2E8F0);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Dark surfaces
  static const Color surfaceDark = Color(0xFF1E2130);
  static const Color backgroundDark = Color(0xFF12141F);

  // ──────────────────────────────────────────────────────────
  // TYPOGRAPHY SCALE
  // Bilingual: English (Noto Sans) + Marathi/Devanagari (Noto Sans Devanagari)
  // ──────────────────────────────────────────────────────────

  // Display — Hero text, splash screens
  static TextStyle get displayLarge => GoogleFonts.notoSans(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );
  static TextStyle get displayMedium => GoogleFonts.notoSans(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.25,
    letterSpacing: -0.3,
  );
  static TextStyle get displaySmall => GoogleFonts.notoSans(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.3,
  );

  // Heading — Screen titles, section headers
  static TextStyle get headingXL => GoogleFonts.notoSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.3,
  );
  static TextStyle get headingLarge => GoogleFonts.notoSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.35,
  );
  static TextStyle get headingMedium => GoogleFonts.notoSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );
  static TextStyle get headingSmall => GoogleFonts.notoSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  // Section Heading — Card titles, list section headers
  static TextStyle get sectionHeadingLarge => GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.45,
    letterSpacing: 0.1,
  );
  static TextStyle get sectionHeadingMedium => GoogleFonts.notoSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.45,
  );
  static TextStyle get sectionHeadingSmall => GoogleFonts.notoSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.45,
  );

  // Body — Main content text
  static TextStyle get bodyLarge => GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.6,
  );
  static TextStyle get bodyMedium => GoogleFonts.notoSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.6,
  );
  static TextStyle get bodySmall => GoogleFonts.notoSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.55,
  );

  // Caption — Metadata, timestamps, helper text
  static TextStyle get captionLarge => GoogleFonts.notoSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.5,
    letterSpacing: 0.2,
  );
  static TextStyle get captionMedium => GoogleFonts.notoSans(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: textTertiary,
    height: 1.5,
    letterSpacing: 0.2,
  );
  static TextStyle get captionSmall => GoogleFonts.notoSans(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: textTertiary,
    height: 1.5,
    letterSpacing: 0.3,
  );

  // Button — CTA labels
  static TextStyle get buttonLarge => GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textOnDark,
    height: 1.25,
    letterSpacing: 0.3,
  );
  static TextStyle get buttonMedium => GoogleFonts.notoSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textOnDark,
    height: 1.25,
    letterSpacing: 0.2,
  );
  static TextStyle get buttonSmall => GoogleFonts.notoSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textOnDark,
    height: 1.25,
    letterSpacing: 0.2,
  );

  // Label — Form labels, tags, chips
  static TextStyle get labelLarge => GoogleFonts.notoSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );
  static TextStyle get labelMedium => GoogleFonts.notoSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    height: 1.4,
    letterSpacing: 0.2,
  );
  static TextStyle get labelSmall => GoogleFonts.notoSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textTertiary,
    height: 1.4,
    letterSpacing: 0.3,
  );

  // ──────────────────────────────────────────────────────────
  // SPACING TOKENS
  // ──────────────────────────────────────────────────────────
  static const double spacingXXS = 2.0;
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 12.0;
  static const double spacingLG = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;
  static const double spacingHuge = 48.0;

  // ──────────────────────────────────────────────────────────
  // BORDER RADIUS TOKENS
  // ──────────────────────────────────────────────────────────
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusFull = 100.0;

  // ──────────────────────────────────────────────────────────
  // ELEVATION / SHADOW TOKENS
  // ──────────────────────────────────────────────────────────
  static List<BoxShadow> get shadowSM => [
    BoxShadow(
      color: const Color(0xFF0F172A).withAlpha(13),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
  static List<BoxShadow> get shadowMD => [
    BoxShadow(
      color: const Color(0xFF0F172A).withAlpha(18),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withAlpha(8),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  static List<BoxShadow> get shadowLG => [
    BoxShadow(
      color: const Color(0xFF0F172A).withAlpha(20),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withAlpha(10),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  static List<BoxShadow> get shadowPrimary => [
    BoxShadow(
      color: primary.withAlpha(51),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ──────────────────────────────────────────────────────────
  // TOUCH TARGET MINIMUM (Accessibility)
  // ──────────────────────────────────────────────────────────
  static const double minTouchTarget = 48.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightSmall = 40.0;

  // ──────────────────────────────────────────────────────────
  // LIGHT THEME
  // ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: accent,
      onTertiary: onAccent,
      tertiaryContainer: accentContainer,
      surface: surfaceLight,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceVariantLight,
      onSurfaceVariant: textSecondary,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      outline: outlineLight,
      outlineVariant: outlineVariantLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    textTheme: GoogleFonts.notoSansTextTheme().copyWith(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headingXL,
      headlineMedium: headingLarge,
      headlineSmall: headingMedium,
      titleLarge: sectionHeadingLarge,
      titleMedium: sectionHeadingMedium,
      titleSmall: sectionHeadingSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimary,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: const Color(0x1A000000),
      centerTitle: false,
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textPrimary, size: 24),
      actionsIconTheme: const IconThemeData(color: textPrimary, size: 24),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        side: const BorderSide(color: outlineVariantLight, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: surfaceLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: outlineLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: outlineLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.notoSans(
        fontSize: 14,
        color: textSecondary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.notoSans(fontSize: 14, color: textTertiary),
      errorStyle: GoogleFonts.notoSans(fontSize: 12, color: error),
      prefixIconColor: textSecondary,
      suffixIconColor: textSecondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        disabledBackgroundColor: outlineVariantLight,
        disabledForegroundColor: textTertiary,
        minimumSize: const Size(double.infinity, buttonHeightLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        disabledBackgroundColor: outlineVariantLight,
        disabledForegroundColor: textTertiary,
        minimumSize: const Size(double.infinity, buttonHeightLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        elevation: 0,
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        disabledForegroundColor: textTertiary,
        minimumSize: const Size(double.infinity, buttonHeightLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        side: const BorderSide(color: primary, width: 1.5),
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        disabledForegroundColor: textTertiary,
        minimumSize: const Size(0, buttonHeightSmall),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
        ),
        textStyle: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariantLight,
      selectedColor: primaryContainer,
      disabledColor: outlineVariantLight,
      labelStyle: GoogleFonts.notoSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusFull),
      ),
      side: const BorderSide(color: outlineVariantLight),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLight,
      indicatorColor: primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.notoSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: primary,
          );
        }
        return GoogleFonts.notoSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primary, size: 24);
        }
        return const IconThemeData(color: textSecondary, size: 24);
      }),
      elevation: 8,
      shadowColor: const Color(0x1A000000),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 72,
    ),
    dividerTheme: const DividerThemeData(
      color: dividerLight,
      thickness: 1,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1E293B),
      contentTextStyle: GoogleFonts.notoSans(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSM),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceLight,
      elevation: 8,
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXL),
      ),
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      contentTextStyle: GoogleFonts.notoSans(
        fontSize: 14,
        color: textSecondary,
        height: 1.6,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceLight,
      elevation: 16,
      shadowColor: Color(0x33000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXXL)),
      ),
      showDragHandle: true,
      dragHandleColor: outlineLight,
      dragHandleSize: Size(40, 4),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: primaryContainer,
      circularTrackColor: primaryContainer,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return onPrimary;
        return textTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        return outlineVariantLight;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimary),
      side: const BorderSide(color: outlineLight, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        return outlineLight;
      }),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minLeadingWidth: 24,
      minVerticalPadding: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMD),
      ),
      titleTextStyle: GoogleFonts.notoSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      subtitleTextStyle: GoogleFonts.notoSans(
        fontSize: 13,
        color: textSecondary,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: textSecondary,
      indicatorColor: primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      dividerColor: outlineVariantLight,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(radiusSM),
      ),
      textStyle: GoogleFonts.notoSans(fontSize: 12, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: onPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLG),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(minTouchTarget, minTouchTarget),
        iconSize: 24,
      ),
    ),
  );

  // ──────────────────────────────────────────────────────────
  // DARK THEME
  // ──────────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7BAEFF),
      onPrimary: Color(0xFF001A6B),
      primaryContainer: Color(0xFF0D3B9E),
      onPrimaryContainer: Color(0xFFDCE8FF),
      secondary: Color(0xFF6EE87A),
      onSecondary: Color(0xFF00390C),
      secondaryContainer: Color(0xFF0F5229),
      onSecondaryContainer: Color(0xFFCCF0D8),
      tertiary: Color(0xFFFFAA4D),
      onTertiary: Color(0xFF4A1800),
      surface: surfaceDark,
      onSurface: Color(0xFFE6E6E6),
      surfaceContainerHighest: Color(0xFF2A2D3E),
      onSurfaceVariant: Color(0xFFAAAAAA),
      error: Color(0xFFCF6679),
      onError: Colors.white,
      outline: Color(0xFF6B6B6B),
      outlineVariant: Color(0xFF3A3A3A),
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.notoSansTextTheme(ThemeData.dark().textTheme),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceDark,
      indicatorColor: const Color(0xFF0D3B9E),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.notoSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF7BAEFF),
          );
        }
        return GoogleFonts.notoSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFAAAAAA),
        );
      }),
      elevation: 8,
      height: 72,
    ),
  );
}
