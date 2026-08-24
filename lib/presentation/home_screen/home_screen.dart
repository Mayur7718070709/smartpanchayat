import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/app_runtime.dart';
import '../../data/mock_data.dart';
import '../../models/notice_model.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/ds_states.dart';
import './widgets/pending_dues_widget.dart';
import './widgets/quick_actions_grid_widget.dart';
import './widgets/recent_notices_widget.dart';
import './widgets/upcoming_events_widget.dart';
import './widgets/welcome_banner_widget.dart';
import './widgets/important_notice_widget.dart';
import './widgets/quick_services_widget.dart';
import './widgets/schemes_section_widget.dart';
import './widgets/ask_smart_panchayat_widget.dart';
import './widgets/important_contacts_widget.dart';
import './widgets/gated_panchayat_content_widget.dart';

enum HomeLoadState { loading, loaded, error, offline, empty }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<NoticeModel> _notices;
  final _citizen = MockData.citizenProfile;
  HomeLoadState _loadState = HomeLoadState.loading;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loadState = HomeLoadState.loading);
    // Check connectivity
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      setState(() => _loadState = HomeLoadState.offline);
      return;
    }
    if (AppRuntime.usesRealApi) {
      try {
        final profile = await AppRuntime.citizenProfile.fetch();
        final panchayat = await AppRuntime.panchayatContent.profile();
        if (!mounted) return;
        _citizen['name'] = profile.fullName;
        _citizen['panchayatName'] = panchayat.name;
        _notices = await AppRuntime.notices.list(limit: 4);
        setState(() => _loadState = HomeLoadState.loaded);
      } catch (_) {
        if (mounted) setState(() => _loadState = HomeLoadState.error);
      }
      return;
    }
    // Simulate data load
    await Future.delayed(const Duration(milliseconds: 600));
    _notices = MockData.noticeMaps.map(NoticeModel.fromMap).toList();
    if (_notices.isEmpty) {
      setState(() => _loadState = HomeLoadState.empty);
    } else {
      setState(() => _loadState = HomeLoadState.loaded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(child: _buildBody(isTablet)),
    );
  }

  Widget _buildBody(bool isTablet) {
    switch (_loadState) {
      case HomeLoadState.loading:
        return _buildLoadingState();
      case HomeLoadState.offline:
        return _buildOfflineState();
      case HomeLoadState.error:
        return _buildErrorState();
      case HomeLoadState.empty:
        return _buildEmptyState();
      case HomeLoadState.loaded:
        return _buildLoadedContent(isTablet);
    }
  }

  // ── Loading State ──────────────────────────────────────
  Widget _buildLoadingState() {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        _buildSliverAppBar(Theme.of(context)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              DSShimmerBox(
                width: double.infinity,
                height: 160,
                borderRadius: 20,
              ),
              const SizedBox(height: 16),
              DSShimmerBox(
                width: double.infinity,
                height: 80,
                borderRadius: 14,
              ),
              const SizedBox(height: 20),
              DSShimmerBox(width: 160, height: 20, borderRadius: 6),
              const SizedBox(height: 12),
              Row(
                children: List.generate(
                  4,
                  (i) => Padding(
                    padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
                    child: DSShimmerBox(
                      width: 82,
                      height: 100,
                      borderRadius: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DSShimmerBox(width: 160, height: 20, borderRadius: 6),
              const SizedBox(height: 12),
              DSShimmerBox(
                width: double.infinity,
                height: 80,
                borderRadius: 14,
              ),
              const SizedBox(height: 10),
              DSShimmerBox(
                width: double.infinity,
                height: 80,
                borderRadius: 14,
              ),
              const SizedBox(height: 20),
              DSShimmerBox(
                width: double.infinity,
                height: 120,
                borderRadius: 20,
              ),
            ]),
          ),
        ),
      ],
    );
  }

  // ── Offline State ──────────────────────────────────────
  Widget _buildOfflineState() {
    return Column(
      children: [
        _buildSimpleAppBar(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariantLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      size: 48,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'इंटरनेट नाही',
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No Internet Connection',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'कृपया आपले इंटरनेट कनेक्शन तपासा आणि पुन्हा प्रयत्न करा.',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      'पुन्हा प्रयत्न करा / Retry',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(220, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Error State ──────────────────────────────────────
  Widget _buildErrorState() {
    return Column(
      children: [
        _buildSimpleAppBar(),
        Expanded(
          child: DSErrorState(
            title: 'माहिती लोड झाली नाही',
            message:
                'काहीतरी चुकले. कृपया पुन्हा प्रयत्न करा.\nSomething went wrong. Please try again.',
            retryLabel: 'पुन्हा प्रयत्न करा / Retry',
            onRetry: _loadData,
          ),
        ),
      ],
    );
  }

  // ── Empty State ──────────────────────────────────────
  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildSimpleAppBar(),
        Expanded(
          child: DSEmptyState(
            icon: Icons.inbox_rounded,
            title: 'कोणतीही माहिती नाही',
            subtitle: 'No data available.\nकृपया नंतर पुन्हा तपासा.',
            actionLabel: 'ताजेतवाने करा / Refresh',
            onAction: _loadData,
          ),
        ),
      ],
    );
  }

  // ── Simple AppBar for state screens ──────────────────
  Widget _buildSimpleAppBar() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildLogoAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _citizen['panchayatName'] as String,
                  style: GoogleFonts.notoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  _citizen['district'] as String,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Loaded Content ──────────────────────────────────────
  Widget _buildLoadedContent(bool isTablet) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(Theme.of(context)),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: 8,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              WelcomeBannerWidget(
                citizenName: _citizen['name'] as String,
                panchayatName: _citizen['panchayatName'] as String,
              ),
              const SizedBox(height: 14),

              // ── Important Notice Banner ──
              if (!AppRuntime.usesRealApi) const ImportantNoticeWidget(),
              if (!AppRuntime.usesRealApi) const SizedBox(height: 20),

              // ── Stats Banner ──
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/Full_Background_Image-1786808262558.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    PendingDuesWidget(
                      amount: _citizen['pendingDuesAmount'] as double,
                      pendingComplaints: _citizen['pendingComplaints'] as int,
                      activeApplications: _citizen['activeApplications'] as int,
                      showDues: !AppRuntime.usesRealApi,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Quick Access ──
              _buildSectionHeader(context, 'त्वरित सेवा', 'Quick Access', null),
              const SizedBox(height: 12),
              QuickActionsGridWidget(
                actions: MockData.quickActions,
                onActionTap: (route) {
                  if (route != null) context.go(route);
                },
              ),
              const SizedBox(height: 20),

              // ── Popular Services ──
              _buildSectionHeader(
                context,
                'लोकप्रिय सेवा',
                'Popular Services',
                () => context.go('/services-screen'),
              ),
              const SizedBox(height: 12),
              const QuickServicesWidget(),
              const SizedBox(height: 20),

              // ── Government Schemes ──
              if (_notices.isNotEmpty)
                _buildSectionHeader(
                  context,
                  'सरकारी योजना',
                  'Govt. Schemes',
                  null,
                ),
              if (!AppRuntime.usesRealApi) const SizedBox(height: 12),
              if (!AppRuntime.usesRealApi) const SchemesSectionWidget(),
              if (!AppRuntime.usesRealApi) const SizedBox(height: 20),

              // ── Ask Smart Panchayat ──
              const AskSmartPanchayatWidget(),
              const SizedBox(height: 20),

              // ── Recent Notices ──
              if (!AppRuntime.usesRealApi)
                _buildSectionHeader(
                  context,
                  'अलीकडील सूचना',
                  'Recent Notices',
                  () => context.go('/notices-screen'),
                ),
              if (_notices.isNotEmpty) const SizedBox(height: 12),
              if (_notices.isNotEmpty)
                RecentNoticesWidget(notices: _notices.take(4).toList()),
              if (_notices.isNotEmpty) const SizedBox(height: 20),

              // ── Important Contacts ──
              _buildSectionHeader(
                context,
                'महत्त्वाचे संपर्क',
                'Important Contacts',
                null,
              ),
              if (!AppRuntime.usesRealApi) const SizedBox(height: 12),
              if (!AppRuntime.usesRealApi) const ImportantContactsWidget(),
              if (AppRuntime.usesRealApi)
                const GatedPanchayatContentWidget(
                  type: PanchayatContentType.contacts,
                ),
              const SizedBox(height: 20),

              // ── Upcoming Events ──
              _buildSectionHeader(
                context,
                'आगामी कार्यक्रम',
                'Upcoming Events',
                null,
              ),
              if (!AppRuntime.usesRealApi) const SizedBox(height: 12),
              if (!AppRuntime.usesRealApi)
                UpcomingEventsWidget(events: MockData.upcomingEvents),
              if (AppRuntime.usesRealApi)
                const GatedPanchayatContentWidget(
                  type: PanchayatContentType.events,
                ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppTheme.primary.withAlpha(60), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.0),
        child: Image.asset(
          'assets/images/img_app_logo.svg',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.account_balance_rounded,
            color: AppTheme.primary,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    final name = _citizen['name'] as String;
    final initials = name.isNotEmpty ? name[0] : 'म';
    return GestureDetector(
      onTap: () => context.push('/citizen-profile'),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withAlpha(60),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            initials,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    final unread = _citizen['unreadNotices'] as int;
    return SliverAppBar(
      backgroundColor: AppTheme.surfaceLight,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: const Color(0x1A000000),
      pinned: true,
      titleSpacing: 12,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
        child: _buildLogoAvatar(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _citizen['panchayatName'] as String,
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
          Text(
            _citizen['district'] as String,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF212121),
              ),
              onPressed: () => context.go(AppRoutes.notificationsScreen),
              tooltip: 'सूचना / Notifications',
            ),
            if (unread > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$unread',
                      style: GoogleFonts.notoSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _buildProfileAvatar(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String mr,
    String en,
    VoidCallback? onViewAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mr,
              style: GoogleFonts.notoSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF212121),
              ),
            ),
            Text(
              en,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: const Color(0xFF757575),
              ),
            ),
          ],
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'सर्व पहा / View all',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
