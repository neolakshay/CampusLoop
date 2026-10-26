import 'dart:async';
import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/foundation.dart';

import '../client.dart';

/// Central state manager for activities, feed, RSVP, and plans.
class ActivityState extends ChangeNotifier {
  static const int _pageSize = 20;

  bool _disposed = false;
  int _feedRequestGeneration = 0;
  int _plansRequestGeneration = 0;
  int _nextFeedOffset = 0;

  // --- Feed State ---
  final List<CampusActivity> _feedActivities = [];
  List<CampusActivity> get feedActivities {
    if (_searchQuery.trim().isEmpty) {
      return List.unmodifiable(_feedActivities);
    }
    final q = _searchQuery.trim().toLowerCase();
    return _feedActivities.where((a) {
      final titleMatch = a.title.toLowerCase().contains(q);
      final topicMatch = a.topic?.toLowerCase().contains(q) ?? false;
      final locationMatch = a.location.toLowerCase().contains(q);
      final organizerMatch = a.organizerName.toLowerCase().contains(q);
      return titleMatch || topicMatch || locationMatch || organizerMatch;
    }).toList();
  }

  ActivityKind? _selectedKind;
  ActivityKind? get selectedKind => _selectedKind;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoadingFeed = false;
  bool get isLoadingFeed => _isLoadingFeed;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMoreFeed = true;
  bool get hasMoreFeed => _hasMoreFeed;

  String? _feedError;
  String? get feedError => _feedError;

  String? _feedLoadMoreError;
  String? get feedLoadMoreError => _feedLoadMoreError;

  // --- My Plans State ---
  final List<ActivityPlan> _myPlans = [];
  List<ActivityPlan> get myPlans => List.unmodifiable(_myPlans);

  bool _isLoadingPlans = false;
  bool get isLoadingPlans => _isLoadingPlans;

  String? _plansError;
  String? get plansError => _plansError;

  // --- Details Cache & Action State ---
  final Map<int, ActivityDetails> _detailsCache = {};
  ActivityDetails? getCachedDetails(int id) => _detailsCache[id];

  /// Checks if the current student is attending the given activity
  bool isUserAttending(int activityId) {
    final cached = _detailsCache[activityId];
    if (cached != null) return cached.isAttending;
    return _myPlans.any((p) => p.activity.id == activityId && p.isAttending);
  }

  /// Checks if the current student is the organizer of the given activity
  bool isUserOrganizer(int activityId) {
    final cached = _detailsCache[activityId];
    if (cached != null) return cached.isOrganizer;
    return _myPlans.any((p) => p.activity.id == activityId && p.isOrganizer);
  }

  /// Returns attendee count from cached details if available
  int? getAttendeeCount(int activityId) {
    return _detailsCache[activityId]?.attendeeCount;
  }

  final Set<int> _pendingActionIds = {};
  bool isActionPending(int id) => _pendingActionIds.contains(id);

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notifyListeners() {
    if (!_disposed) notifyListeners();
  }

  // -------------------------------------------------------------
  // Feed operations
  // -------------------------------------------------------------

  Future<void> loadFeed({bool refresh = false}) async {
    if (_disposed) return;
    if (!refresh && (_isLoadingFeed || _isLoadingMore)) return;

    final requestGeneration = ++_feedRequestGeneration;
    if (refresh) {
      _isRefreshing = true;
      _isLoadingFeed = _feedActivities.isEmpty;
      _isLoadingMore = false;
      _hasMoreFeed = true;
      _feedError = null;
      _feedLoadMoreError = null;
    } else {
      _isLoadingFeed = _feedActivities.isEmpty;
      _feedError = null;
    }
    _notifyListeners();

    final offset = refresh ? 0 : _nextFeedOffset;

    try {
      final items = await client.activity.listUpcoming(
        _selectedKind,
        _pageSize,
        offset,
      );

      if (refresh) {
        _feedActivities.clear();
      }

      _appendUniqueActivities(items);
      _nextFeedOffset = offset + items.length;

      _hasMoreFeed = items.length >= _pageSize;
      _feedError = null;
      _feedLoadMoreError = null;
    } catch (e) {
      if (!_disposed && requestGeneration == _feedRequestGeneration) {
        _feedError = parseErrorMessage(e);
      }
    } finally {
      if (!_disposed && requestGeneration == _feedRequestGeneration) {
        _isLoadingFeed = false;
        _isRefreshing = false;
        _isLoadingMore = false;
        _notifyListeners();
      }
    }
  }

