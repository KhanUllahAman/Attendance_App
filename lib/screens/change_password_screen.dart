import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';

import '../Controllers/change_password_controller.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';

class ChangePasswordScreen extends StatelessWidget {
  static const String routeName = '/changePassword';
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final controller = Get.put(ChangePasswordController());

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: mq.size.width * 0.05,
            vertical: mq.size.height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Password',
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.040,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.whiteColor,
                ),
              ),
              SizedBox(height: mq.size.height * 0.03),

              // Old Password
              CustomTextFeild(
                controller: controller.oldPassController,
                mediaQuery: mq,
                hintText: 'Old Password',
                isPassword: true,
              ),
              SizedBox(height: mq.size.height * 0.02),

              // New Password
              CustomTextFeild(
                controller: controller.newPassController,
                mediaQuery: mq,
                hintText: 'New Password',
                isPassword: true,
              ),
              SizedBox(height: mq.size.height * 0.02),

              // Confirm Password
              CustomTextFeild(
                controller: controller.confirmPassController,
                mediaQuery: mq,
                hintText: 'Confirm Password',
                isPassword: true,
              ),
              SizedBox(height: mq.size.height * 0.04),

              AppButton(
                mediaQuery: mq,
                isLoading: false,
                onPressed: () {},
                child: Text(
                  'Change Password',
                  style: GoogleFonts.sora(
                    color: ColorResources.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: mq.size.width * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).noKeyboard(),
    );
  }
}
