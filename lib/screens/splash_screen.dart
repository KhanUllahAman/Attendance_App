import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../Controllers/splash_controller.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Constant/images_constant.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoHeight = screenHeight * 0.35;
    final logoWidth = screenWidth * 0.55;
    final spacing = screenHeight * 0.02;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ColorResources.getSystemUiOverlayAllPagesSplash(),
      child: GetBuilder<SplashController>(
        init: SplashController(),
        builder: (_) => Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagesConstant.splashBackground), // Add your background image path
                fit: BoxFit.cover, // This will make the image cover the entire screen
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOut,
                      builder: (context, opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0.8, end: 1.2),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeInOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              "assets/images/splashImage.png", 
                              fit: BoxFit.contain,
                              height: logoHeight.clamp(150.0, 300.0),
                              width: logoWidth.clamp(100.0, 250.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
