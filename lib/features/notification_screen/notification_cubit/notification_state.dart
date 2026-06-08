
import '../data/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final NotificationType selectedFilter;

  NotificationLoaded({
    required this.notifications,
    required this.selectedFilter,
  });
}
class NotificationsError extends NotificationState {
  final String message;
  NotificationsError(this.message);
}
class NotificationLoading extends NotificationState {}
