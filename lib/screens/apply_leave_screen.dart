import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/notification_screen.dart';

import '../Controllers/apply_leave_controller.dart';

class ApplyLeaveScreen extends StatelessWidget {
  static const String routeName = '/applyleaveScreen';

  const ApplyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final controller = Get.put(ApplyLeaveController());

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        showBackButton: true,
        currentTab: 1,
        showAppBar: true,
        showLogo: true,
        actionButtons: [
          IconButton(
            icon: Icon(Iconsax.notification, color: ColorResources.whiteColor),
            onPressed: () {
              Get.toNamed(NotificationScreen.routeName);
            },
          ),
        ],
        body: Padding(
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
                  children: [
                    _buildQuotaBox(
                      'Sick',
                      controller.sickRemaining.value.toString(),
                      mq,
                    ),
                    _buildQuotaBox(
                      'Casual',
                      controller.casualRemaining.value.toString(),
                      mq,
                    ),
                    _buildQuotaBox(
                      'Annual',
                      controller.annualRemaining.value.toString(),
                      mq,
                    ),
                  ],
                ),
                SizedBox(height: mq.size.height * 0.02),
                SearchableDropdown(
                  hintText: "Select Leave Type",
                  items: controller.leaveTypes,
                  onChange: controller.setLeaveType,
                  fillColor: ColorResources.whiteColor.withOpacity(0.05),
                  hintColor: Colors.white70,
                  textColor: ColorResources.whiteColor,
                  dropdownController: controller.leaveTypeController.value,
                ),
                SizedBox(height: mq.size.height * 0.02),

                // Date Range Picker Button
                AppButton(
                  mediaQuery: mq,
                  isLoading: false,
                  onPressed: () => _openDateRangePicker(context, controller),
                  child: Obx(
                    () => Text(
                      controller.selectedDateRangeText.value.isEmpty
                          ? 'Select Date Range'
                          : controller.selectedDateRangeText.value,
                      style: GoogleFonts.sora(color: ColorResources.whiteColor),
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
                      controller.isLoading.value
                          ? null
                          : await controller.submitLeaveApplication();
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
        ),
      ).noKeyboard(),
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
