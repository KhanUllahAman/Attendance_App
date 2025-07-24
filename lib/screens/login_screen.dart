import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/screens/forgot_password_screen.dart';
import '../Controllers/login_controller.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Constant/images_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';

// login_screen.dart
class LoginScreen extends StatefulWidget {
  static const String routeName = '/loginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return PopScope(
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
      child: AnnotatedRegion(
        value: ColorResources.getSystemUiOverlayAllPages(false),
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: ColorResources.backgroundWhiteColor,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    elevation: 5,
                    backgroundColor: ColorResources.backgroundWhiteColor,
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
                            'Get Started Now',
                            style: GoogleFonts.sora(
                              fontSize: mediaQuery.size.width * 0.06,
                              fontWeight: FontWeight.w600,
                              color: ColorResources.blackColor,
                            ),
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.01),
                          Text(
                            'Enter your user id and password to log in',
                            style: GoogleFonts.sora(
                              fontSize: mediaQuery.size.width * 0.03,
                              fontWeight: FontWeight.w400,
                              color: ColorResources.blackColor,
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
                                  controller: controller.userIdController,
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
                                  controller: controller.passwordController,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: mediaQuery.size.height * 0.02),

                                Obx(
                                  () => AppButton(
                                    isLoading: controller.isLoading.value,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        controller.login();
                                      }
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
                                ),
                                SizedBox(height: mediaQuery.size.height * 0.03),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(ForgotPasswordScreen.routeName);
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: GoogleFonts.sora(
                                      color: ColorResources.blackColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: mediaQuery.size.width * 0.03,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => controller.errorMessage.value.isNotEmpty
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                            top: mediaQuery.size.height * 0.02,
                                          ),
                                          child: Text(
                                            controller.errorMessage.value,
                                            style: GoogleFonts.sora(
                                              color: Colors.red,
                                              fontSize:
                                                  mediaQuery.size.width * 0.03,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
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
            Obx(
              () => controller.isLoading.value
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorResources.whiteColor,
                          strokeWidth: 3.0,
                          strokeCap: StrokeCap.square,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
