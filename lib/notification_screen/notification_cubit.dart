import 'package:eg_passport_app/notification_screen/notification_data.dart';
import 'package:eg_passport_app/notification_screen/notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  
  NotificationCubit() : super(NotificationInitial()) {
    loadNotifications();
  }

   NotificationType selectedFilter = NotificationType.all;

  int currentPage = 1;
  final int pageSize = 10;

  void loadNotifications() {
    emit(
      NotificationLoaded(
        notifications: notifications,
        selectedFilter: selectedFilter,
      ),
    );
  }

  void changeFilter(NotificationType filter) {
  selectedFilter = filter;

  currentPage = 1;

  emit(
    NotificationLoaded(
      notifications: notifications,
      selectedFilter: selectedFilter,
    ),
  );
}

  void markAsRead(NotificationModel notification) {
    notification.isRead = true;

    emit(
      NotificationLoaded(
        notifications: notifications,
        selectedFilter: selectedFilter,
      ),
    );
  }

  List<NotificationModel> getFilteredNotifications() {
    if (selectedFilter == NotificationType.all) {
      return notifications;
    }

    if (selectedFilter == NotificationType.unread) {
      return notifications.where((e) => !e.isRead).toList();
    }

    if (selectedFilter == NotificationType.requests) {
      return notifications.where((e) => e.type == "request").toList();
    }

    if (selectedFilter == NotificationType.documents) {
      return notifications.where((e) => e.type == "document").toList();
    }

    if (selectedFilter == NotificationType.alerts) {
      return notifications.where((e) => e.type == "alert").toList();
    }

    return notifications;
  }
  List<NotificationModel> getDisplayedNotifications() {
  final filtered = getFilteredNotifications();

  final endIndex = currentPage * pageSize;

  if (endIndex >= filtered.length) {
    return filtered;
  }

  return filtered.sublist(0, endIndex);
}
void loadMore() {
  currentPage++;

  emit(
    NotificationLoaded(
      notifications: notifications,
      selectedFilter: selectedFilter,
    ),
  );
}
}