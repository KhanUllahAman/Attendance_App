import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        title: "Attendance History",
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
                  // Date Range Selection Button
                  GestureDetector(
                    onTap: () => _openDateRangePicker(context, controller),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.size.width * 0.04,
                        vertical: mq.size.height * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: ColorResources.blackColor.withOpacity(
                          0.09,
                        ), // आपका ग्रे कलर
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(
                        () => Center(
                          child: Text(
                            controller.selectedDateRangeText.value.isEmpty
                                ? 'Last 15 Days'
                                : controller.selectedDateRangeText.value,
                            style: GoogleFonts.sora(
                              color: ColorResources.blackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mq.size.height * 0.02),

                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Apploader();
                      }

                      if (controller.attendanceRecords.isEmpty) {
                        return Center(
                          child: Text(
                            'No attendance records found',
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

  void _openDateRangePicker(
    BuildContext context,
    DailyAttendanceRecordController controller,
  ) {
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
          onDateRangeSelected: (start, end) {
            controller.setDateRange(start, end);
            controller.fetchAttendanceRecords();
          },
        ),
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
          color: record.dayStatusColorValue.withOpacity(0.2),
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
                    color: ColorResources.blackColor,
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
                        color: ColorResources.blackColor,
                      ),
                    ),
                    Text(
                      record.checkInTime ?? '--',
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: ColorResources.blackColor,
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
                        color: ColorResources.blackColor,
                      ),
                    ),
                    Text(
                      record.checkOutTime ?? '--',
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: ColorResources.blackColor,
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
                        color: ColorResources.blackColor,
                      ),
                    ),
                    Text(
                      record.workHours ?? '--',
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: ColorResources.blackColor,
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
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5, // Initial height
        minChildSize: 0.3, // Minimum height when collapsed
        maxChildSize: 0.9, // Maximum height when expanded
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: ColorResources.backgroundWhiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: handleWidth,
                    height: handleHeight,
                    decoration: BoxDecoration(
                      color: ColorResources.greyColor,
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
                    color: ColorResources.blackColor,
                  ),
                ),
                SizedBox(height: padding),
                _buildDetailTable(),
                SizedBox(height: padding),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailTable() {
    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
      border: TableBorder(
        horizontalInside: BorderSide(color: ColorResources.greyColor, width: 1),
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
            style: GoogleFonts.sora(
              color: ColorResources.blackColor,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: GoogleFonts.sora(
              color: color ?? ColorResources.blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
