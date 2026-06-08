import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/data/app_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Api/api_helper.dart';
import '../../../core/Api/endpoint.dart';
import '../data/list_notifications_model.dart';
import '../data/notification_model.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    getNotifications();
  }

  NotificationType selectedFilter = NotificationType.all;
  late List<NotificationModel> notifications ;

  int currentPage = 1;
  final int pageSize = 10;

  Future<void> getNotifications() async {
    emit(NotificationLoading());
    try {
      var response = await ApiHelper().getAPI(
        "${Endpoint.my}${Endpoint.notifications}",
      );
      print("======================notification : $response");

      if (response["success"] != true) {
        emit(NotificationsError(response["message"]));
        return;
      }

      AppData.notification = ListNotificationsModel.fromJson(response["data"]);
      notifications = AppData.notification.notifications;
      emit(NotificationLoaded(
        notifications: AppData.notification.notifications,
        selectedFilter: selectedFilter,
      ));
    } catch (e) {
      emit(NotificationsError("notificationsError:${"errorMessage".tr()}"));
    }
  }

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

  void markAsRead(NotificationModel notification) async{
    notification.isRead = true;
    try {
      var response = await ApiHelper().getAPI(
        "${Endpoint.my}${Endpoint.notifications}/${notification.id}/read",
      );
      print("======================notification : $response");

      if (response["success"] != true) {
        emit(NotificationsError(response["message"]));
        return;
      }
      emit(NotificationLoaded(
        notifications: AppData.notification.notifications,
        selectedFilter: selectedFilter,
      ));
    } catch (e) {
      print(e);
      emit(NotificationsError("notificationsError:${"errorMessage".tr()}"));
    }

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
