import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';

import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';

class ProfileViewScreen extends StatelessWidget {
  static const String routeName = '/profileViewScreen';

  const ProfileViewScreen({super.key});

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
        body: SingleChildScrollView(
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
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    backgroundColor: ColorResources.whiteColor,
                  ),
                ),
              ),
              SizedBox(height: mq.size.height * 0.03),

              // === Editable Fields ===
              _buildSectionHeader("Personal Information", mq),
              CustomTextFeild(mediaQuery: mq, hintText: 'Full Name'),
              SizedBox(height: 12),
              CustomTextFeild(mediaQuery: mq, hintText: 'Father Name'),
              SizedBox(height: 12),
              CustomTextFeild(mediaQuery: mq, hintText: 'Date of Birth'),
              SizedBox(height: 12),

              _buildSectionHeader("Contact Information", mq),
              CustomTextFeild(mediaQuery: mq, hintText: 'Email'),
              SizedBox(height: 12),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'Phone',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'CNIC',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              CustomTextFeild(mediaQuery: mq, hintText: 'Address'),
              SizedBox(height: 24),

              _buildSectionHeader("Organization Info", mq),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'Employee Code',
                readOnly: true,
              ),
              SizedBox(height: 12),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'User ID',
                readOnly: true,
              ),
              SizedBox(height: 12),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'Reporting Person',
                readOnly: true,
              ),
              SizedBox(height: 12),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'Join Date',
                readOnly: true,
              ),
              SizedBox(height: 12),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'Department',
                readOnly: true,
              ),
              SizedBox(height: 12),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'Designation',
                readOnly: true,
              ),
              SizedBox(height: 12),
              CustomTextFeild(
                mediaQuery: mq,
                hintText: 'Shift Time',
                readOnly: true,
              ),
              SizedBox(height: mq.size.height * 0.035),

              AppButton(
                mediaQuery: mq,
                isLoading: false,
                onPressed: () {
                  // Save logic here
                },
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.sora(
                    color: ColorResources.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: mq.size.height * 0.03),
            ],
          ),
        ),
      ).noKeyboard(),
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
