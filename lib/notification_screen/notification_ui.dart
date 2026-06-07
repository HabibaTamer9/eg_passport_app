import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/customs/custom_button.dart';
import 'package:eg_passport_app/customs/custom_container.dart';
import 'package:eg_passport_app/customs/filter_item.dart';
import 'package:eg_passport_app/notification_screen/notification_cubit.dart';

import 'package:eg_passport_app/notification_screen/notification_details_screen.dart';
import 'package:eg_passport_app/notification_screen/notification_model.dart';
import 'package:eg_passport_app/notification_screen/notification_state.dart';
import 'package:eg_passport_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationUi extends StatelessWidget {
  const NotificationUi({super.key});

  String formatTime(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} h ago";
    }

    return "${difference.inDays} d ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is! NotificationLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<NotificationCubit>();
          final filteredNotifications = cubit.getDisplayedNotifications();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Notification".tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    "Notification_subtitle".tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  SizedBox(height: 12.h),

                  SizedBox(
                    height: 100.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        FilterItem(
                          title: "All".tr(),
                          icon: Icons.article_outlined,
                          isSelected:
                              state.selectedFilter == NotificationType.all,
                          onTap: () {
                            cubit.changeFilter(NotificationType.all);
                          },
                        ),

                        SizedBox(width: 5.w),

                        FilterItem(
                          title: "Unread".tr(),
                          icon: Icons.mark_email_unread_outlined,
                          isSelected:
                              state.selectedFilter == NotificationType.unread,
                          onTap: () {
                            cubit.changeFilter(NotificationType.unread);
                          },
                        ),

                        SizedBox(width: 5.w),

                        FilterItem(
                          title: "Requests".tr(),
                          icon: Icons.description_outlined,
                          isSelected:
                              state.selectedFilter == NotificationType.requests,
                          onTap: () {
                            cubit.changeFilter(NotificationType.requests);
                          },
                        ),

                        SizedBox(width: 5.w),

                        FilterItem(
                          title: "Documents".tr(),
                          icon: Icons.folder,
                          isSelected:
                              state.selectedFilter ==
                              NotificationType.documents,
                          onTap: () {
                            cubit.changeFilter(NotificationType.documents);
                          },
                        ),

                        SizedBox(width: 5.w),

                        FilterItem(
                          title: "Alerts".tr(),
                          icon: Icons.warning_amber_outlined,
                          isSelected:
                              state.selectedFilter == NotificationType.alerts,
                          onTap: () {
                            cubit.changeFilter(NotificationType.alerts);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];

                        return CustomContainer(
                          onTap: () {
                            cubit.markAsRead(notification);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NotificationDetailsScreen(
                                  notification: notification,
                                ),
                              ),
                            );
                          },
                          color: AppColors.primaryRedColor,
                          icon: Icons.notifications,
                          title: notification.title,
                          subtitle: notification.body,
                          date: formatTime(notification.createdAt),
                          statue: notification.isRead
                              ? "Read".tr()
                              : "New".tr(),
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    textName: "Load More",
                    backgroundColor: AppColors.primaryRedColor,
                    onPressed: () {
                      context.read<NotificationCubit>().loadMore();
                    },
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
