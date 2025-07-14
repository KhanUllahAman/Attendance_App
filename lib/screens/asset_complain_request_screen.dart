import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';

import '../Controllers/asset_request_controller.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';

class AssetComplainRequestScreen extends StatelessWidget {
  static const String routeName = '/assetComplainRequestScreen';
  const AssetComplainRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final controller = Get.put(AssetRequestController());

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(mq.size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Asset Complaint New Request",
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.040,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.whiteColor,
                ),
              ),
              SizedBox(height: mq.size.height * 0.025),

              SearchableDropdown(
                hintText: "Select Request Type",
                items: [
                  "New",
                  "Replacement",
                  "Repair",
                  "Return",
                  "Issue",
                  "Complaint",
                ],
                onChange: (_) {},
                fillColor: ColorResources.whiteColor.withOpacity(0.05),
                hintColor: Colors.white70,
                textColor: Colors.white,
                dropdownController: controller.requestTypeCtrl,
                topText: "Request Type",
              ),
              SizedBox(height: mq.size.height * 0.025),

              SearchableDropdown(
                hintText: "Select Category",
                items: [
                  "Hardware",
                  "Software",
                  "Network",
                  "Office Facility",
                  "Other",
                ],
                onChange: (_) {},
                fillColor: ColorResources.whiteColor.withOpacity(0.05),
                hintColor: Colors.white70,
                textColor: Colors.white,
                dropdownController: controller.categoryCtrl,
                topText: "Category",
              ),
              SizedBox(height: mq.size.height * 0.025),

              SearchableDropdown(
                hintText: "Select Asset Type",
                items: [
                  "Mouse",
                  "Keyboard",
                  "Laptop",
                  "VPN",
                  "Monitor",
                  "Printer",
                ],
                onChange: (_) {},
                fillColor: ColorResources.whiteColor.withOpacity(0.05),
                hintColor: Colors.white70,
                textColor: Colors.white,
                dropdownController: controller.assetTypeCtrl,
                topText: "Asset Type",
              ),
              SizedBox(height: mq.size.height * 0.025),

              CustomTextFeild(
                controller: controller.reasonCtrl,
                mediaQuery: mq,
                hintText: "Enter reason for request",
              ),
              SizedBox(height: mq.size.height * 0.05),

              AppButton(
                mediaQuery: mq,
                onPressed: () {},
                isLoading: false,
                child: Text(
                  'Submit',
                  style: GoogleFonts.sora(
                    color: ColorResources.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: mq.size.width * 0.04,
                  ),
                ),
              ),
              SizedBox(height: mq.size.height * 0.02),
            ],
          ),
        ),
      ).noKeyboard(),
    );
  }
}
