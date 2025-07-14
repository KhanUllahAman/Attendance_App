import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Controllers/my_correction_request_list_controller.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/attendance_correction_request.dart';

import '../Utils/Colors/color_resoursec.dart';

class MyCorrectionRequestList extends StatelessWidget {
  static const String routeName = '/myCorrectionRequestListScreen';
  const MyCorrectionRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final controller = Get.put(MyCorrectionRequestListController());
    final searchController = TextEditingController();

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(mq.size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Correction Requests",
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.040,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomSearchField(
                    controller: searchController,
                    hintText: "Search by date or type...",
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.requests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final request = controller.requests[index];
                        return GestureDetector(
                          onTap: () {
                            _showCorrectionDetailBottomSheet(context, request);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: ColorResources.whiteColor.withOpacity(
                                0.05,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: ColorResources.whiteColor.withOpacity(
                                  0.08,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request['date'],
                                  style: TextStyle(
                                    fontSize: mq.size.width * 0.035,
                                    color: ColorResources.whiteColor
                                        .withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  request['type']
                                      .toString()
                                      .replaceAll('_', ' ')
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: mq.size.width * 0.04,
                                    color: ColorResources.whiteColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    if (request['checkIn'] != null)
                                      Text(
                                        'Check-In: ${request['checkIn']}',
                                        style: TextStyle(
                                          fontSize: mq.size.width * 0.035,
                                          color: ColorResources.whiteColor,
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                    if (request['checkOut'] != null)
                                      Text(
                                        'Check-Out: ${request['checkOut']}',
                                        style: TextStyle(
                                          fontSize: mq.size.width * 0.035,
                                          color: ColorResources.whiteColor,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Status: ${request['status']}",
                                      style: TextStyle(
                                        fontSize: mq.size.width * 0.035,
                                        color: _getStatusColor(
                                          request['status'],
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (request['status'] == 'Pending')
                                      TextButton(
                                        onPressed: () {
                                          // Cancel logic
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: mq.size.width * 0.035,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AttendanceCorrectionRequest.routeName);
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.greenAccent;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  void _showCorrectionDetailBottomSheet(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final mq = MediaQuery.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorResources.secondryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: mq.size.width * 0.05,
          right: mq.size.width * 0.05,
          top: mq.size.height * 0.025,
          bottom: mq.viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Correction Request Detail",
                  style: GoogleFonts.sora(
                    fontSize: mq.size.width * 0.05,
                    fontWeight: FontWeight.w700,
                    color: ColorResources.whiteColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.white12),
              const SizedBox(height: 12),

              // DETAILS LIST
              _buildDetailItem(
                Icons.calendar_today,
                "Attendance Date",
                data['date'],
              ),
              _buildDetailItem(
                Icons.access_time,
                "Original Check-In",
                data['originalIn'],
              ),
              _buildDetailItem(
                Icons.access_time_outlined,
                "Original Check-Out",
                data['originalOut'],
              ),
              if (data['checkIn'] != null)
                _buildDetailItem(
                  Icons.login,
                  "Requested Check-In",
                  data['checkIn'],
                ),
              if (data['checkOut'] != null)
                _buildDetailItem(
                  Icons.logout,
                  "Requested Check-Out",
                  data['checkOut'],
                ),
              _buildDetailItem(
                Icons.label_outline,
                "Request Type",
                data['type'],
              ),
              _buildDetailItem(
                Icons.message_outlined,
                "Reason",
                data['reason'],
              ),
              _buildDetailItem(Icons.info_outline, "Status", data['status']),
              _buildDetailItem(
                Icons.verified_user_outlined,
                "Manager/HR Remarks",
                data['managerRemarks'] ?? "—",
              ),
              _buildDetailItem(
                Icons.date_range,
                "Submitted On",
                data['submittedOn'],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ColorResources.appMainColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title: ",
                style: GoogleFonts.sora(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.sora(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
