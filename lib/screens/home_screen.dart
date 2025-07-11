import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Constant/images_constant.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 0,
        body: Column(
          children: [
            Container(
              height: mediaQuery.size.height * 0.3,
              decoration: BoxDecoration(
                gradient: ColorResources.appBarGradient,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.height * 0.02,
                  vertical: mediaQuery.size.width * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          CircleAvatar(
                                radius: mediaQuery.size.width * 0.06,
                                backgroundImage: const AssetImage(
                                  ImagesConstant.splashImages,
                                ),
                                backgroundColor: ColorResources.whiteColor
                                    .withOpacity(0.2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ColorResources.whiteColor
                                          .withOpacity(0.5),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideX(begin: -0.2),
                          SizedBox(width: mediaQuery.size.width * 0.03),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                    'Aman Khan',
                                    style: GoogleFonts.sora(
                                      fontSize: mediaQuery.size.width * 0.040,
                                      fontWeight: FontWeight.w500,
                                      color: ColorResources.whiteColor,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideX(begin: -0.2),
                              SizedBox(height: mediaQuery.size.height * 0.005),
                              Text(
                                    _getGreeting(),
                                    style: GoogleFonts.sora(
                                      fontSize: mediaQuery.size.width * 0.035,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.whiteColor
                                          .withOpacity(0.8),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideX(begin: -0.2),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      ImagesConstant.splashImages,
                      width: mediaQuery.size.width * 0.2,
                      height: mediaQuery.size.width * 0.2,
                      fit: BoxFit.contain,
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2),
                  ],
                ),
              ),
            ),
            // Secondary Color Container
            Expanded(
              child: Container(
                color: ColorResources.secondryColor,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -(mediaQuery.size.height * 0.17 / 2),
                      left: mediaQuery.size.width * 0.05,
                      right: mediaQuery.size.width * 0.05,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorResources.secondryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '09:10 AM',
                              style: GoogleFonts.sora(
                                fontSize: mediaQuery.size.width * 0.060,
                                fontWeight: FontWeight.w500,
                                color: ColorResources.whiteColor,
                              ),
                            ),
                            Text(
                              'March 19, 2024 - Friday',
                              style: GoogleFonts.sora(
                                fontSize: mediaQuery.size.width * 0.035,
                                fontWeight: FontWeight.w500,
                                color: ColorResources.whiteColor,
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.03),
                            AvatarGlow(
                              glowColor: ColorResources.appMainColor
                                  .withOpacity(0.5),
                              duration: const Duration(milliseconds: 2000),
                              repeat: true,
                              glowCount: 2,
                              glowRadiusFactor: 0.3, // Reduced glow spread
                              child: Material(
                                shape: const CircleBorder(),
                                child: Container(
                                  width: mediaQuery.size.width * 0.50,
                                  height: mediaQuery.size.width * 0.50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorResources.appMainColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.login,
                                        size: mediaQuery.size.width * 0.17,
                                        color: ColorResources.whiteColor,
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height * 0.005,
                                      ),
                                      Text(
                                        'Check In',
                                        style: GoogleFonts.sora(
                                          fontSize:
                                              mediaQuery.size.width * 0.035,
                                          fontWeight: FontWeight.w500,
                                          color: ColorResources.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.location,
                                      size: mediaQuery.size.width * 0.06,
                                      color: ColorResources.whiteColor
                                          .withOpacity(0.8),
                                    ),
                                    SizedBox(
                                      width: mediaQuery.size.width * 0.02,
                                    ),
                                    Text(
                                      'You are in the office range',
                                      style: GoogleFonts.sora(
                                        fontSize: mediaQuery.size.width * 0.035,
                                        fontWeight: FontWeight.w400,
                                        color: ColorResources.whiteColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                )
                                .animate()
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.2),
                            SizedBox(height: mediaQuery.size.height * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                      children: [
                                        Icon(
                                          Iconsax.login,
                                          size: mediaQuery.size.width * 0.07,
                                          color: ColorResources.whiteColor,
                                        ),
                                        SizedBox(
                                          height: mediaQuery.size.height * 0.01,
                                        ),
                                        Text(
                                          '09:00 AM',
                                          style: GoogleFonts.sora(
                                            fontSize:
                                                mediaQuery.size.width * 0.030,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.whiteColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              mediaQuery.size.height * 0.005,
                                        ),
                                        Text(
                                          'Check In',
                                          style: GoogleFonts.sora(
                                            fontSize:
                                                mediaQuery.size.width * 0.03,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.whiteColor
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(duration: 800.ms)
                                    .slideY(begin: 0.2),
                                Column(
                                      children: [
                                        Icon(
                                          Iconsax.logout,
                                          size: mediaQuery.size.width * 0.07,
                                          color: ColorResources.whiteColor,
                                        ),
                                        SizedBox(
                                          height: mediaQuery.size.height * 0.01,
                                        ),
                                        Text(
                                          '05:00 PM',
                                          style: GoogleFonts.sora(
                                            fontSize:
                                                mediaQuery.size.width * 0.030,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.whiteColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              mediaQuery.size.height * 0.005,
                                        ),
                                        Text(
                                          'Check Out',
                                          style: GoogleFonts.sora(
                                            fontSize:
                                                mediaQuery.size.width * 0.03,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.whiteColor
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(duration: 800.ms)
                                    .slideY(begin: 0.2),
                                Column(
                                      children: [
                                        Icon(
                                          Iconsax.clock,
                                          size: mediaQuery.size.width * 0.07,
                                          color: ColorResources.whiteColor,
                                        ),
                                        SizedBox(
                                          height: mediaQuery.size.height * 0.01,
                                        ),
                                        Text(
                                          '8h 00m',
                                          style: GoogleFonts.sora(
                                            fontSize:
                                                mediaQuery.size.width * 0.030,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.whiteColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              mediaQuery.size.height * 0.005,
                                        ),
                                        Text(
                                          'Working Hours',
                                          style: GoogleFonts.sora(
                                            fontSize:
                                                mediaQuery.size.width * 0.03,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.whiteColor
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(duration: 800.ms)
                                    .slideY(begin: 0.2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
