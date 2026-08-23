import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_runtime.dart';
import '../../core/network/api_exception.dart';
import '../../data/mock_data.dart';
import '../../models/notice_model.dart';
import '../../theme/app_theme.dart';
import './notice_detail_screen.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  bool _isLoading = true;
  bool _isOffline = false;
  bool _hasError = false;
  bool _featureUnavailable = false;
  List<NoticeModel> _allNotices = [];
  List<NoticeModel> _filtered = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();

  static const List<_CategoryChip> _categories = [
    _CategoryChip(key: 'all', labelMr: 'सर्व', labelEn: 'All'),
    _CategoryChip(key: 'emergency', labelMr: 'आपत्कालीन', labelEn: 'Emergency'),
    _CategoryChip(
      key: 'important',
      labelMr: 'महत्त्वाचे',
      labelEn: 'Important',
    ),
    _CategoryChip(key: 'government', labelMr: 'शासकीय', labelEn: 'Government'),
    _CategoryChip(key: 'event', labelMr: 'कार्यक्रम', labelEn: 'Event'),
    _CategoryChip(key: 'general', labelMr: 'सामान्य', labelEn: 'General'),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotices() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _isOffline = false;
      _featureUnavailable = false;
    });
    try {
      if (AppRuntime.usesRealApi) {
        await AppRuntime.notices.checkAvailability();
        if (!mounted) return;
        setState(() {
          _featureUnavailable = true;
          _isLoading = false;
        });
        return;
      }
      final result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        setState(() {
          _isOffline = true;
          _isLoading = false;
        });
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _allNotices = MockData.mockNotices;
        _applyFilters();
        _isLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _featureUnavailable =
            error.code == ApiErrorCode.databaseContractGap ||
            error.code == ApiErrorCode.featureNotEnabled;
        _hasError = !_featureUnavailable;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<NoticeModel> result = List.from(_allNotices);
    if (_selectedCategory != 'all') {
      result = result.where((n) => n.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((n) {
        return n.title.toLowerCase().contains(q) ||
            n.titleEn.toLowerCase().contains(q) ||
            n.description.toLowerCase().contains(q) ||
            n.descriptionEn.toLowerCase().contains(q);
      }).toList();
    }
    _filtered = result;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _applyFilters();
    });
  }

  void _onCategorySelected(String key) {
    setState(() {
      _selectedCategory = key;
      _applyFilters();
    });
  }

  void _markAsRead(String id) {
    setState(() {
      _allNotices = _allNotices.map((n) {
        if (n.id == id && n.isUnread) {
          return NoticeModel.fromMap({...n.toMap(), 'isUnread': false});
        }
        return n;
      }).toList();
      _applyFilters();
    });
  }

  int get _unreadCount => _allNotices.where((n) => n.isUnread).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'सूचना व जाहीरनामे',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Notices & Announcements',
              style: GoogleFonts.notoSans(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_unreadCount नवीन',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppTheme.dividerLight),
        ),
      ),
      body: _isLoading
          ? const _LoadingSkeleton()
          : _isOffline
          ? DSOfflineState(onRetry: _loadNotices)
          : _hasError
          ? DSErrorState(onRetry: _loadNotices)
          : _featureUnavailable
          ? const DSEmptyState(
              icon: Icons.campaign_outlined,
              titleMr: 'सूचना उपलब्ध नाहीत',
              titleEn: 'Notices unavailable',
              subtitleMr: 'प्रकाशन नियमांच्या मंजुरीची प्रतीक्षा आहे.',
              subtitleEn:
                  'Production publishing and audience rules are awaiting approval.',
            )
          : Column(
              children: [
                _SearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                ),
                _CategoryFilter(
                  categories: _categories,
                  selected: _selectedCategory,
                  onSelected: _onCategorySelected,
                ),
                Expanded(
                  child: _filtered.isEmpty
                      ? DSEmptyState(
                          icon: Icons.notifications_off_outlined,
                          titleMr: 'कोणत्याही सूचना नाहीत',
                          titleEn: 'No notices found',
                          subtitleMr: 'वेगळ्या श्रेणीने शोधा',
                          subtitleEn: 'Try a different category or search',
                        )
                      : RefreshIndicator(
                          onRefresh: _loadNotices,
                          color: AppTheme.primary,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: _filtered.length,
                            itemBuilder: (context, index) {
                              final notice = _filtered[index];
                              return _NoticeCard(
                                notice: notice,
                                onTap: () async {
                                  _markAsRead(notice.id);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          NoticeDetailScreen(notice: notice),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

// ── Search Bar ──────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.notoSans(fontSize: 14, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'सूचना शोधा / Search notices',
          hintStyle: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppTheme.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppTheme.textTertiary,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppTheme.textTertiary,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppTheme.backgroundLight,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppTheme.outlineVariantLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── Category Filter ──────────────────────────────────────────
class _CategoryChip {
  final String key;
  final String labelMr;
  final String labelEn;
  const _CategoryChip({
    required this.key,
    required this.labelMr,
    required this.labelEn,
  });
}

class _CategoryFilter extends StatelessWidget {
  final List<_CategoryChip> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final chip = categories[index];
            final isSelected = chip.key == selected;
            return GestureDetector(
              onTap: () => onSelected(chip.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary
                      : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.outlineLight,
                  ),
                ),
                child: Text(
                  chip.labelMr,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Notice Card ──────────────────────────────────────────────
class _NoticeCard extends StatelessWidget {
  final NoticeModel notice;
  final VoidCallback onTap;

  const _NoticeCard({required this.notice, required this.onTap});

  Color get _categoryColor {
    switch (notice.category) {
      case 'emergency':
        return const Color(0xFFFF4D00);
      case 'important':
        return AppTheme.warning;
      case 'government':
        return AppTheme.primary;
      case 'event':
        return AppTheme.secondary;
      case 'general':
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData get _categoryIcon {
    switch (notice.category) {
      case 'emergency':
        return Icons.warning_amber_rounded;
      case 'important':
        return Icons.priority_high_rounded;
      case 'government':
        return Icons.account_balance_rounded;
      case 'event':
        return Icons.event_rounded;
      case 'general':
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmergency = notice.category == 'emergency';
    final isImportant = notice.category == 'important';
    final needsVisualTreatment = isEmergency || isImportant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: needsVisualTreatment
                  ? _categoryColor.withAlpha(89)
                  : AppTheme.outlineVariantLight,
              width: needsVisualTreatment ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top accent bar for emergency/important
              if (needsVisualTreatment)
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: _categoryColor.withAlpha(179),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category + date row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _categoryColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _categoryIcon,
                                size: 12,
                                color: _categoryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                notice.categoryLabel,
                                style: GoogleFonts.notoSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _categoryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(notice.date),
                          style: GoogleFonts.notoSans(
                            fontSize: 11,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                        if (notice.isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notice.title,
                            style: GoogleFonts.notoSans(
                              fontSize: 14,
                              fontWeight: notice.isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: AppTheme.textPrimary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (notice.isUnread)
                          Container(
                            margin: const EdgeInsets.only(left: 8, top: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'नवीन',
                              style: GoogleFonts.notoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notice.titleEn,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      notice.description,
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Attachment indicator
                    if (notice.attachmentUrl != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_file_rounded,
                            size: 13,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'दस्तऐवज उपलब्ध',
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final months = [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        final month = int.tryParse(parts[1]) ?? 0;
        return '${parts[2]} ${months[month]} ${parts[0]}';
      }
    } catch (_) {}
    return dateStr;
  }
}

// ── Loading Skeleton ──────────────────────────────────────────
class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: 4,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const _ShimmerBox(),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox();

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.9).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// ── DS State helpers ──────────────────────────────────────────
class DSOfflineState extends StatelessWidget {
  final VoidCallback onRetry;
  const DSOfflineState({required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 12),
          Text('इंटरनेट कनेक्शन नाही', style: AppTheme.sectionHeadingMedium),
          const SizedBox(height: 4),
          Text('No internet connection', style: AppTheme.bodySmall),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: const Text('पुन्हा प्रयत्न करा'),
          ),
        ],
      ),
    );
  }
}

class DSErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const DSErrorState({required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppTheme.error,
          ),
          const SizedBox(height: 12),
          Text('काहीतरी चुकले', style: AppTheme.sectionHeadingMedium),
          const SizedBox(height: 4),
          Text('Something went wrong', style: AppTheme.bodySmall),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: const Text('पुन्हा प्रयत्न करा'),
          ),
        ],
      ),
    );
  }
}

class DSEmptyState extends StatelessWidget {
  final IconData icon;
  final String titleMr;
  final String titleEn;
  final String subtitleMr;
  final String subtitleEn;

  const DSEmptyState({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.subtitleMr,
    required this.subtitleEn,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppTheme.textTertiary),
          const SizedBox(height: 12),
          Text(titleMr, style: AppTheme.sectionHeadingMedium),
          const SizedBox(height: 4),
          Text(titleEn, style: AppTheme.bodySmall),
          const SizedBox(height: 4),
          Text(subtitleMr, style: AppTheme.captionMedium),
        ],
      ),
    );
  }
}
