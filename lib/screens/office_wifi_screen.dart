import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';

import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Layout/layout.dart';

class OfficeWifiScreen extends StatelessWidget {
  static const String routeName = '/officeWifiScreen';
  const OfficeWifiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final List<Map<String, String>> wifiList = [
      {
        'name': 'Office-WiFi-1',
        'password': 'superSecure123',
        'notes': 'Main floor usage only',
      },
      {
        'name': 'Conference-WiFi',
        'password': 'conf2024!',
        'notes': 'For meetings',
      },
    ];

    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(false),
      child: Layout(
        currentTab: 1,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Padding(
          padding: EdgeInsets.all(mq.size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Office WiFi Details",
                style: GoogleFonts.sora(
                  fontSize: mq.size.width * 0.040,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.whiteColor,
                ),
              ),
              SizedBox(height: mq.size.height * 0.02),

              ...wifiList.map((wifi) {
                return _WifiTile(
                  wifiName: wifi['name']!,
                  password: wifi['password']!,
                  notes: wifi['notes'] ?? '',
                  mq: mq,
                );
              }).toList(),
            ],
          ),
        ),
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
    Get.snackbar(
      "Copied",
      "WiFi password copied!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorResources.appMainColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.mq.size.height * 0.025),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorResources.whiteColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.wifiName,
            style: GoogleFonts.sora(
              fontSize: widget.mq.size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => copyToClipboard(widget.password),
                  child: Text(
                    isPasswordVisible ? widget.password : '●●●●●●●●●',
                    style: GoogleFonts.sora(
                      fontSize: widget.mq.size.width * 0.040,
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white70),
                onPressed: () => copyToClipboard(widget.password),
              ),
            ],
          ),

          if (widget.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Notes: ${widget.notes}",
              style: GoogleFonts.sora(
                color: Colors.white60,
                fontSize: widget.mq.size.width * 0.034,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
