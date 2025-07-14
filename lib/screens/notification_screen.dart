import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import '../Utils/Colors/color_resoursec.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = '/notificationScreen';

  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 2,
        showAppBar: true,
        showBackButton: true,
        showLogo: true,
        actionButtons: [
          IconButton(
            icon: Icon(Iconsax.more, color: ColorResources.whiteColor),
            onPressed: () {},
          ),
        ],
        body: Padding(
          padding: EdgeInsets.all(mq.size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notifications",
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.055,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.whiteColor,
                ),
              ),
              SizedBox(height: mq.size.height * 0.02),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  separatorBuilder: (_, __) => SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final priorityColor = [
                      Colors.green,
                      Colors.orange,
                      Colors.red,
                    ][index % 3];
                    final type = ["Attendance", "Leave", "Shift"][index % 3];
                    return GestureDetector(
                      onTap: () {
                        showNotificationDetailsBottomSheet(context, mq);
                      },
                      child: Container(
                        padding: EdgeInsets.all(mq.size.width * 0.04),
                        decoration: BoxDecoration(
                          color: ColorResources.whiteColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Team Meeting at 10:00 AM",
                              style: GoogleFonts.sora(
                                fontSize: mq.size.width * 0.042,
                                fontWeight: FontWeight.w600,
                                color: ColorResources.whiteColor,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                _buildTag(
                                  type,
                                  ColorResources.appMainColor,
                                  mq,
                                ),
                                SizedBox(width: 6),
                                _buildTag("High", priorityColor, mq),
                                Spacer(),
                                Text(
                                  "Jul 13, 09:45 AM",
                                  style: GoogleFonts.sora(
                                    fontSize: mq.size.width * 0.03,
                                    color: Colors.white54,
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
      ),
    );
  }

  Widget _buildTag(String text, Color color, MediaQueryData mq) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.sora(
          color: color,
          fontSize: mq.size.width * 0.03,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void showNotificationDetailsBottomSheet(
    BuildContext context,
    MediaQueryData mq,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorResources.secondryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: mq.size.width * 0.05,
            right: mq.size.width * 0.05,
            top: mq.size.height * 0.025,
            bottom: mq.viewInsets.bottom + mq.size.height * 0.03,
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
              Text(
                "Team Meeting at 10:00 AM",
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.whiteColor,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildTag("Leave", Colors.orange, mq),
                  SizedBox(width: 8),
                  _buildTag("High", Colors.redAccent, mq),
                  Spacer(),
                  Icon(
                    Icons.access_time,
                    size: mq.size.width * 0.045,
                    color: Colors.white54,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Jul 13, 09:45 AM",
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.03,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              Divider(height: mq.size.height * 0.035, color: Colors.white10),
              Text(
                "Message",
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.038,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "You are requested to attend a team meeting scheduled today at 10:00 AM sharp. Please be punctual and prepared to discuss project updates and deadlines.",
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.035,
                  color: ColorResources.whiteColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
