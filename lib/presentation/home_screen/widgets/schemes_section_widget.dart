import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SchemesSectionWidget extends StatelessWidget {
  const SchemesSectionWidget({super.key});

  static const List<Map<String, dynamic>> _schemes = [
    {
      'nameMr': 'प्रधानमंत्री आवास योजना',
      'nameEn': 'PM Awas Yojana',
      'descMr': 'गरीब कुटुंबांना घरकुल',
      'descEn': 'Housing for all families',
      'icon': Icons.home_rounded,
      'tag': 'केंद्र सरकार',
      'tagEn': 'Central Govt',
      'gradient': [Color(0xFF1A56DB), Color(0xFF4D7FE8)],
      'deadline': '३१ ऑक्टो. २०२५',
    },
    {
      'nameMr': 'मनरेगा',
      'nameEn': 'MGNREGA',
      'descMr': '१०० दिवस रोजगार हमी',
      'descEn': '100 days employment guarantee',
      'icon': Icons.agriculture_rounded,
      'tag': 'रोजगार',
      'tagEn': 'Employment',
      'gradient': [Color(0xFF1B7A3E), Color(0xFF4CAF72)],
      'deadline': 'सतत चालू',
    },
    {
      'nameMr': 'स्वच्छ भारत मिशन',
      'nameEn': 'Swachh Bharat Mission',
      'descMr': 'शौचालय बांधणीसाठी अनुदान',
      'descEn': 'Subsidy for toilet construction',
      'icon': Icons.cleaning_services_rounded,
      'tag': 'स्वच्छता',
      'tagEn': 'Sanitation',
      'gradient': [Color(0xFFFF8100), Color(0xFFFFAA4D)],
      'deadline': '३१ डिसे. २०२५',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._schemes.map((scheme) => _SchemeCard(scheme: scheme)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => context.go('/schemes-screen'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFDCE8FF),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color(0xFF1A56DB).withAlpha(60)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'सर्व योजना पहा / View All Schemes',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A56DB),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Color(0xFF1A56DB),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final Map<String, dynamic> scheme;
  const _SchemeCard({required this.scheme});

  @override
  Widget build(BuildContext context) {
    final gradients = scheme['gradient'] as List<Color>;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradients,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: gradients[0].withAlpha(60),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(40),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Icon(
                scheme['icon'] as IconData,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '${scheme['tag']} • ${scheme['tagEn']}',
                          style: GoogleFonts.notoSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    scheme['nameMr'] as String,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    scheme['nameEn'] as String,
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scheme['descMr'] as String,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: Colors.white.withAlpha(220),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'अंतिम',
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: Colors.white.withAlpha(180),
                  ),
                ),
                Text(
                  scheme['deadline'] as String,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'अर्ज करा',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: gradients[0],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
