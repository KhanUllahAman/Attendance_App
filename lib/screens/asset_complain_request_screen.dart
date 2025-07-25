import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';

import '../Controllers/asset_request_controller.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';

class AssetComplainRequestScreen extends StatelessWidget {
  static const String routeName = '/assetComplainRequestScreen';
  final AssetRequestController controller = Get.put(AssetRequestController());

  AssetComplainRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Obx(() {
          if (controller.connectionType.value == 0) {
            return buildFullScreenOfflineUI(mq);
          }
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(mq.size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Asset Complaint New Request",
                      style: GoogleFonts.sora(
                        fontSize: mq.size.width * 0.040,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.blackColor,
                      ),
                    ),
                    SizedBox(height: mq.size.height * 0.025),

                    SearchableDropdown(
                      hintText: "Select Request Type",
                      items: controller.requestTypeOptions,
                      onChange: controller.requestTypeCtrl.selectItem,
                      fillColor: ColorResources.blackColor.withOpacity(0.05),
                      hintColor: Colors.black38,
                      textColor: Colors.black54,
                      dropdownController: controller.requestTypeCtrl,
                      topText: "Request Type",
                    ),
                    SizedBox(height: mq.size.height * 0.025),

                    SearchableDropdown(
                      hintText: "Select Category",
                      items: controller.categoryOptions,
                      onChange: controller.categoryCtrl.selectItem,
                      fillColor: ColorResources.blackColor.withOpacity(0.05),
                      hintColor: Colors.black38,
                      textColor: Colors.black54,
                      dropdownController: controller.categoryCtrl,
                      topText: "Category",
                    ),
                    SizedBox(height: mq.size.height * 0.025),

                    SearchableDropdown(
                      hintText: "Select Asset Type",
                      items: controller.assetTypeOptions,
                      onChange: controller.assetTypeCtrl.selectItem,
                      fillColor: ColorResources.blackColor.withOpacity(0.05),
                      hintColor: Colors.black38,
                      textColor: Colors.black54,
                      dropdownController: controller.assetTypeCtrl,
                      topText: "Asset Type",
                    ),
                    SizedBox(height: mq.size.height * 0.025),

                    CustomTextFeild(
                      controller: controller.reasonCtrl,
                      mediaQuery: mq,
                      hintText: "Enter reason for request",
                      maxLines: 4,
                    ),
                    SizedBox(height: mq.size.height * 0.03),

                    AppButton(
                      mediaQuery: mq,
                      onPressed: () {
                        controller.submitRequest(context);
                      },
                      isLoading: controller.isLoading.value,
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
              if (controller.isLoading.value) Apploader(),
            ],
          );
        }).noKeyboard(),
      ),
    );
  }
}
