import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';

import '../state/activity_state.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';
import '../widgets/filter_bar.dart';
import 'activity_details_screen.dart';

class FeedScreen extends StatefulWidget {
  final ActivityState state;
  final VoidCallback onNavigateToCreate;

  const FeedScreen({
    super.key,
    required this.state,
    required this.onNavigateToCreate,
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.state.loadMoreFeed();
    }
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

  Future<void> _quickJoin(CampusActivity activity) async {
    final id = activity.id;
    if (id == null) return;
    try {
      await widget.state.joinActivity(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('RSVP confirmed for "${activity.title}"!'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ActivityState.parseErrorMessage(e)),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Column(
      children: [
        FilterBar(
          selectedKind: state.selectedKind,
          onKindSelected: state.setKindFilter,
          searchQuery: state.searchQuery,
          onSearchChanged: state.setSearchQuery,
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              if (state.isLoadingFeed) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.feedError != null && state.feedActivities.isEmpty) {
                return ErrorView(
                  message: state.feedError!,
                  onRetry: () => state.loadFeed(refresh: true),
                );
              }

              if (state.feedActivities.isEmpty) {
                final hasFilter =
                    state.selectedKind != null || state.searchQuery.isNotEmpty;
                return RefreshIndicator(
                  onRefresh: () => state.loadFeed(refresh: true),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: EmptyState(
                          icon: hasFilter
                              ? Icons.search_off_rounded
                              : Icons.event_available_rounded,
                          title: hasFilter
                              ? 'No matching activities'
                              : 'No upcoming activities',
                          message: hasFilter
                              ? 'Try adjusting your search terms or filter chips.'
                              : 'Be the first student to post an event or study session for campus!',
                          actionLabel: hasFilter
                              ? 'Clear Filters'
                              : 'Post Activity',
                          actionIcon: hasFilter
                              ? Icons.filter_alt_off_rounded
                              : Icons.add_rounded,
                          onAction: hasFilter
                              ? () {
                                  state.setKindFilter(null);
                                  state.setSearchQuery('');
                                }
                              : widget.onNavigateToCreate,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => state.loadFeed(refresh: true),
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount:
                      state.feedActivities.length +
                      (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == state.feedActivities.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    final activity = state.feedActivities[index];
                    final cachedDetails = activity.id != null
                        ? state.getCachedDetails(activity.id!)
                        : null;
                    final isAttending = activity.id != null
                        ? state.isUserAttending(activity.id!)
                        : false;
                    final isOrganizer = activity.id != null
                        ? state.isUserOrganizer(activity.id!)
                        : false;

                    return ActivityCard(
                      activity: activity,
                      cachedDetails: cachedDetails,
                      isAttending: isAttending,
                      isOrganizer: isOrganizer,
                      isActionPending:
                          activity.id != null &&
                          state.isActionPending(activity.id!),
                      onTap: () => _openDetails(activity),
                      onQuickJoin: isAttending || isOrganizer
                          ? null
                          : () => _quickJoin(activity),
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
