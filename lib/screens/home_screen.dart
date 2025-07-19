import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Constant/images_constant.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/daily_attendance_record_screen.dart';
import '../Controllers/home_screen_controller.dart';
import '../Utils/AppWidget/App_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final controller = Get.put(HomeScreenController());

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        showAppBar: false,
        showLogo: false,
        currentTab: 0,
        body: Obx(() {
          if (controller.isLoading.value &&
              controller.connectionType.value == 0) {
            return _buildFullScreenOfflineUI(controller, mediaQuery);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchHomeData();
            },
            color: ColorResources.appMainColor,
            backgroundColor: ColorResources.secondryColor,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Offline Banner (only visible when offline)
                      if (controller.connectionType.value == 0)
                        _buildOfflineBanner(mediaQuery),

                      // Header Section
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
                                    ),
                                    SizedBox(
                                      width: mediaQuery.size.width * 0.03,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(
                                          () => Text(
                                            'Hi, ${controller.userName.value}',
                                            style: GoogleFonts.sora(
                                              fontSize:
                                                  mediaQuery.size.width * 0.040,
                                              fontWeight: FontWeight.w500,
                                              color: ColorResources.whiteColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              mediaQuery.size.height * 0.005,
                                        ),
                                        Obx(
                                          () => Text(
                                            controller.greeting.value,
                                            style: GoogleFonts.sora(
                                              fontSize:
                                                  mediaQuery.size.width * 0.035,
                                              fontWeight: FontWeight.w400,
                                              color: ColorResources.whiteColor
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        ),
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
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Main Content Section
                      Obx(() {
                        if (controller.connectionType.value == 0) {
                          return _buildDisabledMainContent(
                            controller,
                            mediaQuery,
                          );
                        }
                        return controller.isLoading.value
                            ? ShimmerHomeScreen(mediaQuery: mediaQuery)
                            : _buildMainContent(controller, mediaQuery);
                      }),

                      // Attendance Summary Section
                      Padding(
                        padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Attendance Summary',
                                  style: GoogleFonts.sora(
                                    fontSize: mediaQuery.size.width * 0.035,
                                    fontWeight: FontWeight.w400,
                                    color: ColorResources.whiteColor
                                        .withOpacity(0.8),
                                  ),
                                ),
                                if (controller.connectionType.value != 0)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.toNamed(
                                            DailyAttendanceRecordScreen
                                                .routeName,
                                          );
                                        },
                                        icon: Icon(
                                          Iconsax.clock,
                                          color: ColorResources.whiteColor,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          controller.openDateRangePicker(
                                            context,
                                          );
                                        },
                                        icon: Icon(
                                          Iconsax.calendar_edit,
                                          color: ColorResources.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            Obx(() {
                              if (controller.connectionType.value == 0) {
                                return _buildDisabledSummarySection(mediaQuery);
                              }
                              if (controller.isSummaryLoading.value) {
                                return buildShimmerAttendanceBoxes(mediaQuery);
                              }
                              final summary =
                                  controller.attendanceSummary.value;
                              if (summary == null) {
                                return Text(
                                  'No attendance data available',
                                  style: GoogleFonts.sora(color: Colors.white),
                                );
                              }
                              return Wrap(
                                spacing: mediaQuery.size.width * 0.04,
                                runSpacing: mediaQuery.size.height * 0.02,
                                children: [
                                  _buildAttendanceBox(
                                    summary.workingDays,
                                    "Working Days",
                                    Colors.green,
                                    Colors.green.shade100,
                                    mediaQuery,
                                  ),
                                  _buildAttendanceBox(
                                    summary.presentDays,
                                    "Present",
                                    Colors.blue.shade700,
                                    Colors.blue.shade100,
                                    mediaQuery,
                                  ),
                                  _buildAttendanceBox(
                                    summary.absentDays,
                                    "Absent",
                                    Colors.orange.shade700,
                                    Colors.orange.shade100,
                                    mediaQuery,
                                  ),
                                  _buildAttendanceBox(
                                    summary.holidayDays,
                                    "Holiday",
                                    Colors.teal.shade700,
                                    Colors.teal.shade100,
                                    mediaQuery,
                                  ),
                                  _buildAttendanceBox(
                                    summary.halfDayCheckOuts,
                                    "Half Day",
                                    Colors.purple.shade700,
                                    Colors.purple.shade100,
                                    mediaQuery,
                                  ),
                                  _buildAttendanceBox(
                                    summary.weekendDays,
                                    "Week Off",
                                    Colors.indigo.shade700,
                                    Colors.indigo.shade100,
                                    mediaQuery,
                                  ),
                                  _buildAttendanceBox(
                                    summary.leaveDays,
                                    "Leave",
                                    Colors.red.shade700,
                                    Colors.red.shade100,
                                    mediaQuery,
                                  ),
                                  _buildAttendanceBox(
                                    summary.lateCheckIns,
                                    "Late In",
                                    Colors.amber.shade700,
                                    Colors.amber.shade100,
                                    mediaQuery,
                                  ),
                                  _buildAttendanceBox(
                                    summary.earlyLeaveCheckOuts,
                                    "Early Out",
                                    Colors.deepOrange.shade700,
                                    Colors.deepOrange.shade100,
                                    mediaQuery,
                                  ),
                                ],
                              );
                            }),
                            SizedBox(height: mediaQuery.size.height * 0.05),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.isLoading.value &&
                    controller.connectionType.value != 0)
                  Center(
                    child: CircularProgressIndicator(
                      color: ColorResources.whiteColor,
                      strokeWidth: 3.0,
                      strokeCap: StrokeCap.square,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOfflineBanner(MediaQueryData mediaQuery) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.03),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: mediaQuery.size.width * 0.02),
            Text(
              'No Internet Connection',
              style: GoogleFonts.sora(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenOfflineUI(
    HomeScreenController controller,
    MediaQueryData mediaQuery,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: mediaQuery.size.width * 0.2,
            color: Colors.grey,
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Text(
            'No Internet Connection',
            style: GoogleFonts.sora(
              fontSize: mediaQuery.size.width * 0.045,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          ElevatedButton(
            onPressed: () => controller.fetchHomeData(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledMainContent(
    HomeScreenController controller,
    MediaQueryData mediaQuery,
  ) {
    return Opacity(
      opacity: 0.6,
      child: AbsorbPointer(child: _buildMainContent(controller, mediaQuery)),
    );
  }

  Widget _buildDisabledSummarySection(MediaQueryData mediaQuery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance Summary (Offline)',
          style: GoogleFonts.sora(
            color: Colors.grey,
            fontSize: mediaQuery.size.width * 0.035,
          ),
        ),
        SizedBox(height: mediaQuery.size.height * 0.02),
        buildShimmerAttendanceBoxes(mediaQuery),
      ],
    );
  }

  Widget _buildMainContent(
    HomeScreenController controller,
    MediaQueryData mediaQuery,
  ) {
    return Container(
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
              ),
              padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      controller.currentTime.value,
                      style: GoogleFonts.sora(
                        fontSize: mediaQuery.size.width * 0.060,
                        fontWeight: FontWeight.w500,
                        color: ColorResources.whiteColor,
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.currentDate.value,
                      style: GoogleFonts.sora(
                        fontSize: mediaQuery.size.width * 0.035,
                        fontWeight: FontWeight.w500,
                        color: ColorResources.whiteColor,
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),

                  // Check In/Out Button
                  AbsorbPointer(
                    absorbing:
                        !controller.isLocationEnabled.value ||
                        !controller.isLocationMatched.value ||
                        controller.currentButtonState.value == 'completed' ||
                        controller.isProcessingCheckIn.value ||
                        controller.isProcessingCheckOut.value ||
                        controller.connectionType.value == 0,
                    child: Stack(
                      children: [
                        AvatarGlow(
                          glowColor: controller.getGlowColor(),
                          duration: const Duration(milliseconds: 2000),
                          repeat: true,
                          glowCount: 2,
                          glowRadiusFactor: 0.3,
                          child: Material(
                            shape: const CircleBorder(),
                            child: GestureDetector(
                              onTap: () async {
                                if (controller.currentButtonState.value ==
                                    'check_in') {
                                  await controller.checkIn();
                                } else if (controller
                                        .currentButtonState
                                        .value ==
                                    'check_out') {
                                  await controller.checkOut();
                                }
                              },
                              child: Container(
                                width: mediaQuery.size.width * 0.50,
                                height: mediaQuery.size.width * 0.50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.getButtonColor(),
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
                                    Obx(() {
                                      if (controller
                                              .isProcessingCheckIn
                                              .value ||
                                          controller
                                              .isProcessingCheckOut
                                              .value) {
                                        return SizedBox(
                                          width: mediaQuery.size.width * 0.17,
                                          height: mediaQuery.size.width * 0.17,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                      return Icon(
                                        controller.getButtonIcon(),
                                        size: mediaQuery.size.width * 0.17,
                                        color: ColorResources.whiteColor,
                                      );
                                    }),
                                    SizedBox(
                                      height: mediaQuery.size.height * 0.005,
                                    ),
                                    Obx(
                                      () => Text(
                                        controller.getButtonText(),
                                        style: GoogleFonts.sora(
                                          fontSize:
                                              mediaQuery.size.width * 0.035,
                                          fontWeight: FontWeight.w500,
                                          color: ColorResources.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),

                  // Location Status
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.location,
                          size: mediaQuery.size.width * 0.06,
                          color: ColorResources.whiteColor.withOpacity(0.8),
                        ),
                        SizedBox(width: mediaQuery.size.width * 0.02),
                        Text(
                          !controller.isLocationEnabled.value
                              ? 'Location services disabled'
                              : controller.isLocationMatched.value &&
                                    controller
                                            .homeScreenData
                                            .value
                                            .officeLocations
                                            .isNotEmpty ==
                                        true
                              ? 'You are in ${controller.homeScreenData.value.officeLocations.firstWhere((office) => office.id == controller.matchedOfficeId.value).name} range'
                              : 'You are not in any office range',
                          style: GoogleFonts.sora(
                            fontSize: mediaQuery.size.width * 0.035,
                            fontWeight: FontWeight.w400,
                            color: ColorResources.whiteColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.04),

                  // Time Info Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTimeInfo(
                        Iconsax.login,
                        controller
                                    .homeScreenData
                                    .value
                                    .singleAttendance
                                    .isNotEmpty ==
                                true
                            ? controller
                                      .homeScreenData
                                      .value
                                      .singleAttendance[0]
                                      .checkInTime ??
                                  '--:--'
                            : '--:--',
                        'Check In',
                        mediaQuery,
                      ),
                      _buildTimeInfo(
                        Iconsax.logout,
                        controller
                                    .homeScreenData
                                    .value
                                    .singleAttendance
                                    .isNotEmpty ==
                                true
                            ? controller
                                      .homeScreenData
                                      .value
                                      .singleAttendance[0]
                                      .checkOutTime ??
                                  '--:--'
                            : '--:--',
                        'Check Out',
                        mediaQuery,
                      ),
                      _buildTimeInfo(
                        Iconsax.clock,
                        controller
                                    .homeScreenData
                                    .value
                                    .singleAttendance
                                    .isNotEmpty ==
                                true
                            ? controller
                                      .homeScreenData
                                      .value
                                      .singleAttendance[0]
                                      .workHours ??
                                  '--:--'
                            : '--:--',
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
    );
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
                  offset: const Offset(2, 2),
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
