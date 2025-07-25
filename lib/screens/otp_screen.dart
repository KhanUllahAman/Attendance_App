import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Constant/images_constant.dart';
import '../Controllers/otp_controller.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import 'login_screen.dart';

// otp_screen.dart
class OtpScreen extends StatelessWidget {
  static const String routeName = '/otpScreen';
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController());
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
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: ColorResources.backgroundWhiteColor,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      onPressed: () => Get.back(),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Enter OTP',
                            style: GoogleFonts.sora(
                              fontSize: mediaQuery.size.width * 0.06,
                              fontWeight: FontWeight.w500,
                              color: ColorResources.blackColor,
                            ),
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                width: mediaQuery.size.width * 0.12,
                                margin: EdgeInsets.symmetric(
                                  horizontal: mediaQuery.size.width * 0.01,
                                ),
                                child: TextField(
                                  controller: controller.otpControllers[index],
                                  focusNode: controller.focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: GoogleFonts.sora(
                                    fontSize: mediaQuery.size.width * 0.05,
                                    fontWeight: FontWeight.normal,
                                    color: ColorResources.blackColor,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: ColorResources.greyColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: ColorResources.blackColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: ColorResources.appMainColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 1 && index < 5) {
                                      FocusScope.of(context).requestFocus(
                                        controller.focusNodes[index + 1],
                                      );
                                    } else if (value.isEmpty && index > 0) {
                                      FocusScope.of(context).requestFocus(
                                        controller.focusNodes[index - 1],
                                      );
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.04),
                          Obx(
                            () => AppButton(
                              isLoading: controller.isLoading.value,
                              onPressed: controller.verifyOtp,
                              mediaQuery: mediaQuery,
                              child: Text(
                                "Verify",
                                style: GoogleFonts.sora(
                                  color: ColorResources.whiteColor,
                                  fontSize: mediaQuery.size.width * 0.03,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.04),
                          GestureDetector(
                            onTap: () => Get.offNamed(LoginScreen.routeName),
                            child: Text(
                              "Back to Login ?",
                              style: GoogleFonts.sora(
                                color: ColorResources.whiteColor,
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
                                        fontSize: mediaQuery.size.width * 0.03,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
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
