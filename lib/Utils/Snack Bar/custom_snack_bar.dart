import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

    // Calculate responsive sizes
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 24.0 : 28.0;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final verticalPadding = isSmallScreen ? 14.0 : 18.0;
    const borderRadius = 12.0;
    final margin = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: screenHeight * 0.02,
    );

    List<Color> gradientColors;
    IconData iconData;

    switch (snackBarType) {
      case SnackBarType.success:
        gradientColors = [
          const Color(0xFF4CAF50),
          const Color(0xFF2E7D32),
        ];
        iconData = Icons.check_circle;
        break;
      case SnackBarType.error:
        gradientColors = [
          const Color(0xFFF44336),
          const Color(0xFFC62828),
        ];
        iconData = Icons.error;
        break;
      case SnackBarType.info:
        gradientColors = [
          const Color(0xFFFFC107), // Yellow for info
          const Color(0xFFFFA000),
        ];
        iconData = Icons.info;
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
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        borderRadius: borderRadius,
        gradientColors: gradientColors,
        dismissible: true,
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
          color: Colors.black.withOpacity(0.1),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutQuint,
      reverseAnimationCurve: Curves.easeInCirc,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      overlayBlur: 0.5,
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: iconSize,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
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
                color: Colors.white.withOpacity(0.8),
              ),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}