import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Controllers/home_screen_controller.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/my_correction_request_list.dart';
import 'package:orioattendanceapp/screens/office_wifi_screen.dart';

import '../AuthServices/auth_service.dart';
import '../Utils/Colors/color_resoursec.dart';
import 'asset_complain_request_screen_list.dart';
import 'change_password_screen.dart';

class MenuScreen extends StatelessWidget {
  static const String routeName = '/menuScreen';
  const MenuScreen({super.key});

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
    final HomeScreenController homeScreenController =
        Get.find<HomeScreenController>();
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        showAppBar: false,
        showLogo: false,
        currentTab: 4,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: ColorResources.appBarGradient,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: mq.size.width * 0.04,
                  vertical: mq.size.height * 0.03,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: mq.size.width * 0.06,
                      backgroundImage: const AssetImage(
                        "assets/images/profile.png",
                      ),
                      backgroundColor: ColorResources.whiteColor.withOpacity(
                        0.2,
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
                    SizedBox(width: mq.size.width * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                              () => Text(
                                'Hi, ${homeScreenController.userName.value}',
                                style: GoogleFonts.sora(
                                  fontSize: mq.size.width * 0.040,
                                  fontWeight: FontWeight.w500,
                                  color: ColorResources.whiteColor,
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideX(begin: -0.2),
                        SizedBox(height: mq.size.height * 0.005),
                        Obx(
                              () => Text(
                                homeScreenController.greeting.value,
                                style: GoogleFonts.sora(
                                  fontSize: mq.size.width * 0.035,
                                  fontWeight: FontWeight.w400,
                                  color: ColorResources.whiteColor.withOpacity(
                                    0.8,
                                  ),
                                ),
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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.size.width * 0.04,
                    vertical: mq.size.height * 0.03,
                  ),
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Iconsax.lock,
                      title: "Change Password",
                      onTap: () {
                        Get.toNamed(ChangePasswordScreen.routeName);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Iconsax.document,
                      title: "My Correction Requests",
                      onTap: () {
                        Get.toNamed(MyCorrectionRequestList.routeName);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Iconsax.clipboard_text,
                      title: "My Asset Complaints / Requests",
                      onTap: () {
                        Get.toNamed(AssetComplainRequestScreenList.routeName);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Iconsax.wifi,
                      title: "Office WiFi Details",
                      onTap: () {
                        Get.toNamed(OfficeWifiScreen.routeName);
                      },
                    ),
                    Divider(color: Colors.white24),
                    _buildMenuItem(
                      context,
                      icon: Iconsax.logout,
                      title: "Logout",
                      isDanger: true,
                      onTap: () => _showLogoutDialog(context, mq),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.size.height * 0.008),
      child: Material(
        color: ColorResources.whiteColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: mq.size.width * 0.04,
              vertical: mq.size.height * 0.02,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDanger
                      ? Colors.redAccent
                      : ColorResources.appMainColor,
                ),
                SizedBox(width: mq.size.width * 0.04),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: mq.size.width * 0.032,
                      color: isDanger
                          ? Colors.redAccent
                          : ColorResources.whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: ColorResources.whiteColor.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, MediaQueryData mq) {
    final AuthService authService = AuthService();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorResources.secondryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Are you sure?",
          style: TextStyle(
            fontSize: mq.size.width * 0.045,
            color: ColorResources.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Do you really want to logout?",
          style: TextStyle(
            fontSize: mq.size.width * 0.035,
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: TextStyle(
                color: ColorResources.appMainColor,
                fontSize: mq.size.width * 0.035,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await authService.clearAuthData();
            },
            child: Text(
              "Yes",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: mq.size.width * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
