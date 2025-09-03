import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/leave_history_page_screen.dart';
import 'package:orioattendanceapp/screens/my_correction_request_list.dart';
import 'package:orioattendanceapp/screens/office_wifi_screen.dart';

import '../AuthServices/auth_service.dart';
import '../Utils/Colors/color_resoursec.dart';
import 'asset_complain_request_screen_list.dart';
import 'change_password_screen.dart';
import 'meeting_screen.dart';

class MenuScreen extends StatelessWidget {
  static const String routeName = '/menuScreen';
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        title: "Menu",
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        currentTab: 4,
        body: SafeArea(
          child: Column(
            children: [
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
                      title: "Attendance Correction Requests",
                      onTap: () {
                        Get.toNamed(MyCorrectionRequestList.routeName);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Iconsax.activity,
                      title: "Leave Request",
                      onTap: () {
                        Get.toNamed(LeaveHistoryPageScreen.routeName);
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
                    _buildMenuItem(
                      context,
                      icon: Icons.meeting_room_sharp,
                      title: "Meeting",
                      onTap: () {
                        Get.toNamed(MeetingScreen.routeName);
                      },
                    ),
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
        color: ColorResources.blackColor.withOpacity(0.05),
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
                          : ColorResources.blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
        backgroundColor: ColorResources.backgroundWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Are you sure?",
          style: TextStyle(
            fontSize: mq.size.width * 0.045,
            color: ColorResources.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Do you really want to logout?",
          style: TextStyle(
            fontSize: mq.size.width * 0.035,
            color: ColorResources.blackColor,
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
