import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Snack%20Bar/custom_snack_bar.dart';

import '../Controllers/wifi_network_controller.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Layout/layout.dart';

class OfficeWifiScreen extends StatelessWidget {
  static const String routeName = '/officeWifiScreen';
  final WifiNetworkController controller = Get.put(WifiNetworkController());

  OfficeWifiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        title: "Office WiFi Details",
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Obx(() {
          if (controller.connectionType.value == 0) {
            return buildFullScreenOfflineUI(mq);
          }

          if (controller.isLoading.value && controller.wifiNetworks.isEmpty) {
            return const Center(child: Apploader());
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.wifiNetworks.isEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: GoogleFonts.sora(color: ColorResources.blackColor),
              ),
            );
          }

          return RefreshIndicator(
            elevation: 0.0,
            backgroundColor: ColorResources.backgroundWhiteColor,
            color: ColorResources.appMainColor,
            onRefresh: () async {
              await controller.fetchWifiNetworks();
            },
            child: SingleChildScrollView(
              // Add this wrapper
              physics:
                  const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
              child: Padding(
                padding: EdgeInsets.all(mq.size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.wifiNetworks.isEmpty)
                      Center(
                        child: Text(
                          "No WiFi networks available",
                          style: GoogleFonts.sora(
                            color: ColorResources.blackColor,
                          ),
                        ),
                      )
                    else
                      ...controller.wifiNetworks.map((wifi) {
                        return _WifiTile(
                          wifiName: wifi.name,
                          password: wifi.password,
                          notes: wifi.notes,
                          mq: mq,
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          );
        }),
      ).noKeyboard(),
    );
  }
}

class _WifiTile extends StatefulWidget {
  final String wifiName;
  final String password;
  final String notes;
  final MediaQueryData mq;

  const _WifiTile({
    required this.wifiName,
    required this.password,
    required this.notes,
    required this.mq,
  });

  @override
  State<_WifiTile> createState() => _WifiTileState();
}

class _WifiTileState extends State<_WifiTile> {
  bool isPasswordVisible = false;

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    customSnackBar(
      "Copied",
      "WiFi password copied!",
      snackBarType: SnackBarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.mq.size.height * 0.025),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorResources.blackColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorResources.blackColor.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.wifiName,
            style: GoogleFonts.sora(
              fontSize: widget.mq.size.width * 0.040,
              fontWeight: FontWeight.w500,
              color: ColorResources.blackColor,
            ),
          ),
          const SizedBox(height: 0),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => copyToClipboard(widget.password),
                  child: Text(
                    isPasswordVisible ? widget.password : '●●●●●●●●●',
                    style: GoogleFonts.sora(
                      fontSize: widget.mq.size.width * 0.040,
                      color: ColorResources.blackColor.withOpacity(0.8),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                  color: ColorResources.blackColor,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Iconsax.copy,
                  color: ColorResources.blackColor,
                ),
                onPressed: () => copyToClipboard(widget.password),
              ),
            ],
          ),

          if (widget.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Notes: ${widget.notes}",
              style: GoogleFonts.sora(
                color: ColorResources.blackColor,
                fontSize: widget.mq.size.width * 0.034,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
