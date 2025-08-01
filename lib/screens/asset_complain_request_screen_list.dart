import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/asset_complain_request_screen.dart';
import '../Controllers/asset_complain_request_list_controller.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../models/asset_complian_request_model.dart';

class AssetComplainRequestScreenList extends StatelessWidget {
  static const String routeName = '/assetComplainRequestScreenList';
  final AssetComplainRequestListController controller = Get.put(
    AssetComplainRequestListController(),
  );

  AssetComplainRequestScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        title: "Asset Complaints",
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
              Padding(
                padding: EdgeInsets.all(mq.size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Asset Complaints Requests",
                          style: GoogleFonts.sora(
                            fontSize: mq.size.width * 0.040,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.blackColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(AssetComplainRequestScreen.routeName);
                          },
                          icon: Icon(
                            Iconsax.add_circle,
                            color: ColorResources.appMainColor,
                            size: mq.size.height * 0.04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mq.size.height * 0.010),
                    CustomSearchField(
                      controller: controller.searchController,
                      hintText: "Search by type, category or status",
                      onChanged: (value) => controller.filterComplaints(),
                    ),
                    SizedBox(height: mq.size.height * 0.02),
                    Expanded(
                      child: RefreshIndicator(
                        elevation: 0.0,

                        color: ColorResources.backgroundWhiteColor,
                        backgroundColor: ColorResources.appMainColor,
                        onRefresh: () => controller.fetchAssetComplaints(),
                        child: _buildComplaintsList(mq),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isLoading.value) Apploader(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildComplaintsList(MediaQueryData mq) {
    if (controller.errorMessage.value.isNotEmpty &&
        controller.filteredComplaints.isEmpty) {
      return Center(
        child: Text(
          controller.errorMessage.value,
          style: GoogleFonts.sora(color: ColorResources.blackColor),
        ),
      );
    }

    if (controller.filteredComplaints.isEmpty) {
      return Center(
        child: Text(
          "No complaints found",
          style: GoogleFonts.sora(color: ColorResources.blackColor),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.filteredComplaints.length,
      itemBuilder: (context, index) {
        final complaint = controller.filteredComplaints[index];
        return GestureDetector(
          onTap: () => _showRequestDetailBottomSheet(context, mq, complaint),
          child: Container(
            margin: EdgeInsets.only(bottom: mq.size.height * 0.015),
            padding: EdgeInsets.all(mq.size.width * 0.035),
            decoration: BoxDecoration(
              color: ColorResources.blackColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorResources.blackColor.withOpacity(0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(
                  "Request Type",
                  complaint.requestType.capitalizeFirst.toString(),
                  mq,
                ),
                _infoRow(
                  "Category",
                  complaint.category.capitalizeFirst.toString(),
                  mq,
                ),
                _infoRow(
                  "Asset Type",
                  complaint.assetType.capitalizeFirst.toString(),
                  mq,
                ),
                _infoRow(
                  "Status",
                  complaint.statusText,
                  mq,
                  badgeColor: complaint.statusColor,
                ),
                _infoRow("Requested On", complaint.formattedRequestedAt, mq),
                _infoRow(
                  "Reviewed On",
                  complaint.formattedReviewedAt ?? "-",
                  mq,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(
    String title,
    String value,
    MediaQueryData mq, {
    Color? badgeColor,
  }) {
    final isBadge = title == "Status";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: mq.size.width * 0.32,
            child: Text(
              "$title:",
              style: GoogleFonts.sora(
                fontSize: mq.size.width * 0.032,
                fontWeight: FontWeight.w500,
                color: ColorResources.blackColor,
              ),
            ),
          ),
          Expanded(
            child: isBadge
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? Colors.grey).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      value,
                      style: GoogleFonts.sora(
                        fontSize: mq.size.width * 0.032,
                        color: badgeColor ?? Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.032,
                      color: ColorResources.blackColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showRequestDetailBottomSheet(
    BuildContext context,
    MediaQueryData mq,
    AssetComplaint complaint,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorResources.backgroundWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: mq.size.width * 0.05,
          right: mq.size.width * 0.05,
          top: mq.size.height * 0.025,
          bottom: mq.viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: ColorResources.greyColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: mq.size.height * 0.02),
            Center(
              child: Text(
                "Request Details",
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.blackColor,
                ),
              ),
            ),
            SizedBox(height: mq.size.height * 0.025),
            _bottomSheetDetail(
              "Request Type",
              complaint.requestType.capitalizeFirst.toString(),
              mq,
            ),
            _bottomSheetDetail(
              "Category & Asset",
              "${complaint.category.capitalizeFirst} - ${complaint.assetType.capitalizeFirst}",
              mq,
            ),
            _bottomSheetDetail("Reason", complaint.reason, mq),
            _bottomSheetDetail(
              "Requested Date",
              complaint.formattedRequestedAt,
              mq,
            ),
            _bottomSheetDetail(
              "Status",
              complaint.statusText,
              mq,
              color: complaint.statusColor,
            ),
            _bottomSheetDetail(
              "Resolution Remarks",
              complaint.resolutionRemarks ?? "No remarks yet",
              mq,
            ),
            _bottomSheetDetail(
              "Reviewed By",
              complaint.reviewedBy?.toString() ?? "Not reviewed yet",
              mq,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetDetail(
    String title,
    String value,
    MediaQueryData mq, {
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.size.height * 0.007),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: mq.size.width * 0.32,
            child: Text(
              "$title:",
              style: GoogleFonts.sora(
                fontSize: mq.size.width * 0.032,
                fontWeight: FontWeight.w600,
                color: ColorResources.blackColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.sora(
                fontSize: mq.size.width * 0.032,
                color: color ?? ColorResources.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
