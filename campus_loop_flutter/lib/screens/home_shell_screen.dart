import 'package:flutter/material.dart';

import '../client.dart';
import '../state/activity_state.dart';
import '../theme/app_colors.dart';
import 'create_activity_screen.dart';
import 'feed_screen.dart';
import 'my_plans_screen.dart';

class HomeShellScreen extends StatefulWidget {
  final VoidCallback onSignOut;

  const HomeShellScreen({
    super.key,
    required this.onSignOut,
  });

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _currentIndex = 0;
  late final ActivityState _activityState;

  @override
  void initState() {
    super.initState();
    _activityState = ActivityState();
    _activityState.loadFeed();
    _activityState.loadMyPlans();
  }

  @override
  void dispose() {
    _activityState.dispose();
    super.dispose();
  }

  void _openCreateScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateActivityScreen(state: _activityState),
      ),
    );
  }

  Future<void> _showSignOutDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out of CampusLoop on this device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cancelled,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.onSignOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _activityState,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 16,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.loop_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CampusLoop',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Student Activity & Study Feed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryContainer,
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                onSelected: (val) {
                  if (val == 'sign_out') {
                    _showSignOutDialog();
                  } else if (val == 'refresh') {
                    _activityState.loadFeed(refresh: true);
                    _activityState.loadMyPlans(refresh: true);
                  }
                },
                itemBuilder: (context) {
                  final user = client.auth.authenticatedUser;
                  final userLabel =
                      (user?.userName != null && user!.userName!.isNotEmpty)
                      ? user.userName!
                      : (user?.email != null && user!.email!.isNotEmpty)
                      ? user.email!
                      : 'Signed in student';

                  return [
                    PopupMenuItem(
                      value: 'info',
                      enabled: false,
                      child: Text(
                        userLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh_rounded, size: 18),
                          SizedBox(width: 10),
                          Text('Refresh Data'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'sign_out',
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            size: 18,
                            color: AppColors.cancelled,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Sign Out',
                            style: TextStyle(color: AppColors.cancelled),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              FeedScreen(
                state: _activityState,
                onNavigateToCreate: _openCreateScreen,
              ),
              MyPlansScreen(
                state: _activityState,
                onNavigateToFeed: () => setState(() => _currentIndex = 0),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openCreateScreen,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 3,
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              'Post Activity',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) {
              setState(() => _currentIndex = idx);
              if (idx == 1 && _activityState.myPlans.isEmpty) {
                _activityState.loadMyPlans();
              }
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore_rounded),
                label: 'Discover Feed',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: _activityState.myPlans.isNotEmpty,
                  label: Text('${_activityState.myPlans.length}'),
                  child: const Icon(Icons.event_note_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: _activityState.myPlans.isNotEmpty,
                  label: Text('${_activityState.myPlans.length}'),
                  child: const Icon(Icons.event_note_rounded),
                ),
                label: 'My Plans',
              ),
            ],
          ),
        );
      },
    );
  }
}
