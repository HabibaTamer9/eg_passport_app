import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/models/passport_model.dart';
import 'package:eg_passport_app/core/models/user_model.dart';
import 'package:eg_passport_app/features/notification_screen/data/list_notifications_model.dart';
import 'package:eg_passport_app/features/notification_screen/data/notification_model.dart';

class AppData {
  static late UserModel user ;
  static late PassportModel passport;
  static late ListNotificationsModel notification;
  static bool isArabic = true;


  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '';

    final dateStr = date.toString().trim();

    if (dateStr.isEmpty) return '';

    // نجرب DateTime.parse الأول
    try {
      final date = DateTime.parse(dateStr);
      print("${DateFormat('dd MMMM yyyy').format(date)}");
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (_) {}

    final formats = [
      'yyyy-MM-ddTHH:mm:ss',
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'dd/MM/yyyy',
    ];

    for (final format in formats) {
      try {
        final parsedDate = DateFormat(format).parse(date);
        return DateFormat('dd MMMM yyyy').format(parsedDate);
      } catch (_) {}
    }

    return date;
  }
}
