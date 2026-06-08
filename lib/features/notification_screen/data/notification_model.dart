import 'package:eg_passport_app/core/data/app_data.dart';

enum NotificationType { all, unread, requests, documents, alerts }

class NotificationModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String type;
  bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      bodyAr: json['bodyAr'] ?? '',
      bodyEn: json['bodyEn'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
