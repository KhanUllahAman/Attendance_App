import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/screens/asset_complain_request_screen.dart';

import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';

class AssetComplainRequestScreenList extends StatelessWidget {
  static const String routeName = '/assetComplainRequestScreenList';
  const AssetComplainRequestScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final searchController = TextEditingController();

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(mq.size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Asset Complaints",
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.040,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.whiteColor,
                    ),
                  ),
                  SizedBox(height: mq.size.height * 0.015),
                  CustomSearchField(
                    controller: searchController,
                    hintText: "Search by type, category or status",
                    onChanged: (value) {},
                  ),
                  SizedBox(height: mq.size.height * 0.02),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () =>
                              _showRequestDetailBottomSheet(context, mq),
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: mq.size.height * 0.015,
                            ),
                            padding: EdgeInsets.all(mq.size.width * 0.035),
                            decoration: BoxDecoration(
                              color: ColorResources.whiteColor.withOpacity(
                                0.04,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoRow("Request Type", "Repair", mq),
                                _infoRow("Category", "Laptop", mq),
                                _infoRow("Asset Type", "Dell XPS 15", mq),
                                _infoRow(
                                  "Status",
                                  "in_progress",
                                  mq,
                                  badgeColor: Colors.orangeAccent,
                                ),
                                _infoRow("Requested On", "2024-12-05", mq),
                                _infoRow("Reviewed On", "-", mq),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AssetComplainRequestScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: ColorResources.appBarGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Icon(Iconsax.add_circle, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
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
                color: Colors.white70,
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
                      "In Progress",
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
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showRequestDetailBottomSheet(BuildContext context, MediaQueryData mq) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorResources.secondryColor,
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
                  color: Colors.white30,
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
                  color: ColorResources.whiteColor,
                ),
              ),
            ),
            SizedBox(height: mq.size.height * 0.025),
            _bottomSheetDetail("Request Type", "Repair", mq),
            _bottomSheetDetail("Category & Asset", "Laptop - Dell XPS 15", mq),
            _bottomSheetDetail("Reason", "Keyboard not working", mq),
            _bottomSheetDetail("Requested Date", "2024-12-05", mq),
            _bottomSheetDetail(
              "Status",
              "In Progress",
              mq,
              color: Colors.orangeAccent,
            ),
            _bottomSheetDetail(
              "Resolution Remarks",
              "Awaiting technician response",
              mq,
            ),
            _bottomSheetDetail("Reviewed By", "Admin", mq),
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
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.sora(
                fontSize: mq.size.width * 0.032,
                color: color ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
