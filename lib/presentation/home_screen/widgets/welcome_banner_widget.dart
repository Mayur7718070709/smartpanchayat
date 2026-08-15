import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class WelcomeBannerWidget extends StatelessWidget {
  final String citizenName;
  final String panchayatName;

  const WelcomeBannerWidget({
    required this.citizenName,
    required this.panchayatName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-width horizontal background image
            Image.asset(
              'assets/images/ChatGPT_Image_Aug_15__2026__08_22_03_PM-1786805584242.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              semanticLabel: 'Welcome image for Village Nerle, Sangli district',
            ),
            // Subtle dark gradient only at bottom-left for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(160),
                    Colors.black.withAlpha(80),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Text content overlaid on left
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getGreeting(),
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: Colors.white.withAlpha(217),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    citizenName,
                    style: GoogleFonts.notoSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(38),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          panchayatName,
                          style: GoogleFonts.notoSans(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'सुप्रभात! / Good Morning!';
    if (hour < 17) return 'नमस्कार! / Good Afternoon!';
    return 'शुभ संध्याकाळ! / Good Evening!';
  }
}
