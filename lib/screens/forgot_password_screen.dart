import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Constant/images_constant.dart';

import '../Controllers/forgot_password_controller.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgotpasswordScreen';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final mediaQuery = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          if (controller.isLoading.value) {
            customSnackBar(
              "Please Wait",
              "Operation in progress. Please wait until it completes.",
              snackBarType: SnackBarType.info,
            );
            return;
          }
          Navigator.of(context).pop();
        },
        child: Scaffold(
          backgroundColor: ColorResources.backgroundWhiteColor,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: ColorResources.whiteColor,
                  ),
                ),
                elevation: 5,
                backgroundColor: ColorResources.backgroundWhiteColor,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                expandedHeight: mediaQuery.size.height * 0.20,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      color: ColorResources.appMainColor,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: mediaQuery.size.height * 0.1),
                        Image.asset(
                              ImagesConstant.splashImages,
                              fit: BoxFit.contain,
                              height: mediaQuery.size.height * 0.1,
                              width: mediaQuery.size.width * 0.4,
                            )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .slideY(begin: -0.3),
                      ],
                    ),
                  ),
                ),
                pinned: false,
                snap: false,
                floating: false,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.05,
                    vertical: mediaQuery.size.height * 0.07,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Forgot Password?',
                        style: GoogleFonts.sora(
                          fontSize: mediaQuery.size.width * 0.06,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.blackColor,
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.01),
                      Text(
                        'Enter your User ID to receive an OTP for password reset',
                        style: GoogleFonts.sora(
                          fontSize: mediaQuery.size.width * 0.03,
                          fontWeight: FontWeight.w400,
                          color: ColorResources.blackColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.03),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextFeild(
                              controller: controller.emailController,
                              mediaQuery: mediaQuery,
                              hintText: 'Enter Email',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            Obx(
                              () => AppButton(
                                mediaQuery: mediaQuery,
                                isLoading: controller.isLoading.value,
                                onPressed: controller.changePassword,
                                child: controller.isLoading.value
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3.0,
                                        strokeCap: StrokeCap.square,
                                      )
                                    : Text(
                                        'Done',
                                        style: GoogleFonts.sora(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.03),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Login',
                                style: GoogleFonts.sora(
                                  color: ColorResources.blackColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: mediaQuery.size.width * 0.03,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).noKeyboard(),
        ),
      ),
    );
  }
}
