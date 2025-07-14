import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Constant/images_constant.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/daily_attendance_record_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        showAppBar: false,
        showLogo: false,
        currentTab: 0,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: mediaQuery.size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: ColorResources.appBarGradient,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.height * 0.02,
                    vertical: mediaQuery.size.width * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            CircleAvatar(
                                  radius: mediaQuery.size.width * 0.06,
                                  backgroundImage: const AssetImage(
                                    "assets/images/profile.png",
                                  ),
                                  backgroundColor: ColorResources.whiteColor
                                      .withOpacity(0.2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ColorResources.whiteColor
                                            .withOpacity(0.5),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 600.ms)
                                .slideX(begin: -0.2),
                            SizedBox(width: mediaQuery.size.width * 0.03),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      'Aman Khan',
                                      style: GoogleFonts.sora(
                                        fontSize: mediaQuery.size.width * 0.040,
                                        fontWeight: FontWeight.w500,
                                        color: ColorResources.whiteColor,
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .slideX(begin: -0.2),
                                SizedBox(
                                  height: mediaQuery.size.height * 0.005,
                                ),
                                Text(
                                      _getGreeting(),
                                      style: GoogleFonts.sora(
                                        fontSize: mediaQuery.size.width * 0.035,
                                        fontWeight: FontWeight.w400,
                                        color: ColorResources.whiteColor
                                            .withOpacity(0.8),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .slideX(begin: -0.2),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        ImagesConstant.splashImages,
                        width: mediaQuery.size.width * 0.2,
                        height: mediaQuery.size.width * 0.2,
                        fit: BoxFit.contain,
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2),
                    ],
                  ),
                ),
              ),

              // Card Section
              Container(
                height: mediaQuery.size.height * 0.45,
                color: ColorResources.secondryColor,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -(mediaQuery.size.height * 0.17 / 2),
                      left: mediaQuery.size.width * 0.05,
                      right: mediaQuery.size.width * 0.05,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorResources.secondryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '09:10 AM',
                              style: GoogleFonts.sora(
                                fontSize: mediaQuery.size.width * 0.060,
                                fontWeight: FontWeight.w500,
                                color: ColorResources.whiteColor,
                              ),
                            ),
                            Text(
                              'March 19, 2024 - Friday',
                              style: GoogleFonts.sora(
                                fontSize: mediaQuery.size.width * 0.035,
                                fontWeight: FontWeight.w500,
                                color: ColorResources.whiteColor,
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.03),
                            AvatarGlow(
                              glowColor: ColorResources.appMainColor
                                  .withOpacity(0.5),
                              duration: const Duration(milliseconds: 2000),
                              repeat: true,
                              glowCount: 2,
                              glowRadiusFactor: 0.3,
                              child: Material(
                                shape: const CircleBorder(),
                                child: Container(
                                  width: mediaQuery.size.width * 0.50,
                                  height: mediaQuery.size.width * 0.50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorResources.appMainColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.login,
                                        size: mediaQuery.size.width * 0.17,
                                        color: ColorResources.whiteColor,
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height * 0.005,
                                      ),
                                      Text(
                                        'Check In',
                                        style: GoogleFonts.sora(
                                          fontSize:
                                              mediaQuery.size.width * 0.035,
                                          fontWeight: FontWeight.w500,
                                          color: ColorResources.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.location,
                                      size: mediaQuery.size.width * 0.06,
                                      color: ColorResources.whiteColor
                                          .withOpacity(0.8),
                                    ),
                                    SizedBox(
                                      width: mediaQuery.size.width * 0.02,
                                    ),
                                    Text(
                                      'You are in the office range',
                                      style: GoogleFonts.sora(
                                        fontSize: mediaQuery.size.width * 0.035,
                                        fontWeight: FontWeight.w400,
                                        color: ColorResources.whiteColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                )
                                .animate()
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.2),
                            SizedBox(height: mediaQuery.size.height * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildTimeInfo(
                                  Iconsax.login,
                                  '09:00 AM',
                                  'Check In',
                                  mediaQuery,
                                ),
                                _buildTimeInfo(
                                  Iconsax.logout,
                                  '05:00 PM',
                                  'Check Out',
                                  mediaQuery,
                                ),
                                _buildTimeInfo(
                                  Iconsax.clock,
                                  '8h 00m',
                                  'Working Hours',
                                  mediaQuery,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Attendance Summery',
                          style: GoogleFonts.sora(
                            fontSize: mediaQuery.size.width * 0.035,
                            fontWeight: FontWeight.w400,
                            color: ColorResources.whiteColor.withOpacity(0.8),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(DailyAttendanceRecordScreen.routeName);
                          },
                          icon: Icon(
                            Iconsax.calendar_edit,
                            color: ColorResources.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    Wrap(
                      spacing: mediaQuery.size.width * 0.04,
                      runSpacing: mediaQuery.size.height * 0.02,
                      children: [
                        _buildAttendanceBox(
                          "13",
                          "Present",
                          Colors.blue.shade700,
                          Colors.blue.shade100,
                          mediaQuery,
                        ),
                        _buildAttendanceBox(
                          "0",
                          "Absent",
                          Colors.orange.shade700,
                          Colors.orange.shade100,
                          mediaQuery,
                        ),
                        _buildAttendanceBox(
                          "4",
                          "Holiday",
                          Colors.teal.shade700,
                          Colors.teal.shade100,
                          mediaQuery,
                        ),
                        _buildAttendanceBox(
                          "6",
                          "Half Day",
                          Colors.purple.shade700,
                          Colors.purple.shade100,
                          mediaQuery,
                        ),
                        _buildAttendanceBox(
                          "4",
                          "Week Off",
                          Colors.indigo.shade700,
                          Colors.indigo.shade100,
                          mediaQuery,
                        ),
                        _buildAttendanceBox(
                          "3",
                          "Leave",
                          Colors.red.shade700,
                          Colors.red.shade100,
                          mediaQuery,
                        ),
                      ],
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo(
    IconData icon,
    String time,
    String label,
    MediaQueryData mediaQuery,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: mediaQuery.size.width * 0.07,
          color: ColorResources.whiteColor,
        ),
        SizedBox(height: mediaQuery.size.height * 0.01),
        Text(
          time,
          style: GoogleFonts.sora(
            fontSize: mediaQuery.size.width * 0.030,
            fontWeight: FontWeight.w400,
            color: ColorResources.whiteColor,
          ),
        ),
        SizedBox(height: mediaQuery.size.height * 0.005),
        Text(
          label,
          style: GoogleFonts.sora(
            fontSize: mediaQuery.size.width * 0.03,
            fontWeight: FontWeight.w400,
            color: ColorResources.whiteColor.withOpacity(0.8),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2);
  }

  Widget _buildAttendanceBox(
    String count,
    String label,
    Color backgroundColor,
    Color foregroundColor,
    MediaQueryData mediaQuery,
  ) {
    return Stack(
      children: [
        Container(
          width: mediaQuery.size.width * 0.26,
          height: mediaQuery.size.height * 0.12,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Positioned(
          top: 15,
          left: 0,
          right: 0,
          child: Container(
            width: mediaQuery.size.width * 0.26,
            height: mediaQuery.size.height * 0.11,
            decoration: BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: GoogleFonts.sora(
                      fontSize: mediaQuery.size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: backgroundColor,
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.005),
                  Text(
                    label,
                    style: GoogleFonts.sora(
                      fontSize: mediaQuery.size.width * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
