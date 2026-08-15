import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/mock_data.dart';
import '../../models/scheme_model.dart';
import '../../theme/app_theme.dart';
import './scheme_detail_screen.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  bool _isLoading = true;
  bool _isOffline = false;
  bool _hasError = false;
  List<SchemeModel> _allSchemes = [];
  List<SchemeModel> _filtered = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();

  static const List<_CategoryChip> _categories = [
    _CategoryChip(key: 'all', labelMr: 'सर्व', labelEn: 'All'),
    _CategoryChip(key: 'housing', labelMr: 'गृहनिर्माण', labelEn: 'Housing'),
    _CategoryChip(key: 'employment', labelMr: 'रोजगार', labelEn: 'Employment'),
    _CategoryChip(key: 'agriculture', labelMr: 'शेती', labelEn: 'Agriculture'),
    _CategoryChip(key: 'health', labelMr: 'आरोग्य', labelEn: 'Health'),
    _CategoryChip(key: 'education', labelMr: 'शिक्षण', labelEn: 'Education'),
    _CategoryChip(key: 'women', labelMr: 'महिला', labelEn: 'Women'),
    _CategoryChip(
      key: 'sanitation',
      labelMr: 'स्वच्छता',
      labelEn: 'Sanitation',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSchemes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSchemes() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _isOffline = false;
    });
    try {
      final result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        setState(() {
          _isOffline = true;
          _isLoading = false;
        });
        return;
      }
      await Future.delayed(const Duration(milliseconds: 400));
      setState(() {
        _allSchemes = MockData.mockSchemes;
        _applyFilters();
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<SchemeModel> result = List.from(_allSchemes);
    if (_selectedCategory != 'all') {
      result = result.where((s) => s.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((s) {
        return s.nameMr.toLowerCase().contains(q) ||
            s.nameEn.toLowerCase().contains(q) ||
            s.shortDescMr.toLowerCase().contains(q) ||
            s.shortDescEn.toLowerCase().contains(q) ||
            s.department.toLowerCase().contains(q) ||
            s.departmentEn.toLowerCase().contains(q);
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

  Color _categoryColor(String category) {
    switch (category) {
      case 'housing':
        return AppTheme.primary;
      case 'employment':
        return AppTheme.secondary;
      case 'agriculture':
        return const Color(0xFF2E7D32);
      case 'health':
        return const Color(0xFFD32F2F);
      case 'education':
        return const Color(0xFF7B1FA2);
      case 'women':
        return const Color(0xFFE91E63);
      case 'sanitation':
        return AppTheme.accent;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'housing':
        return Icons.home_rounded;
      case 'employment':
        return Icons.work_rounded;
      case 'agriculture':
        return Icons.agriculture_rounded;
      case 'health':
        return Icons.local_hospital_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'women':
        return Icons.woman_rounded;
      case 'sanitation':
        return Icons.cleaning_services_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'सरकारी योजना',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Government Schemes',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppTheme.dividerLight),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoadingState();
    if (_isOffline) return _buildOfflineState();
    if (_hasError) return _buildErrorState();

    return Column(
      children: [
        _buildSearchBar(),
        _buildCategoryFilter(),
        Expanded(
          child: _filtered.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadSchemes,
                  color: AppTheme.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) => _SchemeCard(
                      scheme: _filtered[index],
                      categoryColor: _categoryColor(_filtered[index].category),
                      categoryIcon: _categoryIcon(_filtered[index].category),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SchemeDetailScreen(scheme: _filtered[index]),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: GoogleFonts.notoSans(fontSize: 14, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'योजना शोधा / Search schemes...',
          hintStyle: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppTheme.textTertiary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppTheme.textTertiary,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: AppTheme.textTertiary,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
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
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppTheme.outlineVariantLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final isSelected = _selectedCategory == cat.key;
            return GestureDetector(
              onTap: () => _onCategorySelected(cat.key),
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
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.outlineLight,
                  ),
                ),
                child: Text(
                  '${cat.labelMr} / ${cat.labelEn}',
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

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 130,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildOfflineState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text('इंटरनेट उपलब्ध नाही', style: AppTheme.headingSmall),
            const SizedBox(height: 8),
            Text('No internet connection', style: AppTheme.bodySmall),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSchemes,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('पुन्हा प्रयत्न करा / Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 56, color: AppTheme.error),
            const SizedBox(height: 16),
            Text('काहीतरी चुकले', style: AppTheme.headingSmall),
            const SizedBox(height: 8),
            Text('Something went wrong', style: AppTheme.bodySmall),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSchemes,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('पुन्हा प्रयत्न करा / Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text('कोणतीही योजना सापडली नाही', style: AppTheme.headingSmall),
            const SizedBox(height: 8),
            Text('No schemes found', style: AppTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

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

class _SchemeCard extends StatelessWidget {
  final SchemeModel scheme;
  final Color categoryColor;
  final IconData categoryIcon;
  final VoidCallback onTap;

  const _SchemeCard({
    required this.scheme,
    required this.categoryColor,
    required this.categoryIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppTheme.outlineVariantLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: categoryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Icon(categoryIcon, color: categoryColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheme.nameMr,
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          scheme.nameEn,
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.textTertiary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Department
              Row(
                children: [
                  Icon(
                    Icons.account_balance_rounded,
                    size: 13,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${scheme.department} / ${scheme.departmentEn}',
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: AppTheme.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Short description
              Text(
                scheme.shortDescMr,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              // Divider
              Divider(height: 1, color: AppTheme.dividerLight),
              const SizedBox(height: 10),
              // Eligibility summary
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 14,
                    color: categoryColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'पात्रता / Eligibility',
                          style: GoogleFonts.notoSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textTertiary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          scheme.eligibilitySummaryMr,
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      scheme.categoryLabel,
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
