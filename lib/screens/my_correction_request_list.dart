import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Controllers/my_correction_request_list_controller.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/attendance_correction_request.dart';

import '../Utils/Colors/color_resoursec.dart';
import '../models/attendance_correction_list_model.dart';

class MyCorrectionRequestList extends StatelessWidget {
  static const String routeName = '/myCorrectionRequestListScreen';
  final MyCorrectionRequestListController controller = Get.put(
    MyCorrectionRequestListController(),
  );

  MyCorrectionRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Obx(() {
          if (controller.connectionType.value == 0) {
            return buildFullScreenOfflineUI(mq);
          }

          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(mq.size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Correction Requests",
                          style: GoogleFonts.sora(
                            fontSize: mq.size.width * 0.040,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.blackColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(AttendanceCorrectionRequest.routeName);
                          },
                          icon: Icon(
                            Iconsax.add_circle,
                            color: ColorResources.appMainColor,
                            size: mq.size.height * 0.04,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomSearchField(
                      controller: controller.searchController,
                      hintText: "Search by date or type...",
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: RefreshIndicator(
            elevation: 0.0,
                        
                        color: ColorResources.backgroundWhiteColor,
                        backgroundColor: ColorResources.appMainColor,
                        onRefresh: () => controller.fetchCorrectionRequests(),
                        child: _buildCorrectionsList(mq),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isLoading.value) Apploader(),
            ],
          );
        }),
      ).noKeyboard(),
    );
  }

  Widget _buildCorrectionsList(MediaQueryData mq) {
    if (controller.errorMessage.value.isNotEmpty &&
        controller.filteredCorrections.isEmpty) {
      return Center(
        child: Text(
          controller.errorMessage.value,
          style: GoogleFonts.sora(color: ColorResources.blackColor),
        ),
      );
    }

    if (controller.filteredCorrections.isEmpty) {
      return Center(
        child: Text(
          "No correction requests found",
          style: GoogleFonts.sora(color: ColorResources.blackColor),
        ),
      );
    }

    return ListView.separated(
      itemCount: controller.filteredCorrections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final correction = controller.filteredCorrections[index];
        return GestureDetector(
          onTap: () => _showCorrectionDetailBottomSheet(context, correction),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ColorResources.blackColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: ColorResources.blackColor.withOpacity(0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correction.formattedAttendanceDate,
                  style: TextStyle(
                    fontSize: mq.size.width * 0.035,
                    color: ColorResources.blackColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  correction.requestTypeDisplay.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: mq.size.width * 0.03,
                    color: ColorResources.blackColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (correction.requestedCheckIn != null)
                      Text(
                        'Check-In: ${_formatTime(correction.requestedCheckIn!)}',
                        style: TextStyle(
                          fontSize: mq.size.width * 0.035,
                          color: ColorResources.blackColor,
                        ),
                      ),
                    if (correction.requestedCheckOut != null)
                      Text(
                        'Check-Out: ${_formatTime(correction.requestedCheckOut!)}',
                        style: TextStyle(
                          fontSize: mq.size.width * 0.035,
                          color: ColorResources.blackColor,
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status: ${correction.statusText}",
                      style: TextStyle(
                        fontSize: mq.size.width * 0.035,
                        color: correction.statusColor,
                        fontWeight: FontWeight.w600,
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

  String _formatTime(String time) {
    try {
      final timeParts = time.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = timeParts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : hour;
        return '$displayHour:$minute $period';
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  void _showCorrectionDetailBottomSheet(
    BuildContext context,
    AttendanceCorrection correction,
  ) {
    final mq = MediaQuery.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorResources.backgroundWhiteColor,
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
                    color: ColorResources.greyColor,
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
                    color: ColorResources.blackColor,
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
                correction.formattedAttendanceDate,
              ),
              _buildDetailItem(
                Icons.access_time,
                "Original Check-In",
                correction.originalCheckIn != null
                    ? _formatTime(correction.originalCheckIn!)
                    : "—",
              ),
              _buildDetailItem(
                Icons.access_time_outlined,
                "Original Check-Out",
                correction.originalCheckOut != null
                    ? _formatTime(correction.originalCheckOut!)
                    : "—",
              ),
              if (correction.requestedCheckIn != null)
                _buildDetailItem(
                  Icons.login,
                  "Requested Check-In",
                  _formatTime(correction.requestedCheckIn!),
                ),
              if (correction.requestedCheckOut != null)
                _buildDetailItem(
                  Icons.logout,
                  "Requested Check-Out",
                  _formatTime(correction.requestedCheckOut!),
                ),
              _buildDetailItem(
                Icons.label_outline,
                "Request Type",
                correction.requestTypeDisplay,
              ),
              _buildDetailItem(
                Icons.message_outlined,
                "Reason",
                correction.reason,
              ),
              _buildDetailItem(
                Icons.info_outline,
                "Status",
                correction.statusText,
                color: correction.statusColor,
              ),
              _buildDetailItem(
                Icons.verified_user_outlined,
                "Manager/HR Remarks",
                correction.remarks ?? "—",
              ),
              _buildDetailItem(
                Icons.date_range,
                "Submitted On",
                correction.formattedCreatedAt,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String title,
    String value, {
    Color? color,
  }) {
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
                  color: ColorResources.blackColor.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.sora(
                      color: color ?? ColorResources.blackColor,
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
