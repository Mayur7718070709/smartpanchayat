import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class UpcomingEventsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  const UpcomingEventsWidget({required this.events, super.key});

  Color _parseColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  IconData _parseIcon(String name) {
    const map = <String, IconData>{
      'groups': Icons.groups_rounded,
      'cleaning_services': Icons.cleaning_services_rounded,
    };
    return map[name] ?? Icons.event_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: events.map((event) {
        final color = _parseColor(event['colorHex'] as String);
        final icon = _parseIcon(event['iconName'] as String);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.outlineVariantLight),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withAlpha(31),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['titleMr'] as String,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event['titleEn'] as String,
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    event['date'] as String,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event['time'] as String,
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
