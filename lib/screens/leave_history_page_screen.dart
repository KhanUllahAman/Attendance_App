import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Controllers/leave_history_controller.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/apply_leave_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../models/leave_history_model.dart';

class LeaveHistoryPageScreen extends StatelessWidget {
  static const String routeName = '/leaveHistorypageScreen';
  final LeaveHistoryController controller = Get.put(LeaveHistoryController());

  LeaveHistoryPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 1,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await controller.fetchAllLeaveData();
              },
              color: ColorResources.appMainColor,
              backgroundColor: ColorResources.secondryColor,
              strokeWidth: 2.5,
              edgeOffset: 20,
              displacement: 40,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.size.width * 0.03,
                        vertical: mq.size.width * 0.02,
                      ),
                      child: Column(
                        children: [
                          // Quota Summary
                          Obx(() {
                            if (controller.isLoading.value) {
                              return _buildShimmerLeaveQuota(mq);
                            }

                            if (controller.leaveSummaryList.isEmpty) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  controller.errorMessage.value.isNotEmpty
                                      ? controller.errorMessage.value
                                      : 'No leave summary available',
                                  style: GoogleFonts.sora(color: Colors.white),
                                ),
                              );
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: controller.leaveSummaryList
                                  .map(
                                    (summary) => _buildLeaveQuota(
                                      summary.leaveType,
                                      "${summary.remaining.toString()} / ${summary.totalQuota}",
                                      summary.secondaryColor,
                                      summary.primaryColor,
                                      mq,
                                    ),
                                  )
                                  .toList(),
                            );
                          }),

                          SizedBox(height: mq.size.height * 0.03),
                          CustomSearchField(
                            controller: controller.searchController,
                            hintText: "Search by type, date, or status",
                            onChanged: (value) {
                              // Implement search functionality if needed
                            },
                          ),
                          SizedBox(height: mq.size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Leave History",
                                style: GoogleFonts.sora(
                                  fontSize: mq.size.width * 0.040,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: mq.size.height * 0.02),
                    // Scrollable List Section
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorResources.whiteColor,
                            strokeWidth: 3.0,
                            strokeCap: StrokeCap.square,
                          ),
                        );
                      }

                      if (controller.leaveHistoryList.isEmpty) {
                        return Center(
                          child: Text(
                            controller.errorMessage.value.isNotEmpty
                                ? controller.errorMessage.value
                                : 'No leave history available',
                            style: GoogleFonts.sora(color: Colors.white),
                          ),
                        );
                      }

                      return SizedBox(
                        height: mq.size.height * 0.6,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: mq.size.width * 0.04,
                            right: mq.size.width * 0.04,
                            bottom: mq.size.height * 0.03,
                          ),
                          itemCount: controller.leaveHistoryList.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: mq.size.height * 0.015),
                          itemBuilder: (context, index) {
                            final leave = controller.leaveHistoryList[index];
                            return GestureDetector(
                              onTap: () {
                                showLeaveDetailsBottomSheet(context, mq, leave);
                              },
                              child: Container(
                                padding: EdgeInsets.all(mq.size.width * 0.035),
                                decoration: BoxDecoration(
                                  color: ColorResources.whiteColor.withOpacity(
                                    0.05,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Iconsax.calendar,
                                          color: Colors.white70,
                                          size: mq.size.width * 0.05,
                                        ),
                                        SizedBox(width: mq.size.width * 0.02),
                                        Text(
                                          leave.leaveTypeId == 1
                                              ? "Sick Leave"
                                              : leave.leaveTypeId == 2
                                                  ? "Casual Leave"
                                                  : "Annual Leave",
                                          style: GoogleFonts.sora(
                                            fontSize: mq.size.width * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: ColorResources.whiteColor,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: leave.statusColor.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            leave.statusText,
                                            style: GoogleFonts.sora(
                                              fontSize: mq.size.width * 0.03,
                                              fontWeight: FontWeight.w500,
                                              color: leave.statusColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: mq.size.height * 0.01),
                                    Text(
                                      leave.formattedDateRange,
                                      style: GoogleFonts.sora(
                                        fontSize: mq.size.width * 0.032,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Reason: ${leave.reason}",
                                      style: GoogleFonts.sora(
                                        fontSize: mq.size.width * 0.032,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(ApplyLeaveScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: ColorResources.appBarGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Icon(Iconsax.add_circle, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ).noKeyboard(),
    );
  }

  Widget _buildLeaveQuota(
    String type,
    String remaining,
    Color lightColor,
    Color darkColor,
    MediaQueryData mq,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(
          vertical: mq.size.height * 0.018,
          horizontal: mq.size.width * 0.025,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [lightColor, darkColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: darkColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              remaining,
              style: GoogleFonts.sora(
                fontSize: mq.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: ColorResources.whiteColor,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "$type Remaining",
              style: GoogleFonts.sora(
                fontSize: mq.size.width * 0.032,
                fontWeight: FontWeight.w500,
                color: ColorResources.whiteColor.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLeaveQuota(MediaQueryData mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(
              vertical: mq.size.height * 0.018,
              horizontal: mq.size.width * 0.025,
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: mq.size.width * 0.1,
                    height: mq.size.width * 0.05,
                    color: Colors.white,
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: mq.size.width * 0.15,
                    height: mq.size.width * 0.03,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void showLeaveDetailsBottomSheet(
    BuildContext context,
    MediaQueryData mq,
    LeaveHistory leave,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorResources.secondryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mq.size.width * 0.05,
            vertical: mq.size.height * 0.03,
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
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: mq.size.height * 0.025),
              Row(
                children: [
                  Icon(
                    Iconsax.calendar_1,
                    color: leave.statusColor,
                    size: mq.size.width * 0.05,
                  ),
                  SizedBox(width: 8),
                  Text(
                    leave.leaveTypeId == 1
                        ? "Sick Leave"
                        : leave.leaveTypeId == 2
                            ? "Casual Leave"
                            : "Annual Leave",
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.whiteColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildDetailItem("Dates", leave.formattedDateRange, mq),
              _buildDetailItem("Total Days", leave.totalDays.toString(), mq),
              _buildDetailItem("Reason", leave.reason, mq),
              _buildDetailItem(
                "Status",
                leave.statusText,
                mq,
                color: leave.statusColor,
              ),
              _buildDetailItem("Applied on", leave.formattedAppliedOn, mq),
              _buildDetailItem("Approved By", leave.approvedBy.toString(), mq),
              _buildDetailItem("Approved On", leave.formattedApprovedOn, mq),
              _buildDetailItem("Remarks", leave.remarks ?? "--", mq),
              SizedBox(height: mq.size.height * 0.02),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    MediaQueryData mq, {
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.size.height * 0.007),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: mq.size.width * 0.28,
            child: Text(
              "$label:",
              style: GoogleFonts.sora(
                fontSize: mq.size.width * 0.032,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.sora(
                fontSize: mq.size.width * 0.032,
                color: color ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}