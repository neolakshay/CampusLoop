import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CapacityIndicator extends StatelessWidget {
  final int attendeeCount;
  final int? capacity;
  final bool showBar;

  const CapacityIndicator({
    super.key,
    required this.attendeeCount,
    this.capacity,
    this.showBar = true,
  });

  @override
  Widget build(BuildContext context) {
    if (capacity == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.group_outlined,
            size: 14,
            color: AppColors.lightTextSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            '$attendeeCount attending',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      );
    }

    final cap = capacity!;
    final ratio = (attendeeCount / cap).clamp(0.0, 1.0);
    final spotsRemaining = (cap - attendeeCount).clamp(0, cap);
    final isFull = attendeeCount >= cap;
    final isNearFull = spotsRemaining > 0 && spotsRemaining <= 3;

    final Color barColor = isFull
        ? AppColors.full
        : (isNearFull ? AppColors.studyPrimary : AppColors.secondary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: 14,
              color: isFull ? AppColors.full : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              isFull
                  ? '$attendeeCount / $cap • Full'
                  : '$attendeeCount / $cap attending ($spotsRemaining spot${spotsRemaining == 1 ? '' : 's'} left)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isFull || isNearFull
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: isFull
                    ? AppColors.full
                    : (isNearFull
                          ? AppColors.studyPrimary
                          : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
        if (showBar) ...[
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5,
              backgroundColor: AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ],
    );
  }
}
