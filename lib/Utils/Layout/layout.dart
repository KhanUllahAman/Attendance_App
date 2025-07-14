import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Screens/home_screen.dart';
import 'package:orioattendanceapp/screens/leave_history_page_screen.dart';
import 'package:orioattendanceapp/screens/notification_screen.dart';
import 'package:orioattendanceapp/screens/profile_view_screen.dart';
import '../../screens/menu_screen.dart';
import '../Colors/color_resoursec.dart';
import '../Constant/images_constant.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final int currentTab;
  final bool isExtend;
  final bool showAppBar;
  final bool showLogo;
  final List<Widget> actionButtons;
  final double? appBarHeight;
  final bool showBackButton;

  const Layout({
    super.key,
    required this.body,
    this.currentTab = 0,
    this.isExtend = false,
    this.showAppBar = true,
    this.showLogo = true,
    this.actionButtons = const [],
    this.appBarHeight,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool keyboardIsOpened = mediaQuery.viewInsets.bottom != 0.0;
    double defaultAppBarHeight = mediaQuery.size.height * 0.07;

    return Scaffold(
      extendBodyBehindAppBar: isExtend,
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.secondryColor,
      appBar: showAppBar
          ? PreferredSize(
              preferredSize: Size.fromHeight(
                appBarHeight ?? defaultAppBarHeight,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: ColorResources.appBarGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Side: Back button + Logo
                      if (showBackButton)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: ColorResources.whiteColor,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      if (showLogo)
                        Image.asset(
                          ImagesConstant.splashImages,
                          width: mediaQuery.size.width * 0.2,
                          height: mediaQuery.size.width * 0.2,
                          fit: BoxFit.contain,
                        ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: body,
      floatingActionButton: keyboardIsOpened
          ? null
          : const LayoutFAB(), // Floating Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: LayoutBottomBar(currentTab: currentTab),
    );
  }
}

class LayoutFAB extends StatelessWidget {
  const LayoutFAB({super.key});

  @override
  Widget build(BuildContext context) {
    double size = 64;
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          Get.offNamed(HomeScreen.routeName);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Ink(
          decoration: BoxDecoration(
            color: ColorResources.appMainColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Iconsax.clock, color: ColorResources.whiteColor),
          ),
        ),
      ),
    );
  }
}

class LayoutBottomBar extends StatefulWidget {
  final int currentTab;

  const LayoutBottomBar({super.key, required this.currentTab});

  @override
  State<LayoutBottomBar> createState() => _LayoutBottomBarState();
}

class _LayoutBottomBarState extends State<LayoutBottomBar> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double barHeight = mediaQuery.size.height * 0.09;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorResources.appMainColor.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomAppBar(
        color: ColorResources.secondryColor,
        elevation: 18.0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: barHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NavigationButton(
                      onPressed: () {
                        Get.toNamed(LeaveHistoryPageScreen.routeName);
                      },
                      icon: Iconsax.activity,
                      text: 'Leave',
                      tab: 1,
                      currentTab: widget.currentTab,
                    ),
                    NavigationButton(
                      onPressed: () {
                        Get.toNamed(NotificationScreen.routeName);
                      },
                      icon: Iconsax.notification,
                      text: 'Notification',
                      tab: 2,
                      currentTab: widget.currentTab,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NavigationButton(
                      onPressed: () {
                        Get.toNamed(ProfileViewScreen.routeName);
                      },
                      icon: Iconsax.user,
                      text: 'Profile',
                      tab: 3,
                      currentTab: widget.currentTab,
                    ),
                    NavigationButton(
                      onPressed: () {
                        Get.toNamed(MenuScreen.routeName);
                      },
                      icon: Iconsax.more,
                      text: 'More',
                      tab: 4,
                      currentTab: widget.currentTab,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String text;
  final int tab, currentTab;
  final bool isDisabled;

  const NavigationButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.text,
    required this.tab,
    required this.currentTab,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double iconSize = mediaQuery.size.width * 0.06;
    double fontSize = mediaQuery.size.width * 0.032;

    Color color;
    if (isDisabled) {
      color = Colors.grey.shade400;
    } else {
      color = currentTab == tab
          ? ColorResources.appMainColor
          : ColorResources.whiteColor;
    }

    return MaterialButton(
      minWidth: mediaQuery.size.width * 0.12,
      onPressed: isDisabled ? null : onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: color),
          SizedBox(height: mediaQuery.size.height * 0.005),
          Text(
            text,
            style: GoogleFonts.sora(color: color, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
