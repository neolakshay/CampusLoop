import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'activity_service.dart';

class ActivityEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<CampusActivity>> listUpcoming(
    Session session,
    ActivityKind? kind,
    int limit,
    int offset,
  ) {
    return ActivityService.listUpcoming(
      session,
      kind: kind,
      limit: limit,
      offset: offset,
    );
  }

  Future<ActivityDetails?> getActivity(
    Session session,
    int activityId,
  ) {
    return ActivityService.getActivity(session, activityId);
  }

  Future<ActivityDetails> createActivity(
    Session session,
    CreateActivityRequest request,
  ) {
    return ActivityService.createActivity(session, request);
  }

  Future<ActivityDetails> joinActivity(
    Session session,
    int activityId,
  ) {
    return ActivityService.joinActivity(session, activityId);
  }

  Future<ActivityDetails> leaveActivity(
    Session session,
    int activityId,
  ) {
    return ActivityService.leaveActivity(session, activityId);
  }

  Future<ActivityDetails> cancelActivity(
    Session session,
    int activityId,
  ) {
    return ActivityService.cancelActivity(session, activityId);
  }

  Future<List<ActivityPlan>> listMyPlans(
    Session session,
    int limit,
    int offset,
  ) {
    return ActivityService.listMyPlans(
      session,
      limit: limit,
      offset: offset,
    );
  }
}
