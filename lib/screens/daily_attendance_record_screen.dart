import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import '../Controllers/daily_attendnce_record_controller.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Layout/layout.dart';
import '../models/attendance_record_model.dart';

class DailyAttendanceRecordScreen extends StatelessWidget {
  static const String routeName = '/dailyAttendanceRecordScreen';
  final controller = Get.put(DailyAttendanceRecordController());

  DailyAttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 0,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Obx(() {
          if (controller.connectionType.value == 0) {
            return buildFullScreenOfflineUI(mq);
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(mq.size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance History',
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: mq.size.height * 0.02),

                  // Date Selection Row
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.showDatePicker(
                            context,
                            isStartDate: true,
                          ),
                          child: Obx(
                            () => _buildDateField(
                              'Start Date',
                              controller.startDate.value,
                              mq,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.showDatePicker(
                            context,
                            isStartDate: false,
                          ),
                          child: Obx(
                            () => _buildDateField(
                              'End Date',
                              controller.endDate.value,
                              mq,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mq.size.height * 0.02),

                  // View Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorResources.appMainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: controller.fetchAttendanceRecords,
                      child: Obx(() {
                        return controller.isLoading.value
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3.0,
                                strokeCap: StrokeCap.square,
                              )
                            : Text(
                                'View Attendance',
                                style: GoogleFonts.sora(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                      }),
                    ),
                  ),
                  SizedBox(height: mq.size.height * 0.02),
                  Expanded(
                    child: Obx(() {
                      if (controller.attendanceRecords.isEmpty) {
                        return Center(
                          child: Text(
                            controller.startDate.value == null ||
                                    controller.endDate.value == null
                                ? 'Select date range to view attendance'
                                : 'No attendance records found',
                            style: GoogleFonts.sora(color: Colors.white70),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: controller.attendanceRecords.length,
                        itemBuilder: (context, index) {
                          final record = controller.attendanceRecords[index];
                          return _AttendanceCard(record: record);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, MediaQueryData mq) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.sora(fontSize: 12, color: Colors.white60),
          ),
          SizedBox(height: 5),
          Text(
            date != null
                ? DateFormat('yyyy-MM-dd').format(date)
                : 'Select date',
            style: GoogleFonts.sora(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final AttendanceRecord record;
  const _AttendanceCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.shortDate,
                style: GoogleFonts.sora(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                record.status,
                style: GoogleFonts.sora(
                  fontSize: 12,
                  color: record.status == 'Present'
                      ? Colors.green
                      : record.status == 'Half Day'
                      ? Colors.orange
                      : Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check In',
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                  Text(
                    record.checkInTime ?? '--',
                    style: GoogleFonts.sora(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check Out',
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                  Text(
                    record.checkOutTime ?? '--',
                    style: GoogleFonts.sora(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hours',
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                  Text(
                    record.workHours ?? '--',
                    style: GoogleFonts.sora(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
