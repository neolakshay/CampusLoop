import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';

import '../state/activity_state.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import '../widgets/capacity_indicator.dart';
import '../widgets/kind_badge.dart';
import '../widgets/status_badge.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final CampusActivity activity;
  final ActivityState state;

  const ActivityDetailsScreen({
    super.key,
    required this.activity,
    required this.state,
  });

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  ActivityDetails? _details;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final id = widget.activity.id;
    if (id == null) {
      setState(() => _isLoading = false);
      return;
    }
    final details = await widget.state.fetchDetails(id);
    if (mounted) {
      setState(() {
        _details = details;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleJoin() async {
    final id = widget.activity.id;
    if (id == null) return;

    setState(() => _isSubmitting = true);
    try {
      final updated = await widget.state.joinActivity(id);
      if (mounted) {
        setState(() => _details = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('RSVP confirmed! You are now attending.'),
            backgroundColor: AppColors.active,
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
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleLeave() async {
    final id = widget.activity.id;
    if (id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Activity?'),
        content: const Text(
          'Are you sure you want to withdraw your RSVP?',
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

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);
    try {
      final updated = await widget.state.leaveActivity(id);
      if (mounted) {
        setState(() => _details = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have withdrawn your RSVP.'),
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
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleCancel() async {
    final id = widget.activity.id;
    if (id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this activity?'),
        content: const Text(
          'This will mark the activity as cancelled for all students. This action cannot be undone.',
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

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);
    try {
      final updated = await widget.state.cancelActivity(id);
      if (mounted) {
        setState(() => _details = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activity has been cancelled.'),
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
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activity = _details?.activity ?? widget.activity;
    final isCancelled = activity.status == ActivityStatus.cancelled;
    final attendeeCount = _details?.attendeeCount ?? 1;
    final isFull =
        activity.capacity != null && attendeeCount >= activity.capacity!;
    final isAttending = _details?.isAttending ?? false;
    final isOrganizer = _details?.isOrganizer ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          activity.kind == ActivityKind.event
              ? 'Campus Event'
              : 'Study Session',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              children: [
                // Cancelled banner if applicable
                if (isCancelled) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cancelledBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.cancelled.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.cancelled,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This activity has been cancelled by the organizer.',
                            style: TextStyle(
                              color: AppColors.cancelled,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Badges Row
                Row(
                  children: [
                    KindBadge(kind: activity.kind),
                    if (activity.topic != null &&
                        activity.topic!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.lightSurfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          activity.topic!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    StatusBadge(status: activity.status, isFull: isFull),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  activity.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 20),

                // Date & Time Box
                _buildInfoCard(
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppColors.primary,
                  title: 'Date & Time',
                  content: DateFormatter.formatTimeRange(
                    activity.startsAt,
                    activity.endsAt,
                  ),
                  subtitle:
                      DateFormatter.formatDuration(
                            activity.startsAt,
                            activity.endsAt,
                          ) !=
                          null
                      ? 'Duration: ${DateFormatter.formatDuration(activity.startsAt, activity.endsAt)}'
                      : null,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // Location Box
                _buildInfoCard(
                  icon: Icons.location_on_rounded,
                  iconColor: AppColors.secondary,
                  title: 'Location',
                  content: activity.location,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // Capacity & Attendees Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people_alt_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Attendance & Capacity',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          if (isFull)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.fullBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Full Capacity',
                                style: TextStyle(
                                  color: AppColors.full,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CapacityIndicator(
                        attendeeCount: attendeeCount,
                        capacity: activity.capacity,
                        showBar: true,
                      ),
                      if (activity.capacity != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Maximum limit of ${activity.capacity} students enforced by organizer.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Organizer Box
                _buildInfoCard(
                  icon: Icons.person_rounded,
                  iconColor: AppColors.studyPrimary,
                  title: 'Organized by',
                  content: activity.organizerName,
                  subtitle: isOrganizer
                      ? 'You are the organizer of this activity'
                      : null,
                  isDark: isDark,
                ),
                const SizedBox(height: 20),

                // Description Header & Content
                Text(
                  'About this activity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  activity.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (isOrganizer) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isCancelled || _isSubmitting
                        ? null
                        : _handleCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cancelled,
                      foregroundColor: Colors.white,
                    ),
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.cancel_outlined, size: 20),
                    label: Text(
                      isCancelled ? 'Activity Cancelled' : 'Cancel Activity',
                    ),
                  ),
                ),
              ] else if (isAttending) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isCancelled || _isSubmitting
                        ? null
                        : _handleLeave,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.cancelled,
                      side: const BorderSide(color: AppColors.cancelled),
                    ),
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.exit_to_app_rounded, size: 20),
                    label: const Text('Leave Activity'),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isCancelled || isFull || _isSubmitting
                        ? null
                        : _handleJoin,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 20,
                          ),
                    label: Text(
                      isCancelled
                          ? 'Cancelled'
                          : (isFull ? 'Full Capacity' : 'RSVP to Join'),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    String? subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
