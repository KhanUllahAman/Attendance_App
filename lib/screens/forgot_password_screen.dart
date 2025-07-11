import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Constant/images_constant.dart';
import 'package:orioattendanceapp/screens/otp_screen.dart';

import '../Utils/Colors/color_resoursec.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgotpasswordScreen';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Scaffold(
        backgroundColor: ColorResources.secondryColor,
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
              backgroundColor: ColorResources.secondryColor,
              expandedHeight: mediaQuery.size.height * 0.20,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: ColorResources.appBarGradient,
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
                      ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),
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
                        color: ColorResources.whiteColor,
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.01),
                    Text(
                      'Enter your User ID to receive an OTP for password reset',
                      style: GoogleFonts.sora(
                        fontSize: mediaQuery.size.width * 0.03,
                        fontWeight: FontWeight.w400,
                        color: ColorResources.whiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.03),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomTextFeild(
                            mediaQuery: mediaQuery,
                            hintText: 'Enter Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.02),
                          AppButton(
                            isLoading: false,
                            onPressed: () {
                              Get.toNamed(OtpScreen.routeName);
                            },
                            mediaQuery: mediaQuery,
                            child: Text(
                              'Send OTP',
                              style: GoogleFonts.sora(
                                color: ColorResources.whiteColor,
                                fontSize: mediaQuery.size.width * 0.03,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.03),
                          GestureDetector(
                            onTap: () {
                              // Navigate back to login screen
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Back to Login',
                              style: GoogleFonts.sora(
                                color: ColorResources.whiteColor,
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
    );
  }
}
