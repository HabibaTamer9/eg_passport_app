import 'package:eg_passport_app/features/notification_screen/data/notification_model.dart';

class ListNotificationsModel {
  final List<NotificationModel> notifications;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  ListNotificationsModel({
    required this.notifications,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory ListNotificationsModel.fromJson(Map<String, dynamic> json) {
    final notifications = (json['items'] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
    return ListNotificationsModel(
      notifications: notifications,
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
      currentPage: json['pageNumber'],
      totalPages: json['totalPages'],
      totalItems: json['totalCount']
    );
  }
}
