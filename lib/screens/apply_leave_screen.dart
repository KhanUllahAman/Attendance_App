import 'package:flutter/material.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Constant/images_constant.dart';

class ApplyLeaveScreen extends StatelessWidget {
  static const String routeName = '/applyLeave';
  const ApplyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: ColorResources.secondryColor,
      appBar: AppBar(
        toolbarHeight: mediaQuery.size.height * 0.060,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          ImagesConstant.splashImages,
          width: mediaQuery.size.width * 0.17,
          height: mediaQuery.size.width * 0.17,
          fit: BoxFit.contain,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: ColorResources.appBarGradient),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: ColorResources.whiteColor,
              size: mediaQuery.size.width * 0.06,
            ),
          ),
        ],
      ),
    );
  }
}