  Future<void> loadMoreFeed({bool retry = false}) async {
    if (_disposed ||
        !_hasMoreFeed ||
        _isLoadingMore ||
        _isLoadingFeed ||
        _isRefreshing ||
        (_feedLoadMoreError != null && !retry)) {
      return;
    }
    final requestGeneration = _feedRequestGeneration;
    _isLoadingMore = true;
    _feedLoadMoreError = null;
    _notifyListeners();

    try {
      final items = await client.activity.listUpcoming(
        _selectedKind,
        _pageSize,
        _nextFeedOffset,
      );
      if (_disposed || requestGeneration != _feedRequestGeneration) return;

      _appendUniqueActivities(items);
      _nextFeedOffset += items.length;

      _hasMoreFeed = items.length >= _pageSize;
    } catch (e) {
      if (!_disposed && requestGeneration == _feedRequestGeneration) {
        _feedLoadMoreError = parseErrorMessage(e);
      }
    } finally {
      if (!_disposed && requestGeneration == _feedRequestGeneration) {
        _isLoadingMore = false;
        _notifyListeners();
      }
    }
  }

  void setKindFilter(ActivityKind? kind) {
    if (_selectedKind == kind) return;
    _selectedKind = kind;
    _notifyListeners();
    loadFeed(refresh: true);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _notifyListeners();
  }

  // -------------------------------------------------------------
  // My Plans operations
  // -------------------------------------------------------------

  Future<void> loadMyPlans({bool refresh = false}) async {
    if (_disposed || (_isLoadingPlans && !refresh)) return;
    final requestGeneration = ++_plansRequestGeneration;
    _isLoadingPlans = true;
    _plansError = null;
    _notifyListeners();

    try {
      final plans = await client.activity.listMyPlans(30, 0);
      if (_disposed || requestGeneration != _plansRequestGeneration) return;
      _myPlans.clear();
      _myPlans.addAll(plans);
    } catch (e) {
      if (!_disposed && requestGeneration == _plansRequestGeneration) {
        _plansError = parseErrorMessage(e);
      }
    } finally {
      if (!_disposed && requestGeneration == _plansRequestGeneration) {
        _isLoadingPlans = false;
        _notifyListeners();
      }
    }
  }

  // -------------------------------------------------------------
  // Activity Details
  // -------------------------------------------------------------

  Future<ActivityDetails?> fetchDetails(int activityId) async {
    if (_disposed) return null;
    final details = await client.activity.getActivity(activityId);
    if (_disposed) return details;
    if (details != null) {
      _detailsCache[activityId] = details;
      _updateActivityInLists(details.activity);
      _notifyListeners();
    }
    return details;
  }

  // -------------------------------------------------------------
  // Create Activity
  // -------------------------------------------------------------

  Future<ActivityDetails> createActivity(CreateActivityRequest request) async {
    if (_disposed) {
      throw StateError('Activity state is no longer active.');
    }
    _isCreating = true;
    _notifyListeners();

    try {
      final details = await client.activity.createActivity(request);
      if (_disposed) return details;
      final newActivity = details.activity;
      final id = newActivity.id;
      if (id != null) {
        _detailsCache[id] = details;
      }

      _upsertPlan(
        ActivityPlan(
          activity: newActivity,
          isOrganizer: true,
          isAttending: true,
          joinedAt: DateTime.now().toUtc(),
        ),
      );
      // Reload the server's ordered page rather than prepending an activity
      // that may start after the current page boundary.
      await loadFeed(refresh: true);

      return details;
    } finally {
      if (!_disposed) {
        _isCreating = false;
        _notifyListeners();
      }
    }
  }

  // -------------------------------------------------------------
  // Join / Leave / Cancel actions
  // -------------------------------------------------------------

  Future<ActivityDetails> joinActivity(int activityId) async {
    if (_disposed) {
      throw StateError('Activity state is no longer active.');
    }
    _pendingActionIds.add(activityId);
    _notifyListeners();

    try {
      final updatedDetails = await client.activity.joinActivity(activityId);
      if (_disposed) return updatedDetails;
      _detailsCache[activityId] = updatedDetails;
      _updateActivityInLists(updatedDetails.activity);

      final existingPlanIndex = _myPlans.indexWhere(
        (plan) => plan.activity.id == activityId,
      );
      _upsertPlan(
        ActivityPlan(
          activity: updatedDetails.activity,
          isOrganizer: updatedDetails.isOrganizer,
          isAttending: true,
          joinedAt: existingPlanIndex < 0
              ? DateTime.now().toUtc()
              : _myPlans[existingPlanIndex].joinedAt ?? DateTime.now().toUtc(),
        ),
      );

      return updatedDetails;
    } finally {
      if (!_disposed) {
        _pendingActionIds.remove(activityId);
        _notifyListeners();
      }
    }
  }

