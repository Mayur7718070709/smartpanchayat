import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../models/notice_model.dart';
import '../../../theme/app_theme.dart';

class RecentNoticesWidget extends StatelessWidget {
  final List<NoticeModel> notices;

  const RecentNoticesWidget({required this.notices, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: notices.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _NoticeCard(notice: notices[i]),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final NoticeModel notice;

  const _NoticeCard({required this.notice});

  Color _getCategoryColor() {
    switch (notice.category) {
      case 'gram_sabha':
        return AppTheme.primary;
      case 'tender':
        return AppTheme.accent;
      case 'general':
      default:
        return AppTheme.secondary;
    }
  }

  IconData _getCategoryIcon() {
    switch (notice.category) {
      case 'gram_sabha':
        return Icons.groups_rounded;
      case 'tender':
        return Icons.description_rounded;
      case 'general':
      default:
        return Icons.campaign_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: notice.isUnread
            ? Border.all(color: color.withAlpha(102), width: 1.5)
            : Border.all(color: AppTheme.outlineVariantLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: color.withAlpha(20),
          onTap: () => context.go('/notices-screen'),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withAlpha(31),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_getCategoryIcon(), color: color, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        notice.categoryLabel,
                        style: GoogleFonts.notoSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    if (notice.isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notice.title,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  notice.date,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
