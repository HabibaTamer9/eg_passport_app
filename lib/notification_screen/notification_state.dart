import 'package:eg_passport_app/notification_screen/notification_model.dart';


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