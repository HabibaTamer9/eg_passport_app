import 'package:eg_passport_app/notification_screen/notification_model.dart';

List<NotificationModel> notifications = List.generate(
  25,
  (index) => NotificationModel(
    id: index + 1,
    title: "Notification ${index + 1}",
    body: "This is notification number ${index + 1}",
    type: index % 3 == 0
        ? "alert"
        : index % 3 == 1
            ? "request"
            : "document",
    isRead: index % 2 == 0,
    createdAt: DateTime.now().subtract(
      Duration(minutes: index * 10),
    ),
  ),
);