  Future<ActivityDetails> leaveActivity(int activityId) async {
    if (_disposed) {
      throw StateError('Activity state is no longer active.');
    }
    _pendingActionIds.add(activityId);
    _notifyListeners();

    try {
      final updatedDetails = await client.activity.leaveActivity(activityId);
      if (_disposed) return updatedDetails;
      _detailsCache[activityId] = updatedDetails;
      _updateActivityInLists(updatedDetails.activity);

      // Remove or update from plans
      _myPlans.removeWhere((plan) => plan.activity.id == activityId);

      return updatedDetails;
    } finally {
      if (!_disposed) {
        _pendingActionIds.remove(activityId);
        _notifyListeners();
      }
    }
  }

  Future<ActivityDetails> cancelActivity(int activityId) async {
    if (_disposed) {
      throw StateError('Activity state is no longer active.');
    }
    _pendingActionIds.add(activityId);
    _notifyListeners();

    try {
      final updatedDetails = await client.activity.cancelActivity(activityId);
      if (_disposed) return updatedDetails;
      _detailsCache[activityId] = updatedDetails;

      // Cancelled activities are removed from upcoming feed per backend rules
      _feedActivities.removeWhere((a) => a.id == activityId);

      // In plans, update status to cancelled
      final planIndex = _myPlans.indexWhere((p) => p.activity.id == activityId);
      if (planIndex >= 0) {
        _myPlans[planIndex] = ActivityPlan(
          activity: updatedDetails.activity,
          isOrganizer: updatedDetails.isOrganizer,
          isAttending: updatedDetails.isAttending,
          joinedAt: _myPlans[planIndex].joinedAt,
        );
      }

      await loadFeed(refresh: true);

      return updatedDetails;
    } finally {
      if (!_disposed) {
        _pendingActionIds.remove(activityId);
        _notifyListeners();
      }
    }
  }

  void _updateActivityInLists(CampusActivity activity) {
    final feedIndex = _feedActivities.indexWhere((a) => a.id == activity.id);
    if (feedIndex >= 0) {
      if (activity.status == ActivityStatus.cancelled) {
        _feedActivities.removeAt(feedIndex);
      } else {
        _feedActivities[feedIndex] = activity;
      }
    }

    final planIndex = _myPlans.indexWhere((p) => p.activity.id == activity.id);
    if (planIndex >= 0) {
      _myPlans[planIndex] = ActivityPlan(
        activity: activity,
        isOrganizer: _myPlans[planIndex].isOrganizer,
        isAttending: _myPlans[planIndex].isAttending,
        joinedAt: _myPlans[planIndex].joinedAt,
      );
    }
  }

  void _appendUniqueActivities(List<CampusActivity> activities) {
    final existingIds = _feedActivities
        .map((activity) => activity.id)
        .whereType<int>()
        .toSet();
    for (final activity in activities) {
      final id = activity.id;
      if (id == null || existingIds.add(id)) {
        _feedActivities.add(activity);
      }
    }
  }

  void _upsertPlan(ActivityPlan plan) {
    final index = _myPlans.indexWhere(
      (existing) => existing.activity.id == plan.activity.id,
    );
    if (index < 0) {
      _myPlans.add(plan);
    } else {
      _myPlans[index] = plan;
    }
    _sortMyPlans();
  }

  void _sortMyPlans() {
    _myPlans.sort((a, b) {
      final byStart = a.activity.startsAt.compareTo(b.activity.startsAt);
      if (byStart != 0) return byStart;
      return (a.activity.id ?? 0).compareTo(b.activity.id ?? 0);
    });
  }

  // -------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------

  static String parseErrorMessage(Object error) {
    if (error is ActivityException) {
      return error.message;
    }
    final str = error.toString();
    if (str.contains('SocketException') || str.contains('Connection refused')) {
      return 'Unable to reach the campus server. Please verify the server is running.';
    }
    return str.replaceAll('Exception:', '').trim();
  }
}
