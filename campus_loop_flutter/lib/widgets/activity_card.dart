import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import 'capacity_indicator.dart';
import 'kind_badge.dart';
import 'status_badge.dart';

class ActivityCard extends StatelessWidget {
  final CampusActivity activity;
  final ActivityDetails? cachedDetails;
  final bool? isAttending;
  final bool? isOrganizer;
  final VoidCallback onTap;
  final VoidCallback? onQuickJoin;
  final bool isActionPending;

  const ActivityCard({
    super.key,
    required this.activity,
    this.cachedDetails,
    this.isAttending,
    this.isOrganizer,
    required this.onTap,
    this.onQuickJoin,
    this.isActionPending = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCancelled = activity.status == ActivityStatus.cancelled;
    final attendeeCount = cachedDetails?.attendeeCount ?? 1;
    final isFull =
        activity.capacity != null && attendeeCount >= activity.capacity!;
    final effectiveIsAttending =
        isAttending ?? (cachedDetails?.isAttending ?? false);
    final effectiveIsOrganizer =
        isOrganizer ?? (cachedDetails?.isOrganizer ?? false);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCancelled
              ? AppColors.cancelled.withValues(alpha: 0.3)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges Row
              Row(
                children: [
                  KindBadge(kind: activity.kind, isCompact: true),
                  if (activity.topic != null && activity.topic!.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.lightSurfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          activity.topic!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  StatusBadge(status: activity.status, isFull: isFull),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                activity.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  decoration: isCancelled ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 8),

              // Date & Time
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 15,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      DateFormatter.formatRelative(activity.startsAt),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (activity.endsAt != null)
                    Text(
                      DateFormatter.formatDuration(
                            activity.startsAt,
                            activity.endsAt,
                          ) ??
                          '',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),

              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 15,
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

              // Capacity bar & Organizer Info
              CapacityIndicator(
                attendeeCount: attendeeCount,
                capacity: activity.capacity,
                showBar: activity.capacity != null,
              ),
              const SizedBox(height: 12),

              const Divider(height: 1, thickness: 0.8),
              const SizedBox(height: 10),

              // Bottom footer: Organizer & RSVP pill / action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primaryContainer,
                        child: Text(
                          activity.organizerName.isNotEmpty
                              ? activity.organizerName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        activity.organizerName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (effectiveIsOrganizer)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
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
                            size: 13,
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
                  else if (effectiveIsAttending)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
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
                            size: 13,
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
                    )
                  else if (!isCancelled && !isFull && onQuickJoin != null)
                    ElevatedButton(
                      onPressed: isActionPending ? null : onQuickJoin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: isActionPending
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'RSVP',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    )
                  else
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
        ),
      ),
    );
  }
}
