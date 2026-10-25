import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FilterBar extends StatelessWidget {
  final ActivityKind? selectedKind;
  final ValueChanged<ActivityKind?> onKindSelected;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const FilterBar({
    super.key,
    required this.selectedKind,
    required this.onKindSelected,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        children: [
          // Search input
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by title, topic, or location...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () => onSearchChanged(''),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All Activities',
                  icon: Icons.all_inclusive_rounded,
                  isSelected: selectedKind == null,
                  onSelected: () => onKindSelected(null),
                  selectedColor: AppColors.primary,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Campus Events',
                  icon: Icons.event_rounded,
                  isSelected: selectedKind == ActivityKind.event,
                  onSelected: () => onKindSelected(ActivityKind.event),
                  selectedColor: AppColors.eventPrimary,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Study Sessions',
                  icon: Icons.school_rounded,
                  isSelected: selectedKind == ActivityKind.studySession,
                  onSelected: () => onKindSelected(ActivityKind.studySession),
                  selectedColor: AppColors.studyPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onSelected,
    required Color selectedColor,
  }) {
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      avatar: Icon(
        icon,
        size: 15,
        color: isSelected ? Colors.white : AppColors.lightTextSecondary,
      ),
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.lightTextPrimary,
      ),
      backgroundColor: Colors.transparent,
      selectedColor: selectedColor,
      checkmarkColor: Colors.white,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? selectedColor : AppColors.lightBorder,
          width: 1,
        ),
      ),
    );
  }
}
