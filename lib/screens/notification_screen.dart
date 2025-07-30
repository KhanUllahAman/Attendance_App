import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/models/notification_model.dart';
import '../Controllers/notification_controller.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = '/notificationScreen';
  final NotificationController controller = Get.find<NotificationController>(); // Use Get.find to reuse existing controller

  NotificationScreen({super.key}) {
    Future.delayed(Duration.zero, () {
      controller.fetchAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        title: "Notifications",
        currentTab: 2,
        showAppBar: true,
        showBackButton: true,
        showLogo: true,
        body: Obx(() {
          if (controller.connectionType.value == 0) {
            return buildFullScreenOfflineUI(mq);
          }

          return Padding(
            padding: EdgeInsets.all(mq.size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification &&
                              scrollNotification.metrics.extentAfter == 0) {
                            controller.fetchAllNotifications();
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          elevation: 0.0,
                          color: ColorResources.backgroundWhiteColor,
                          backgroundColor: ColorResources.appMainColor,
                          onRefresh: () async {
                            await Future.delayed(Duration(milliseconds: 100));
                            await controller.fetchAllNotifications();
                          },
                          child: _buildNotificationsList(mq),
                        ),
                      ),
                      if (controller.isLoading.value &&
                          controller.notificationsList.isEmpty)
                        Apploader(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotificationsList(MediaQueryData mq) {
    if (controller.errorMessage.value.isNotEmpty &&
        controller.filteredNotifications.isEmpty) {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Text(
            controller.errorMessage.value,
            style: GoogleFonts.sora(color: ColorResources.blackColor),
          ),
        ),
      );
    }

    if (controller.notificationsList.isEmpty) {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Text(
            "No notifications found",
            style: GoogleFonts.sora(color: ColorResources.blackColor),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: controller.filteredNotifications.length,
      separatorBuilder: (_, __) => SizedBox(height: 14),
      itemBuilder: (context, index) {
        final notification = controller.filteredNotifications[index];
        return GestureDetector(
          onTap: () {
            _showNotificationDetails(context, mq, notification);
          },
          child: Container(
            padding: EdgeInsets.all(mq.size.width * 0.04),
            decoration: BoxDecoration(
              color: ColorResources.blackColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: GoogleFonts.sora(
                    fontSize: mq.size.width * 0.035,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.blackColor,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    _buildTag(
                      notification.type.capitalize.toString(),
                      ColorResources.appMainColor,
                      mq,
                    ),
                    SizedBox(width: 6),
                    _buildTag(
                      notification.priority.capitalize.toString(),
                      notification.priorityColor,
                      mq,
                    ),
                    // SizedBox(width: 6),
                    // _buildTag(
                    //   notification.status.capitalize.toString(),
                    //   notification.statusColor,
                    //   mq,
                    // ),
                    Spacer(),
                    Text(
                      notification.formattedSentAt,
                      style: GoogleFonts.sora(
                        fontSize: mq.size.width * 0.03,
                        color: ColorResources.blackColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color, MediaQueryData mq) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.sora(
          color: color,
          fontSize: mq.size.width * 0.03,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showNotificationDetails(
    BuildContext context,
    MediaQueryData mq,
    NotificationModel notification,
  ) async {
    // Show loading dialog immediately when tapping
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: Apploader()),
    );

    final detailedNotification = await controller.fetchNotificationDetails(
      notification.id,
    );

    // Close the loading dialog
    Navigator.of(context).pop();

    if (detailedNotification == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorResources.backgroundWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: mq.size.width * 0.05,
            right: mq.size.width * 0.05,
            top: mq.size.height * 0.025,
            bottom: mq.viewInsets.bottom + mq.size.height * 0.03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: ColorResources.greyColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: mq.size.height * 0.025),
              Text(
                detailedNotification.title,
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.blackColor,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildTag(
                    detailedNotification.type.capitalize.toString(),
                    ColorResources.appMainColor,
                    mq,
                  ),
                  SizedBox(width: 8),
                  _buildTag(
                    detailedNotification.priority.capitalize.toString(),
                    detailedNotification.priorityColor,
                    mq,
                  ),
                  Spacer(),
                  Icon(
                    Icons.access_time,
                    size: mq.size.width * 0.045,
                    color: ColorResources.blackColor,
                  ),
                  SizedBox(width: 6),
                  Text(
                    detailedNotification.formattedSentAt,
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.03,
                      color: ColorResources.blackColor,
                    ),
                  ),
                ],
              ),
              Divider(height: mq.size.height * 0.035, color: Colors.white10),
              Text(
                "Message",
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.038,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.blackColor,
                ),
              ),
              SizedBox(height: 0),
              Text(
                detailedNotification.message,
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.035,
                  color: ColorResources.blackColor,
                  height: 1.5,
                ),
              ),
              SizedBox(height: mq.size.height * 0.035),
            ],
          ),
        );
      },
    );
  }
}
