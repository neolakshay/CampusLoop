import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final ActivityStatus status;
  final bool isFull;

  const StatusBadge({
    super.key,
    required this.status,
    this.isFull = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (status == ActivityStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.cancelled.withValues(alpha: 0.15)
              : AppColors.cancelledBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.cancelled.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel_rounded, size: 12, color: AppColors.cancelled),
            SizedBox(width: 4),
            Text(
              'Cancelled',
              style: TextStyle(
                color: AppColors.cancelled,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    if (isFull) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.full.withValues(alpha: 0.15)
              : AppColors.fullBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.full.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt_rounded, size: 12, color: AppColors.full),
            SizedBox(width: 4),
            Text(
              'Full',
              style: TextStyle(
                color: AppColors.full,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
