import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/models/attendance_model.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Layout/layout.dart';

class DailyAttendanceRecordScreen extends StatelessWidget {
  static const String routeName = '/dailyAttendanceRecordScreen';
  const DailyAttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Layout(
      currentTab: 0,
      showAppBar: true,
      showLogo: true,
      showBackButton: true,
      body: SafeArea(
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
              Expanded(
                child: ListView.separated(
                  itemCount: dummyAttendanceList.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final item = dummyAttendanceList[index];
                    return _AttendanceCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final AttendanceModel item;
  const _AttendanceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final dayStatus = item.dayStatuses.first;
    final color = AttendanceColorHelper.getDayStatusColor(dayStatus);
    final label = AttendanceColorHelper.getDayStatusLabel(dayStatus);

    return GestureDetector(
      onTap: () => _showAttendanceDetails(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.formattedDate,
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _buildInfo("Check In", item.checkInTime),
                _buildInfo("Check Out", item.checkOutTime),
                _buildInfo("Hours", item.workHours),
                _buildInfo("Location", item.officeLocation ?? '--'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.sora(fontSize: 12, color: Colors.white60),
        ),
        Text(value, style: GoogleFonts.sora(fontSize: 13, color: Colors.white)),
      ],
    );
  }

  void _showAttendanceDetails(BuildContext context, AttendanceModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorResources.secondryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Text(
                item.formattedDate,
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                "Day Status",
                AttendanceColorHelper.getDayStatusLabel(item.dayStatuses.first),
              ),
              _buildDetailRow("Check-In Time", item.checkInTime),
              _buildDetailRow(
                "Check-In Status",
                CheckStatusHelper.getLabel(item.checkInStatus ?? "--"),
                color: CheckStatusHelper.getColor(item.checkInStatus ?? "--"),
              ),
              _buildDetailRow("Check-Out Time", item.checkOutTime),
              _buildDetailRow(
                "Check-Out Status",
                CheckStatusHelper.getLabel(item.checkOutStatus ?? "--"),
                color: CheckStatusHelper.getColor(item.checkOutStatus ?? "--"),
              ),
              _buildDetailRow("Work Hours", item.workHours),
              _buildDetailRow("Location", item.officeLocation ?? "--"),
              if (item.leaveType != null)
                _buildDetailRow("Leave Type", item.leaveType!),
              if (item.holidayTitle != null)
                _buildDetailRow("Holiday", item.holidayTitle!),
              if (item.holidayDescription != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    item.holidayDescription!,
                    style: GoogleFonts.sora(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.sora(fontSize: 13, color: Colors.white60),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 13,
                color: color ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
