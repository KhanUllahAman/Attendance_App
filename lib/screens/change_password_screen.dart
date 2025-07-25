import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
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
                    color: ColorResources.blackColor,
                  ),
                ),
                SizedBox(height: mq.size.height * 0.03),

                // Old Password
                CustomTextFeild(
                  controller: controller.oldPassController,
                  mediaQuery: mq,
                  hintText: 'Old Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mq.size.height * 0.02),

                // New Password
                CustomTextFeild(
                  controller: controller.newPassController,
                  mediaQuery: mq,
                  hintText: 'New Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mq.size.height * 0.02),

                // Confirm Password
                CustomTextFeild(
                  controller: controller.confirmPassController,
                  mediaQuery: mq,
                  hintText: 'Confirm Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != controller.newPassController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mq.size.height * 0.04),

                Obx(
                  () => AppButton(
                    mediaQuery: mq,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.changePassword,
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3.0,
                            strokeCap: StrokeCap.square,
                          )
                        : Text(
                            'Change Password',
                            style: GoogleFonts.sora(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).noKeyboard(),
    );
  }
}
