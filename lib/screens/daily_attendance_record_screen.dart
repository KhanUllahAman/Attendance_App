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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double titleFontSize = screenWidth * 0.035 * textScaleFactor;
    final double statusFontSize = screenWidth * 0.03 * textScaleFactor;
    final double labelFontSize = screenWidth * 0.03 * textScaleFactor;
    final double valueFontSize = screenWidth * 0.0325 * textScaleFactor;
    final double containerPadding = screenWidth * 0.03;
    final double containerMargin = screenWidth * 0.025;
    final double spacing = screenWidth * 0.025;

    return GestureDetector(
      onTap: () => _showDetailsBottomSheet(context),
      child: Container(
        margin: EdgeInsets.only(bottom: containerMargin),
        padding: EdgeInsets.all(containerPadding),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(containerPadding * 0.833),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.formattedDate,
                  style: GoogleFonts.sora(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  record.dayStatusLabel,
                  style: GoogleFonts.sora(
                    fontSize: statusFontSize,
                    color: record.dayStatusColorValue,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check In',
                      style: GoogleFonts.sora(
                        fontSize: labelFontSize,
                        color: Colors.white60,
                      ),
                    ),
                    Text(
                      record.checkInTime ?? '--',
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check Out',
                      style: GoogleFonts.sora(
                        fontSize: labelFontSize,
                        color: Colors.white60,
                      ),
                    ),
                    Text(
                      record.checkOutTime ?? '--',
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hours',
                      style: GoogleFonts.sora(
                        fontSize: labelFontSize,
                        color: Colors.white60,
                      ),
                    ),
                    Text(
                      record.workHours ?? '--',
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context) {
    // Get screen width and text scale factor for bottom sheet
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double titleFontSize = screenWidth * 0.045 * textScaleFactor;
    final double padding = screenWidth * 0.04;
    final double handleWidth = screenWidth * 0.1;
    final double handleHeight = screenWidth * 0.01;
    final double borderRadius = screenWidth * 0.05;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color:
              ColorResources.secondryColor, // Ensure ColorResources is defined
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: handleWidth,
                  height: handleHeight,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(handleHeight * 0.5),
                  ),
                ),
              ),
              SizedBox(height: padding),
              Text(
                'Attendance Details',
                style: GoogleFonts.sora(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: padding),
              _buildDetailTable(), // Ensure this method is responsive if needed
              SizedBox(height: padding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTable() {
    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.white24, width: 1),
      ),
      children: [
        _buildTableRow('Date', record.formattedDate),
        _buildTableRow('Employee', record.fullName),
        _buildTableRow('Employee Code', record.employeeCode),
        _buildTableRow('Status', record.dayStatusLabel),
        if (record.checkInTime != null) ...[
          _buildTableRow('Check In Time', record.checkInTime!),
          _buildTableRow(
            'Check In Status',
            AttendanceRecord.checkInStatusLabels[record.checkInStatus] ?? '--',
            color: record.checkInStatus != null
                ? AttendanceRecord.checkInStatusColors[record.checkInStatus]
                : null,
          ),
          _buildTableRow('Check In Office', record.checkInOffice ?? '--'),
        ],
        if (record.checkOutTime != null) ...[
          _buildTableRow('Check Out Time', record.checkOutTime!),
          _buildTableRow(
            'Check Out Status',
            AttendanceRecord.checkOutStatusLabels[record.checkOutStatus] ??
                '--',
            color: record.checkOutStatus != null
                ? AttendanceRecord.checkOutStatusColors[record.checkOutStatus]
                : null,
          ),
          _buildTableRow('Check Out Office', record.checkOutOffice ?? '--'),
        ],
        _buildTableRow('Work Hours', record.workHours ?? '--'),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value, {Color? color}) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: GoogleFonts.sora(
              color: color ?? Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
