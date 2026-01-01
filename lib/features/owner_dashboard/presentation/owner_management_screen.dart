import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'widgets/menu_management_tab.dart';
import 'widgets/review_management_tab.dart';
import 'widgets/chat_management_tab.dart';

/// Owner management screen with tabbed interface
/// Provides easy access to menu, review, and chat management
class OwnerManagementScreen extends ConsumerStatefulWidget {
  final String truckId;

  const OwnerManagementScreen({
    super.key,
    required this.truckId,
  });

  @override
  ConsumerState<OwnerManagementScreen> createState() => _OwnerManagementScreenState();
}

class _OwnerManagementScreenState extends ConsumerState<OwnerManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: Text(l10n.truckManagement),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.mustardYellow,
          indicatorWeight: 3,
          labelColor: AppTheme.mustardYellow,
          unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(
              icon: const Icon(Icons.restaurant_menu),
              text: l10n.menu,
            ),
            Tab(
              icon: const Icon(Icons.rate_review),
              text: l10n.reviews,
            ),
            Tab(
              icon: const Icon(Icons.chat),
              text: l10n.chat,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MenuManagementTab(truckId: widget.truckId),
          ReviewManagementTab(truckId: widget.truckId),
          ChatManagementTab(truckId: widget.truckId),
        ],
      ),
    );
  }
}
