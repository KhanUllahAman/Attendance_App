import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Controllers/leave_history_controller.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/notification_screen.dart';

import '../Controllers/apply_leave_controller.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';

class ApplyLeaveScreen extends StatelessWidget {
  static const String routeName = '/applyleaveScreen';

  const ApplyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final LeaveHistoryController leavecontroller =
        Get.find<LeaveHistoryController>();
    final controller = Get.put(ApplyLeaveController());

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (controller.isLoading.value) {
          customSnackBar(
            "Please Wait",
            "Operation in progress. Please wait until it completes.",
            snackBarType: SnackBarType.info,
          );
          return;
        }
        Navigator.of(context).pop();
      },
      child: AnnotatedRegion(
        value: ColorResources.getSystemUiOverlayAllPages(),
        child: Stack(
          children: [
            Layout(
              title: "Apply Leave",
              showBackButton: true,
              currentTab: 1,
              showAppBar: true,
              showLogo: true,
              actionButtons: [
                IconButton(
                  icon: Icon(
                    Iconsax.notification,
                    color: ColorResources.whiteColor,
                  ),
                  onPressed: () {
                    Get.toNamed(NotificationScreen.routeName);
                  },
                ),
              ],
              body: Obx(() {
                if (controller.connectionType.value == 0) {
                  return buildFullScreenOfflineUI(mq);
                }

                // Show loading indicator while fetching leave types
                if (controller.isLoading.value) {
                  return Apploader();
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.size.width * 0.03,
                    vertical: mq.size.width * 0.04,
                  ),
                  child: RefreshIndicator(
                    elevation: 0.0,
                    color: ColorResources.backgroundWhiteColor,
                    backgroundColor: ColorResources.appMainColor,
                    onRefresh: () async {
                      await controller.fetchLeaveTypes();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Only show content if leave types are loaded
                          if (controller.leaveTypesList.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: leavecontroller.leaveSummaryList
                                  .map(
                                    (summary) => _buildQuotaBox(
                                      summary.leaveType,
                                      "${summary.remaining.toString()} / ${summary.totalQuota}",
                                      mq,
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(height: mq.size.height * 0.02),
                            SearchableDropdown(
                              hintText: "Select Leave Type",
                              items: controller.leaveTypesList
                                  .map((type) => type.name)
                                  .toList(),
                              onChange: controller.setLeaveType,
                              fillColor: ColorResources.blackColor.withOpacity(
                                0.05,
                              ),
                              hintColor: Colors.black38,
                              textColor: Colors.black54,
                              dropdownController:
                                  controller.leaveTypeController.value,
                              isEnabled: !controller.isLoading.value,
                            ),
                            SizedBox(height: mq.size.height * 0.02),
                            AbsorbPointer(
                              absorbing: controller.isLoading.value,
                              child: GestureDetector(
                                onTap: () =>
                                    _openDateRangePicker(context, controller),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: mq.size.width * 0.04,
                                    vertical: mq.size.height * 0.015,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorResources.blackColor
                                        .withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Obx(
                                    () => Center(
                                      child: Text(
                                        controller
                                                .selectedDateRangeText
                                                .value
                                                .isEmpty
                                            ? 'Select Date Range'
                                            : controller
                                                  .selectedDateRangeText
                                                  .value,
                                        style: GoogleFonts.sora(
                                          color: controller.isLoading.value
                                              ? Colors.grey
                                              : ColorResources.blackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: mq.size.height * 0.02),
                            AbsorbPointer(
                              absorbing: controller.isLoading.value,
                              child: CustomTextFeild(
                                controller: controller.reasonController,
                                mediaQuery: mq,
                                hintText: "Reason",
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                enabled: !controller.isLoading.value,
                              ),
                            ),
                            SizedBox(height: mq.size.height * 0.02),
                            Obx(
                              () => AppButton(
                                mediaQuery: mq,
                                onPressed: () {
                                  if (!controller.isLoading.value) {
                                    controller.submitLeaveApplication(context);
                                  }
                                },
                                isLoading: controller.isLoading.value,
                                child: Text(
                                  "Submit",
                                  style: GoogleFonts.sora(color: Colors.white),
                                ),
                              ),
                            ),
                          ] else ...[
                            // Show message if no leave types available
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: mq.size.height * 0.3,
                                ),
                                child: Text(
                                  "No leave types available",
                                  style: GoogleFonts.sora(
                                    color: ColorResources.blackColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            Obx(
              () => controller.isLoading.value
                  ? Text('')
                  : const SizedBox.shrink(),
            ),
          ],
        ).noKeyboard(),
      ),
    );
  }

  Widget _buildQuotaBox(String title, String count, MediaQueryData mq) {
    return AbsorbPointer(
      absorbing: Get.find<ApplyLeaveController>().isLoading.value,
      child: Container(
        width: mq.size.width * 0.28,
        padding: EdgeInsets.symmetric(
          vertical: mq.size.height * 0.015,
          horizontal: mq.size.width * 0.02,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorResources.blackColor.withOpacity(0.05),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                color: Get.find<ApplyLeaveController>().isLoading.value
                    ? Colors.grey
                    : ColorResources.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Get.find<ApplyLeaveController>().isLoading.value
                    ? Colors.grey
                    : ColorResources.blackColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDateRangePicker(
    BuildContext context,
    ApplyLeaveController controller,
  ) {
    if (controller.isLoading.value) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: ColorResources.backgroundWhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: CustomDateRangePicker(
          allowPastDates: false,
          allowFutureDates: true,
          firstDate: DateTime.now(),
          onDateRangeSelected: (start, end) {
            controller.setDateRange(start, end);
          },
        ),
      ),
    );
  }
}
