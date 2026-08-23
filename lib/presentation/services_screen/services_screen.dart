import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_runtime.dart';
import '../../data/mock_data.dart';
import '../../models/service_model.dart';
import '../../theme/app_theme.dart';
import './service_detail_screen.dart';
import './widgets/service_card_widget.dart';
import './widgets/service_search_widget.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late List<ServiceModel> _allServices;
  List<ServiceModel> _filteredServices = [];
  String _selectedCategory = 'all';
  final _searchController = TextEditingController();
  bool _isLoading = false;
  Object? _loadError;

  // TODO: Replace with ServiceService for production
  static const List<_FilterChip> _filters = [
    _FilterChip(
      id: 'all',
      labelMr: 'सर्व',
      labelEn: 'All',
      icon: Icons.apps_rounded,
    ),
    _FilterChip(
      id: 'certificate',
      labelMr: 'दाखले',
      labelEn: 'Certificates',
      icon: Icons.assignment_rounded,
    ),
    _FilterChip(
      id: 'water',
      labelMr: 'पाणी',
      labelEn: 'Water',
      icon: Icons.water_drop_rounded,
    ),
    _FilterChip(
      id: 'tax',
      labelMr: 'मालमत्ता/कर',
      labelEn: 'Property/Tax',
      icon: Icons.villa_rounded,
    ),
    _FilterChip(
      id: 'applications',
      labelMr: 'अर्ज',
      labelEn: 'Applications',
      icon: Icons.app_registration_rounded,
    ),
    _FilterChip(
      id: 'documents',
      labelMr: 'कागदपत्रे',
      labelEn: 'Documents',
      icon: Icons.folder_open_rounded,
    ),
    _FilterChip(
      id: 'other',
      labelMr: 'इतर',
      labelEn: 'Other',
      icon: Icons.more_horiz_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _allServices = AppRuntime.usesRealApi
        ? []
        : MockData.serviceMaps.map(ServiceModel.fromMap).toList();
    _filteredServices = _allServices;
    _searchController.addListener(_onSearchChanged);
    if (AppRuntime.usesRealApi) _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final services = await AppRuntime.services.fetchAll();
      if (!mounted) return;
      _allServices = services;
      _applyFilters();
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadError = error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredServices = _allServices.where((s) {
        final matchCategory =
            _selectedCategory == 'all' || s.category == _selectedCategory;
        final matchSearch =
            query.isEmpty ||
            s.nameMr.toLowerCase().contains(query) ||
            s.nameEn.toLowerCase().contains(query);
        return matchCategory && matchSearch;
      }).toList();
    });
  }

  void _openServiceDetail(BuildContext context, ServiceModel service) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: service)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final crossAxisCount = isTablet ? 3 : 2;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Services')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unable to load services.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadServices,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceSearchWidget(
                      controller: _searchController,
                      onChanged: (_) => _onSearchChanged(),
                    ),
                    const SizedBox(height: 14),
                    if (!AppRuntime.usesRealApi) _buildFilterChips(),
                    if (!AppRuntime.usesRealApi) const SizedBox(height: 16),
                    _buildResultCount(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _filteredServices.isEmpty
                ? SliverFillRemaining(child: _buildEmptyState())
                : SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ServiceCardWidget(
                          service: _filteredServices[index],
                          onApply: () => _openServiceDetail(
                            context,
                            _filteredServices[index],
                          ),
                        );
                      }, childCount: _filteredServices.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isTablet ? 0.82 : 0.78,
                      ),
                    ),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppTheme.surfaceLight,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: const Color(0x1A000000),
      pinned: true,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'सेवा',
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          Text(
            'Services',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.help_outline_rounded,
            color: Color(0xFF757575),
          ),
          onPressed: () {},
          tooltip: 'मदत / Help',
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final filter = _filters[i];
          final isSelected = _selectedCategory == filter.id;
          return FilterChip(
            avatar: Icon(
              filter.icon,
              size: 14,
              color: isSelected ? AppTheme.primary : const Color(0xFF757575),
            ),
            label: Text(
              '${filter.labelMr} / ${filter.labelEn}',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primary : const Color(0xFF757575),
              ),
            ),
            selected: isSelected,
            onSelected: (_) => _onCategoryChanged(filter.id),
            selectedColor: AppTheme.primaryContainer,
            backgroundColor: AppTheme.surfaceLight,
            checkmarkColor: AppTheme.primary,
            side: BorderSide(
              color: isSelected
                  ? AppTheme.primary
                  : AppTheme.outlineVariantLight,
              width: isSelected ? 1.5 : 1,
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          );
        },
      ),
    );
  }

  Widget _buildResultCount() {
    return Text(
      '${_filteredServices.length} सेवा उपलब्ध / services available',
      style: GoogleFonts.notoSans(
        fontSize: 13,
        color: const Color(0xFF757575),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 40,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'सेवा सापडली नाही',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'No services found\nकृपया वेगळा शोध घ्या',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: const Color(0xFF757575),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip {
  final String id;
  final String labelMr;
  final String labelEn;
  final IconData icon;

  const _FilterChip({
    required this.id,
    required this.labelMr,
    required this.labelEn,
    required this.icon,
  });
}
