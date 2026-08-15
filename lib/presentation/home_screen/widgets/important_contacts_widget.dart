import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ImportantContactsWidget extends StatelessWidget {
  const ImportantContactsWidget({super.key});

  static const List<Map<String, dynamic>> _contacts = [
    {
      'nameMr': 'ग्रामपंचायत कार्यालय',
      'nameEn': 'Panchayat Office',
      'phone': '02342-234567',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFF1A56DB),
      'bgColor': Color(0xFFDCE8FF),
      'tag': 'कार्यालय',
    },
    {
      'nameMr': 'नागरिक सहाय्य',
      'nameEn': 'Citizen Support',
      'phone': '1800-123-4567',
      'icon': Icons.support_agent_rounded,
      'color': Color(0xFF1B7A3E),
      'bgColor': Color(0xFFCCF0D8),
      'tag': 'मोफत',
    },
    {
      'nameMr': 'आपत्कालीन',
      'nameEn': 'Emergency',
      'phone': '112',
      'icon': Icons.emergency_rounded,
      'color': Color(0xFFB91C1C),
      'bgColor': Color(0xFFFFE4E4),
      'tag': 'आपत्कालीन',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_contacts.length, (index) {
          final contact = _contacts[index];
          final isLast = index == _contacts.length - 1;
          return Column(
            children: [
              _ContactRow(contact: contact),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppTheme.dividerLight,
                  indent: 72,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final Map<String, dynamic> contact;
  const _ContactRow({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: contact['bgColor'] as Color,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              contact['icon'] as IconData,
              color: contact['color'] as Color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      contact['nameMr'] as String,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: (contact['bgColor'] as Color),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        contact['tag'] as String,
                        style: GoogleFonts.notoSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: contact['color'] as Color,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  contact['nameEn'] as String,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (contact['bgColor'] as Color),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_rounded,
                    size: 14,
                    color: contact['color'] as Color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    contact['phone'] as String,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: contact['color'] as Color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
