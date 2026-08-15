import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class QuickActionsGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> actions;
  final void Function(String? route) onActionTap;

  const QuickActionsGridWidget({
    required this.actions,
    required this.onActionTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _QuickActionCard(
          action: actions[index],
          onTap: () {
            HapticFeedback.lightImpact();
            onActionTap(actions[index]['route'] as String?);
          },
        );
      },
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final Map<String, dynamic> action;
  final VoidCallback onTap;

  const _QuickActionCard({required this.action, required this.onTap});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Color _parseColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  IconData _parseIcon(String name) {
    const map = <String, IconData>{
      'miscellaneous_services': Icons.miscellaneous_services_rounded,
      'report_problem': Icons.report_problem_rounded,
      'campaign': Icons.campaign_rounded,
      'account_balance': Icons.account_balance_rounded,
      'payments': Icons.payments_rounded,
      'contacts': Icons.contacts_rounded,
    };
    return map[name] ?? Icons.apps_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(widget.action['colorHex'] as String);
    final icon = _parseIcon(widget.action['iconName'] as String);

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withAlpha(31),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                widget.action['labelMr'] as String,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                widget.action['labelEn'] as String,
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  color: const Color(0xFF757575),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
