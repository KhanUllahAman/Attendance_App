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
        value: ColorResources.getSystemUiOverlayAllPages(false),
        child: Stack(
          children: [
            Layout(
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
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.size.width * 0.03,
                    vertical: mq.size.width * 0.04,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Apply Leave",
                          style: GoogleFonts.sora(
                            fontSize: mq.size.width * 0.040,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.whiteColor,
                          ),
                        ),
                        SizedBox(height: mq.size.height * 0.02),
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
                        Obx(() {
                          return SearchableDropdown(
                            hintText: "Select Leave Type",
                            items: controller.leaveTypesList
                                .map((type) => type.name)
                                .toList(),
                            onChange: controller.setLeaveType,
                            fillColor: ColorResources.whiteColor.withOpacity(
                              0.05,
                            ),
                            hintColor: Colors.white70,
                            textColor: ColorResources.whiteColor,
                            dropdownController:
                                controller.leaveTypeController.value,
                          );
                        }),
                        SizedBox(height: mq.size.height * 0.02),

                        // Date Range Picker Button
                        AppButton(
                          mediaQuery: mq,
                          isLoading: false,
                          onPressed: () =>
                              _openDateRangePicker(context, controller),
                          child: Obx(
                            () => Text(
                              controller.selectedDateRangeText.value.isEmpty
                                  ? 'Select Date Range'
                                  : controller.selectedDateRangeText.value,
                              style: GoogleFonts.sora(
                                color: ColorResources.whiteColor,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: mq.size.height * 0.02),
                        // Reason Field
                        CustomTextFeild(
                          controller: controller.reasonController,
                          mediaQuery: mq,
                          hintText: "Reason",
                          keyboardType: TextInputType.text,
                        ),

                        SizedBox(height: mq.size.height * 0.04),
                        // Submit Button
                        Obx(
                          () => AppButton(
                            mediaQuery: mq,
                            onPressed: () async {
                              if (controller.leaveTypesList.isEmpty) {
                                customSnackBar(
                                  "Error",
                                  "Leave types not loaded yet",
                                  snackBarType: SnackBarType.error,
                                );
                                return;
                              }
                              await controller.submitLeaveApplication(context);
                            },
                            isLoading: controller.isLoading.value,
                            child: Text(
                              "Submit",
                              style: GoogleFonts.sora(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Obx(
              () => controller.isLoading.value
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorResources.whiteColor,
                          strokeWidth: 3.0,
                          strokeCap: StrokeCap.square,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ).noKeyboard(),
      ),
    );
  }

  Widget _buildQuotaBox(String title, String count, MediaQueryData mq) {
    return Container(
      width: mq.size.width * 0.28,
      padding: EdgeInsets.symmetric(
        vertical: mq.size.height * 0.015,
        horizontal: mq.size.width * 0.02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorResources.whiteColor.withOpacity(0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: ColorResources.whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  void _openDateRangePicker(
    BuildContext context,
    ApplyLeaveController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomDateRangePicker(
        onDateRangeSelected: (start, end) {
          controller.setDateRange(start, end);
        },
      ),
    );
  }
}
