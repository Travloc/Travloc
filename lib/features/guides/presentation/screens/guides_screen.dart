import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'guide_list_screen.dart';
import 'travel_buddies_screen.dart';

class GuidesScreen extends ConsumerStatefulWidget {
  const GuidesScreen({super.key});

  @override
  ConsumerState<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends ConsumerState<GuidesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guides'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Guides'),
            Tab(text: 'Travel Buddies'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GuideListScreen(),
          TravelBuddiesScreen(),
        ],
      ),
    );
  }
} 