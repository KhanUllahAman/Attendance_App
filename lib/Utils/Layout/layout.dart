import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../Colors/color_resoursec.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final int currentTab;
  final bool isExtend;
  const Layout({
    super.key,
    required this.body,
    this.currentTab = 0,
    this.isExtend = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool keyboardIsOpened = mediaQuery.viewInsets.bottom != 0.0;
    return Scaffold(
      extendBodyBehindAppBar: isExtend,
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.secondryColor,
      body: body,
      floatingActionButton: keyboardIsOpened ? null : const LayoutFAB(),
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
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Ink(
          decoration: BoxDecoration(
            color: ColorResources.appMainColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Iconsax.add_circle, color: ColorResources.whiteColor),
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
                      onPressed: () {},
                      icon: Iconsax.activity,
                      text: 'Leave',
                      tab: 1,
                      currentTab: widget.currentTab,
                    ),
                    NavigationButton(
                      onPressed: null,
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
                      onPressed: () {},
                      icon: Iconsax.user,
                      text: 'Profile',
                      tab: 3,
                      currentTab: widget.currentTab,
                    ),
                    NavigationButton(
                      onPressed: () {},
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
