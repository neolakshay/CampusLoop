import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class KindBadge extends StatelessWidget {
  final ActivityKind kind;
  final bool isCompact;

  const KindBadge({
    super.key,
    required this.kind,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEvent = kind == ActivityKind.event;
    final primary = isEvent ? AppColors.eventPrimary : AppColors.studyPrimary;
    final bg = isEvent ? AppColors.eventBackground : AppColors.studyBackground;
    final icon = isEvent ? Icons.event_rounded : Icons.school_rounded;
    final label = isEvent ? 'Campus Event' : 'Study Session';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isCompact ? 12 : 14, color: primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: primary,
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
