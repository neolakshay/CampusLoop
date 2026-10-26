import 'dart:async';
import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/foundation.dart';

import '../client.dart';

/// Central state manager for activities, feed, RSVP, and plans.
class ActivityState extends ChangeNotifier {
  static const int _pageSize = 20;

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

  // -------------------------------------------------------------
  // Feed operations
  // -------------------------------------------------------------

  Future<void> loadFeed({bool refresh = false}) async {
    if (refresh) {
      _isRefreshing = true;
      _hasMoreFeed = true;
      _feedError = null;
    } else {
      if (_isLoadingFeed || _isLoadingMore) return;
      _isLoadingFeed = _feedActivities.isEmpty;
      _feedError = null;
    }
    notifyListeners();

    final offset = refresh ? 0 : _feedActivities.length;

    try {
      final items = await client.activity.listUpcoming(
        _selectedKind,
        _pageSize,
        offset,
      );

      if (refresh) {
        _feedActivities.clear();
      }

      final existingIds = _feedActivities.map((a) => a.id).toSet();
      for (final item in items) {
        if (item.id != null && !existingIds.contains(item.id)) {
          _feedActivities.add(item);
          existingIds.add(item.id);
        }
      }

      _hasMoreFeed = items.length >= _pageSize;
      _feedError = null;
    } catch (e) {
      _feedError = parseErrorMessage(e);
    } finally {
      _isLoadingFeed = false;
      _isRefreshing = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreFeed() async {
    if (!_hasMoreFeed || _isLoadingMore || _isLoadingFeed || _isRefreshing) {
      return;
    }
    _isLoadingMore = true;
    notifyListeners();

    try {
      final items = await client.activity.listUpcoming(
        _selectedKind,
        _pageSize,
        _feedActivities.length,
      );

      final existingIds = _feedActivities.map((a) => a.id).toSet();
      for (final item in items) {
        if (item.id != null && !existingIds.contains(item.id)) {
          _feedActivities.add(item);
          existingIds.add(item.id);
        }
      }

      _hasMoreFeed = items.length >= _pageSize;
    } catch (e) {
      // Do not replace whole feed error, just stop loading more
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void setKindFilter(ActivityKind? kind) {
    if (_selectedKind == kind) return;
    _selectedKind = kind;
    notifyListeners();
    loadFeed(refresh: true);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // -------------------------------------------------------------
  // My Plans operations
  // -------------------------------------------------------------

  Future<void> loadMyPlans({bool refresh = false}) async {
    _isLoadingPlans = true;
    _plansError = null;
    notifyListeners();

    try {
      final plans = await client.activity.listMyPlans(30, 0);
      _myPlans.clear();
      _myPlans.addAll(plans);
    } catch (e) {
      _plansError = parseErrorMessage(e);
    } finally {
      _isLoadingPlans = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // Activity Details
  // -------------------------------------------------------------

  Future<ActivityDetails?> fetchDetails(int activityId) async {
    try {
      final details = await client.activity.getActivity(activityId);
      if (details != null) {
        _detailsCache[activityId] = details;
        _updateActivityInLists(details.activity);
        notifyListeners();
      }
      return details;
    } catch (e) {
      return null;
    }
  }

  // -------------------------------------------------------------
  // Create Activity
  // -------------------------------------------------------------

  Future<ActivityDetails> createActivity(CreateActivityRequest request) async {
    _isCreating = true;
    notifyListeners();

    try {
      final details = await client.activity.createActivity(request);
      final newActivity = details.activity;
      final id = newActivity.id;
      if (id != null) {
        _detailsCache[id] = details;
      }

      // Insert into feed and maintain chronological ordering by startsAt
      if (_selectedKind == null || _selectedKind == newActivity.kind) {
        _feedActivities.removeWhere((a) => a.id == newActivity.id);
        _feedActivities.add(newActivity);
        _feedActivities.sort((a, b) {
          final byStart = a.startsAt.compareTo(b.startsAt);
          if (byStart != 0) return byStart;
          return (a.id ?? 0).compareTo(b.id ?? 0);
        });
      }

      // Add to my plans and maintain chronological ordering by startsAt
      _myPlans.removeWhere((p) => p.activity.id == newActivity.id);
      _myPlans.add(
        ActivityPlan(
          activity: newActivity,
          isOrganizer: true,
          isAttending: true,
          joinedAt: DateTime.now().toUtc(),
        ),
      );
      _myPlans.sort((a, b) {
        final byStart = a.activity.startsAt.compareTo(b.activity.startsAt);
        if (byStart != 0) return byStart;
        return (a.activity.id ?? 0).compareTo(b.activity.id ?? 0);
      });

      return details;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // Join / Leave / Cancel actions
  // -------------------------------------------------------------

  Future<ActivityDetails> joinActivity(int activityId) async {
    _pendingActionIds.add(activityId);
    notifyListeners();

    try {
      final updatedDetails = await client.activity.joinActivity(activityId);
      _detailsCache[activityId] = updatedDetails;
      _updateActivityInLists(updatedDetails.activity);

      // Update plans list
      final planIndex = _myPlans.indexWhere((p) => p.activity.id == activityId);
      if (planIndex >= 0) {
        _myPlans[planIndex] = ActivityPlan(
          activity: updatedDetails.activity,
          isOrganizer: updatedDetails.isOrganizer,
          isAttending: true,
          joinedAt: _myPlans[planIndex].joinedAt ?? DateTime.now().toUtc(),
        );
      } else {
        _myPlans.add(
          ActivityPlan(
            activity: updatedDetails.activity,
            isOrganizer: updatedDetails.isOrganizer,
            isAttending: true,
            joinedAt: DateTime.now().toUtc(),
          ),
        );
        _myPlans.sort((a, b) {
          final byStart = a.activity.startsAt.compareTo(b.activity.startsAt);
          if (byStart != 0) return byStart;
          return (a.activity.id ?? 0).compareTo(b.activity.id ?? 0);
        });
      }

      return updatedDetails;
    } finally {
      _pendingActionIds.remove(activityId);
      notifyListeners();
    }
  }

  Future<ActivityDetails> leaveActivity(int activityId) async {
    _pendingActionIds.add(activityId);
    notifyListeners();

    try {
      final updatedDetails = await client.activity.leaveActivity(activityId);
      _detailsCache[activityId] = updatedDetails;
      _updateActivityInLists(updatedDetails.activity);

      // Remove or update from plans
      _myPlans.removeWhere(
        (p) => p.activity.id == activityId && !p.isOrganizer,
      );
      final planIndex = _myPlans.indexWhere((p) => p.activity.id == activityId);
      if (planIndex >= 0) {
        _myPlans[planIndex] = ActivityPlan(
          activity: updatedDetails.activity,
          isOrganizer: true,
          isAttending: false,
          joinedAt: null,
        );
      }

      return updatedDetails;
    } finally {
      _pendingActionIds.remove(activityId);
      notifyListeners();
    }
  }

  Future<ActivityDetails> cancelActivity(int activityId) async {
    _pendingActionIds.add(activityId);
    notifyListeners();

    try {
      final updatedDetails = await client.activity.cancelActivity(activityId);
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

      return updatedDetails;
    } finally {
      _pendingActionIds.remove(activityId);
      notifyListeners();
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
