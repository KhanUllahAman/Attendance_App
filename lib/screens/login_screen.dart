import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Screens/home_screen.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Constant/images_constant.dart';
import 'package:orioattendanceapp/screens/forgot_password_screen.dart';

import '../Utils/Colors/color_resoursec.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/loginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                      'Get Started Now',
                      style: GoogleFonts.sora(
                        fontSize: mediaQuery.size.width * 0.06,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.whiteColor,
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.01),
                    Text(
                      'Enter your user id and password to log in',
                      style: GoogleFonts.sora(
                        fontSize: mediaQuery.size.width * 0.03,
                        fontWeight: FontWeight.w400,
                        color: ColorResources.whiteColor,
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomTextFeild(
                            mediaQuery: mediaQuery,
                            hintText: 'User Id',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'User Id is Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.02),
                          CustomTextFeild(
                            mediaQuery: mediaQuery,
                            hintText: 'Password',
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.01),
                          Row(
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (bool? newvalue) {
                                  newvalue;
                                },
                                checkColor: ColorResources.whiteColor,
                                activeColor: ColorResources.appMainColor,
                              ),
                              Text(
                                "Remember me",
                                style: GoogleFonts.sora(
                                  color: ColorResources.whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: mediaQuery.size.width * 0.03,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.01),
                          AppButton(
                            isLoading: false,
                            onPressed: () {
                              Get.offAllNamed(HomeScreen.routeName);
                            },
                            mediaQuery: mediaQuery,
                            child: Text(
                              "Log in",
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
                              Get.toNamed(ForgotPasswordScreen.routeName);
                            },
                            child: SizedBox(
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.sora(
                                  color: ColorResources.whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: mediaQuery.size.width * 0.03,
                                ),
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
