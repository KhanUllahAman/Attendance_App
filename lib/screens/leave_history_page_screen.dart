import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/apply_leave_screen.dart';

class LeaveHistoryPageScreen extends StatelessWidget {
  static const String routeName = '/leaveHistorypageScreen';

  const LeaveHistoryPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final searchController = TextEditingController();

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 1,
        showAppBar: true,
        showLogo: true,
        actionButtons: [
          IconButton(
            icon: Icon(Iconsax.notification, color: ColorResources.whiteColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Iconsax.add_circle, color: ColorResources.whiteColor),
            onPressed: () {
              Get.toNamed(ApplyLeaveScreen.routeName);
            },
          ),
        ],
        body: Column(
          children: [
            // Fixed Header Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.size.width * 0.03,
                vertical: mq.size.width * 0.02,
              ),
              child: Column(
                children: [
                  // Quota Summary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLeaveQuota(
                        "Sick",
                        "5",
                        Colors.red.shade100,
                        Colors.red.shade700,
                        mq,
                      ),
                      _buildLeaveQuota(
                        "Casual",
                        "3",
                        Colors.orange.shade100,
                        Colors.orange.shade700,
                        mq,
                      ),
                      _buildLeaveQuota(
                        "Annual",
                        "10",
                        Colors.teal.shade100,
                        Colors.teal.shade700,
                        mq,
                      ),
                    ],
                  ),
                  SizedBox(height: mq.size.height * 0.03),
                  CustomSearchField(
                    controller: searchController,
                    hintText: "Search by type, date, or status",
                    onChanged: (value) {},
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
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.calendar_edit,
                          color: ColorResources.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable List Section
            Expanded(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: mq.size.width * 0.04,
                  right: mq.size.width * 0.04,
                  bottom: mq.size.height * 0.03,
                ),
                itemCount: 15,
                separatorBuilder: (_, __) =>
                    SizedBox(height: mq.size.height * 0.015),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(mq.size.width * 0.035),
                    decoration: BoxDecoration(
                      color: ColorResources.whiteColor.withOpacity(0.05),
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
                              "Sick Leave",
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
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Approved",
                                style: GoogleFonts.sora(
                                  fontSize: mq.size.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: mq.size.height * 0.01),
                        Text(
                          "Feb 20 - Feb 21 (2 Days)",
                          style: GoogleFonts.sora(
                            fontSize: mq.size.width * 0.032,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Reason: Fever and body ache",
                          style: GoogleFonts.sora(
                            fontSize: mq.size.width * 0.032,
                            color: Colors.white60,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: ColorResources.appMainColor,
                            ),
                            onPressed: () =>
                                showLeaveDetailsBottomSheet(context, mq),
                            icon: Icon(Iconsax.eye, size: mq.size.width * 0.04),
                            label: Text(
                              "View Details",
                              style: GoogleFonts.sora(
                                fontSize: mq.size.width * 0.032,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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

  void showLeaveDetailsBottomSheet(BuildContext context, MediaQueryData mq) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorResources.secondryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
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
                    color: Colors.tealAccent,
                    size: mq.size.width * 0.05,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Sick Leave",
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.whiteColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildDetailItem("Dates", "Feb 20 - Feb 21 (2 Days)", mq),
              _buildDetailItem("Reason", "Fever and body ache", mq),
              _buildDetailItem(
                "Status",
                "Approved",
                mq,
                color: Colors.greenAccent,
              ),
              _buildDetailItem("Approved By", "Manager", mq),
              _buildDetailItem("Remarks", "Take rest and resume Monday", mq),
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
