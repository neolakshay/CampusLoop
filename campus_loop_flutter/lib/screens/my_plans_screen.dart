import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';

import '../state/activity_state.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';
import '../widgets/kind_badge.dart';
import '../widgets/status_badge.dart';
import 'activity_details_screen.dart';

class MyPlansScreen extends StatefulWidget {
  final ActivityState state;
  final VoidCallback onNavigateToFeed;

  const MyPlansScreen({
    super.key,
    required this.state,
    required this.onNavigateToFeed,
  });

  @override
  State<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends State<MyPlansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    widget.state.loadMyPlans();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ActivityPlan> _getFilteredPlans(int tabIndex) {
    final all = widget.state.myPlans;
    if (tabIndex == 1) {
      return all.where((p) => p.isOrganizer).toList();
    } else if (tabIndex == 2) {
      return all.where((p) => p.isAttending && !p.isOrganizer).toList();
    }
    return all;
  }

  void _openDetails(CampusActivity activity) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ActivityDetailsScreen(
          activity: activity,
          state: widget.state,
        ),
      ),
    );
  }

  Future<void> _confirmLeave(ActivityPlan plan) async {
    final activityId = plan.activity.id;
    if (activityId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Activity?'),
        content: Text(
          'Are you sure you want to withdraw your RSVP for "${plan.activity.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep RSVP'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cancelled,
              foregroundColor: Colors.white,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await widget.state.leaveActivity(activityId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have left "${plan.activity.title}".'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ActivityState.parseErrorMessage(e)),
              backgroundColor: AppColors.cancelled,
            ),
          );
        }
      }
    }
  }

  Future<void> _confirmCancel(ActivityPlan plan) async {
    final activityId = plan.activity.id;
    if (activityId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Activity?'),
        content: Text(
          'Are you sure you want to cancel "${plan.activity.title}"? Attendees will see this activity marked as cancelled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep Active'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cancelled,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Activity'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await widget.state.cancelActivity(activityId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Activity "${plan.activity.title}" has been cancelled.',
              ),
              backgroundColor: AppColors.cancelled,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ActivityState.parseErrorMessage(e)),
              backgroundColor: AppColors.cancelled,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'All Plans'),
              Tab(text: 'Organizing'),
              Tab(text: 'Attending'),
            ],
          ),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge([_tabController, widget.state]),
            builder: (context, _) {
              if (state.isLoadingPlans) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.plansError != null && state.myPlans.isEmpty) {
                return ErrorView(
                  message: state.plansError!,
                  onRetry: () => state.loadMyPlans(refresh: true),
                );
              }

              final plans = _getFilteredPlans(_tabController.index);

              if (plans.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => state.loadMyPlans(refresh: true),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: EmptyState(
                          icon: Icons.event_note_rounded,
                          title: 'No plans here yet',
                          message: _tabController.index == 1
                              ? "You haven't organized any activities yet."
                              : (_tabController.index == 2
                                    ? "You haven't joined any activities yet."
                                    : 'Explore campus activities and RSVP to join student events and study groups.'),
                          actionLabel: 'Discover Activities',
                          actionIcon: Icons.explore_rounded,
                          onAction: widget.onNavigateToFeed,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => state.loadMyPlans(refresh: true),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: plans.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final activity = plan.activity;
                    final isCancelled =
                        activity.status == ActivityStatus.cancelled;

                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isCancelled
                              ? AppColors.cancelled.withValues(alpha: 0.3)
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                          width: 1.2,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _openDetails(activity),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  KindBadge(
                                    kind: activity.kind,
                                    isCompact: true,
                                  ),
                                  const SizedBox(width: 8),
                                  if (plan.isOrganizer)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            size: 12,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Organizer',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else if (plan.isAttending)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.activeBackground,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            size: 12,
                                            color: AppColors.active,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Attending',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.active,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const Spacer(),
                                  StatusBadge(status: activity.status),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                activity.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      decoration: isCancelled
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormatter.formatRelative(
                                      activity.startsAt,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      activity.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1, thickness: 0.8),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (plan.joinedAt != null)
                                    Text(
                                      'RSVP on ${DateFormatter.formatDateTime(plan.joinedAt!)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? AppColors.darkTextTertiary
                                            : AppColors.lightTextTertiary,
                                      ),
                                    )
                                  else
                                    const SizedBox.shrink(),
                                  Row(
                                    children: [
                                      if (plan.isOrganizer && !isCancelled)
                                        TextButton(
                                          onPressed: () => _confirmCancel(plan),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppColors.cancelled,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: const Text(
                                            'Cancel Activity',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      else if (plan.isAttending &&
                                          !plan.isOrganizer &&
                                          !isCancelled)
                                        TextButton(
                                          onPressed: () => _confirmLeave(plan),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppColors.cancelled,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: const Text(
                                            'Leave RSVP',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        size: 20,
                                        color: isDark
                                            ? AppColors.darkTextTertiary
                                            : AppColors.lightTextTertiary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
