import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';

enum SnackBarType { success, error, info }

void customSnackBar(
  String title,
  String message, {
  SnackBarType snackBarType = SnackBarType.success,
  int durationSeconds = 4,
}) {
  if (Get.context == null) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 26.0 : 30.0;
    final paddingH = isSmallScreen ? 16.0 : 20.0;
    final paddingV = isSmallScreen ? 14.0 : 18.0;
    const borderRadius = 16.0;
    final margin = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: screenHeight * 0.02,
    );

    List<Color> gradientColors;
    IconData iconData;

    switch (snackBarType) {
      case SnackBarType.success:
        gradientColors = [Color(0xFF4CAF50), Color(0xFF2E7D32)];
        iconData = Icons.check_circle;
        break;
      case SnackBarType.error:
        gradientColors = [Color(0xFFF44336), Color(0xFFC62828)];
        iconData = Icons.error_outline;
        break;
      case SnackBarType.info:
        gradientColors = [ColorResources.appMainColor, ColorResources.secondryColor];
        iconData = Icons.info_outline;
        break;
    }

    Get.snackbar(
      '',
      '',
      titleText: _SnackBarContent(
        title: title,
        message: message,
        iconData: iconData,
        iconSize: iconSize,
        horizontalPadding: paddingH,
        verticalPadding: paddingV,
        borderRadius: borderRadius,
        gradientColors: gradientColors,
        dismissible: true,
        durationSeconds: durationSeconds,
      ),
      messageText: const SizedBox(),
      padding: EdgeInsets.zero,
      margin: margin,
      duration: Duration(seconds: durationSeconds),
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: borderRadius,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
      animationDuration: Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      overlayBlur: 0.8,
      overlayColor: Colors.black.withOpacity(0.05),
    );
  });
}

class _SnackBarContent extends StatelessWidget {
  final String title;
  final String message;
  final IconData iconData;
  final double iconSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final List<Color> gradientColors;
  final bool dismissible;
  final int durationSeconds;

  const _SnackBarContent({
    required this.title,
    required this.message,
    required this.iconData,
    required this.iconSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.gradientColors,
    required this.dismissible,
    required this.durationSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withOpacity(0.4),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                    )
                  ],
                ),
                padding: EdgeInsets.all(6),
                child: Icon(
                  iconData,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.95),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (dismissible)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white.withOpacity(0.85),
                  ),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
            ],
          ),
        ),
        // Progress bar at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: TweenAnimationBuilder<double>(
            duration: Duration(seconds: durationSeconds),
            tween: Tween(begin: 1.0, end: 0.0),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.white.withOpacity(0.1),
                color: Colors.white.withOpacity(0.8),
                minHeight: 3,
              );
            },
          ),
        )
      ],
    );
  }
}
