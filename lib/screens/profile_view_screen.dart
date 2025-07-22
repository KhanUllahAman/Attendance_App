import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import '../Controllers/profile_view_controller.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../models/profile_screen_model.dart';

class ProfileViewScreen extends StatelessWidget {
  static const String routeName = '/profileViewScreen';
  final controller = Get.put(ProfileViewController());

  ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 3,
        showAppBar: true,
        showBackButton: true,
        showLogo: true,
        body: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: mq.size.width * 0.04,
                  vertical: mq.size.height * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          gradient: ColorResources.appBarGradient,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: mq.size.width * 0.16,
                          backgroundImage:
                              controller
                                          .employeeProfile
                                          .value
                                          ?.profilePicture !=
                                      null &&
                                  controller
                                          .employeeProfile
                                          .value!
                                          .profilePicture !=
                                      'default.png'
                              ? NetworkImage(
                                  controller
                                      .employeeProfile
                                      .value!
                                      .profilePicture!,
                                )
                              : AssetImage('assets/images/profile.png')
                                    as ImageProvider,
                          backgroundColor: ColorResources.whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(height: mq.size.height * 0.03),

                    if (controller.employeeProfile.value != null) ...[
                      _buildProfileInfoSection(
                        controller.employeeProfile.value!,
                        mq,
                      ),
                    ],
                  ],
                ),
              ),
              if (controller.isLoading.value)
                Center(child: CircularProgressIndicator()),
            ],
          );
        }),
      ).noKeyboard(),
    );
  }

  Widget _buildProfileInfoSection(EmployeeProfile profile, MediaQueryData mq) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Information
        _buildSectionHeader("Personal Information", mq),
        _buildInfoField('Full Name', profile.fullName),
        _buildInfoField('Gender', profile.gender ?? '--'),
        _buildInfoField('Date of Birth', profile.dob ?? '--'),
        SizedBox(height: 12),

        // Contact Information
        _buildSectionHeader("Contact Information", mq),
        _buildInfoField('Email', profile.email ?? '--'),
        _buildInfoField('Phone', profile.phone ?? '--'),
        _buildInfoField('CNIC', profile.cnic ?? '--'),
        _buildInfoField('Address', profile.address ?? '--'),
        SizedBox(height: 24),

        // Organization Info
        _buildSectionHeader("Organization Info", mq),
        _buildInfoField('Employee Code', profile.employeeCode),
        _buildInfoField('Department', profile.departmentName ?? '--'),
        _buildInfoField('Designation', profile.designationTitle ?? '--'),
        _buildInfoField('Shift', profile.shiftName ?? '--'),
        _buildInfoField('Shift Time', profile.formattedShiftTime),
        _buildInfoField('Join Date', profile.formattedJoinDate),
        _buildInfoField('Teams', profile.teamNames ?? '--'),
        _buildInfoField('Team Leads', profile.teamLeads ?? '--'),
        SizedBox(height: mq.size.height * 0.035),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.sora(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, MediaQueryData mq) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.size.height * 0.015),
      child: Text(
        title,
        style: GoogleFonts.sora(
          color: ColorResources.whiteColor,
          fontSize: mq.size.width * 0.042,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
