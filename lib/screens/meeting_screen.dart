import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Style;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orioattendanceapp/Controllers/meeting_controller.dart';
import 'package:orioattendanceapp/Utils/AppWidget/App_widget.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import 'package:orioattendanceapp/models/meeting_model.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class MeetingScreen extends StatelessWidget {
  static const String routeName = "/meetingScreen";
  final MeetingController controller = Get.put(MeetingController());
  MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        title: "Meetings",
        currentTab: 4,
        showAppBar: true,
        showLogo: true,
        showBackButton: true,
        body: Obx(() {
          if (controller.connectionType.value == 0) {
            return buildFullScreenOfflineUI(mediaquery);
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(mediaquery.size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      elevation: 0.0,
                      onRefresh: () async {
                        controller.fetchmeetingdata();
                      },
                      color: ColorResources.appMainColor,
                      backgroundColor: Colors.white,
                      child: Obx(() {
                        if (controller.isloading.value) {
                          return Apploader();
                        }
                        if (controller.meetingRecord.isEmpty) {
                          return Center(
                            child: Text(
                              "No Meetings records found",
                              style: GoogleFonts.sora(color: Colors.white70),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: controller.meetingRecord.length,
                          itemBuilder: (context, index) {
                            return _AttendanceCard(
                              record: controller.meetingRecord[index],
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final Payload record;
  const _AttendanceCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double titleFontSize = screenWidth * 0.035 * textScaleFactor;
    final double statusFontSize = screenWidth * 0.03 * textScaleFactor;
    final double labelFontSize = screenWidth * 0.03 * textScaleFactor;
    final double valueFontSize = screenWidth * 0.0325 * textScaleFactor;
    final double containerPadding = screenWidth * 0.03;
    final double containerMargin = screenWidth * 0.025;
    final double spacing = screenWidth * 0.025;

    return GestureDetector(
      onTap: () => _showDetailsBottomSheet(context, record),
      child: Container(
        margin: EdgeInsets.only(bottom: containerMargin),
        padding: EdgeInsets.all(containerPadding),
        decoration: BoxDecoration(
          color: ColorResources.blackColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(containerPadding * 0.833),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.title,
                  style: GoogleFonts.sora(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: ColorResources.blackColor,
                  ),
                ),
                Text(
                  record.instanceDate,
                  style: GoogleFonts.sora(
                    fontSize: statusFontSize,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Time',
                      style: GoogleFonts.sora(
                        fontSize: labelFontSize,
                        color: ColorResources.blackColor,
                      ),
                    ),
                    Text(
                      record.startTime ?? '--',
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: ColorResources.blackColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End Time',
                      style: GoogleFonts.sora(
                        fontSize: labelFontSize,
                        color: ColorResources.blackColor,
                      ),
                    ),
                    Text(
                      record.endTime ?? '--',
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: ColorResources.blackColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: GoogleFonts.sora(
                        fontSize: labelFontSize,
                        color: ColorResources.blackColor,
                      ),
                    ),
                    Text(
                      record.status.capitalizeFirst.toString(),
                      // record.meetingInstanceId.toString(),
                      style: GoogleFonts.sora(
                        fontSize: valueFontSize,
                        color: ColorResources.blackColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showDetailsBottomSheet(BuildContext context, Payload record) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
  final double titleFontSize = screenWidth * 0.045 * textScaleFactor;
  final double padding = screenWidth * 0.04;
  final double handleWidth = screenWidth * 0.1;
  final double handleHeight = screenWidth * 0.01;
  final double borderRadius = screenWidth * 0.05;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: ColorResources.backgroundWhiteColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: handleWidth,
                  height: handleHeight,
                  decoration: BoxDecoration(
                    color: ColorResources.greyColor,
                    borderRadius: BorderRadius.circular(handleHeight * 0.5),
                  ),
                ),
              ),
              SizedBox(height: padding),
              Text(
                'Meeting Details',
                style: GoogleFonts.sora(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.blackColor,
                ),
              ),
              SizedBox(height: padding),
              _buildDetailTable(record),
              SizedBox(height: padding),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildDetailTable(Payload record) {
  return Table(
    columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
    border: TableBorder(
      horizontalInside: BorderSide(color: ColorResources.greyColor, width: 1),
    ),
    children: [
      _buildTableRow('Agenda', record.agenda),
      _buildTableRow('Host Name', record.hostName),
      _buildTableRow('Attendees', record.attendees),
      _buildTableRow('Date', record.instanceDate),
      _buildTableRow('Status', record.status.capitalizeFirst.toString()),
      _buildTableRow(
        'Location Type',
        record.locationType.capitalizeFirst.toString(),
      ),
      _buildTableRow('Location Detail', record.locationDetails),
      _buildTableRow(
        'Recurrence Rule',
        record.recurrenceRule.capitalizeFirst.toString(),
      ),
      _buildTableRow(
        'Recurrence Type',
        record.recurrenceType.capitalizeFirst.toString(),
      ),
      _buildTableButtonRow("Minutes", () {
        Get.back();
        showMinutesBottomSheet(record);
      }),
    ],
  );
}

TableRow _buildTableRow(String label, String value, {Color? color}) {
  return TableRow(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: GoogleFonts.sora(
            color: ColorResources.blackColor,
            fontSize: 14,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          value,
          style: GoogleFonts.sora(
            color: color ?? ColorResources.blackColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

TableRow _buildTableButtonRow(
  String label,
  VoidCallback onPressed, {
  Color? color,
}) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: GoogleFonts.sora(
            color: ColorResources.blackColor,
            fontSize: 14,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "View Minutes",
              style: GoogleFonts.sora(
                color: ColorResources.appMainColor,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: ColorResources.appMainColor,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

void showMinutesBottomSheet(Payload record) {
  final double screenWidth = Get.width;
  final double padding = screenWidth * 0.04;
  final double borderRadius = screenWidth * 0.05;

  Get.bottomSheet(
    DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        bool hasData =
            record.minutes != null && record.minutes!.trim().isNotEmpty;

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: ColorResources.backgroundWhiteColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              /// Drag handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: ColorResources.greyColor,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              SizedBox(height: padding),

              /// Title Row (Text + Button)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meeting Minutes',
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.blackColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      hasData ? Iconsax.edit : Iconsax.add,
                      color: ColorResources.appMainColor,
                    ),
                    onPressed: () {
                      if (hasData) {
                        try {
                          Get.back();

                          showMinutesEditorBottomSheet(record);
                        } catch (e) {
                          Get.snackbar('Error', 'Failed to load editor: $e');
                        }
                      } else {
                        Get.back();

                        showMinutesBottomSheet(record);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: padding),

              /// Data (HTML ya fallback text)
              hasData
                  ? Html(
                      data: record.minutes!,
                      style: {
                        "body": Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          fontSize: FontSize(14),
                          color: ColorResources.blackColor,
                          fontFamily: GoogleFonts.sora().fontFamily,
                        ),
                      },
                    )
                  : Text(
                      "No data available",
                      style: GoogleFonts.sora(fontSize: 14, color: Colors.grey),
                    ),

              SizedBox(height: padding),

              /// Close button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Close",
                    style: GoogleFonts.sora(
                      color: ColorResources.appMainColor,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: ColorResources.appMainColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

void showMinutesEditorBottomSheet(Payload record) {
  final double screenWidth = Get.width;
  final double padding = screenWidth * 0.04;
  final double borderRadius = screenWidth * 0.05;

  // Check agar record me data hai
  bool hasData = record.minutes != null && record.minutes!.trim().isNotEmpty;

  Document document;

  if (hasData) {
    try {
      final converter = HtmlToDelta();
      final converted = converter.convert(record.minutes!);

      if (converted is Delta) {
        // Agar direct Delta mila
        document = Document.fromDelta(converted);
      } else if (converted is List) {
        // Agar List<dynamic> mila
        final ops = converted
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        document = Document.fromJson(ops);
      } else {
        // Agar kuch aur mila to plain text use karo
        document = Document()
          ..insert(0, _htmlToPlainText(record.minutes!) + '\n');
      }
    } catch (e) {
      // Fallback plain text
      document = Document()
        ..insert(0, _htmlToPlainText(record.minutes!) + '\n');
    }
  } else {
    // Empty document
    document = Document()..insert(0, '\n');
  }

  // ✅ Controller ab yahan safely bana sakte ho
  final quillController = QuillController(
    document: document,
    selection: const TextSelection.collapsed(offset: 0),
  );

  final editorScrollController = ScrollController();
  final focusNode = FocusNode();

  Get.bottomSheet(
    DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: ColorResources.backgroundWhiteColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: ColorResources.greyColor,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              SizedBox(height: padding),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Meeting Minutes',
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.blackColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.tick_circle, color: Colors.green),
                    onPressed: () {
                      // Result as plain text
                      Get.back(result: quillController.document.toPlainText());
                    },
                  ),
                ],
              ),
              SizedBox(height: padding),

              // Editor (scrollable)
              SizedBox(
                child: QuillEditorWidget(
                  controller: quillController,
                  focusNode: focusNode,
                  scrollController: editorScrollController,
                ),
              ),

              SizedBox(height: padding),

              // Close button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Close",
                    style: GoogleFonts.sora(
                      color: ColorResources.appMainColor,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: ColorResources.appMainColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

String _htmlToPlainText(String html) {
  dom.Document document = html_parser.parse(html);
  return document.body?.text ?? html;
}

class QuillEditorWidget extends StatelessWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;

  const QuillEditorWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // 🔹 Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Edit Minutes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  tooltip: "Save",
                  onPressed: () {
                    // Convert Delta to HTML
                    // final deltaJson = controller.document.toDelta().toJson();
                    // final converter = QuillDeltaToHtmlConverter(deltaJson);
                    // final html = converter.convert();

                    // // Close sheet and return HTML string
                    // Get.back(result: html);
                  },
                ),
              ],
            ),
          ),

          // 🔹 Toolbar
          QuillSimpleToolbar(
            controller: controller,
            config: QuillSimpleToolbarConfig(
              showFontFamily: true,
              showFontSize: true,
              showLineHeightButton: true,
              showClipboardPaste: true,

              customButtons: [
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.access_time_rounded),
                  onPressed: () {
                    controller.document.insert(
                      controller.selection.extentOffset,
                      TimeStampEmbed(DateTime.now().toString()),
                    );

                    controller.updateSelection(
                      TextSelection.collapsed(
                        offset: controller.selection.extentOffset + 1,
                      ),
                      ChangeSource.local,
                    );
                  },
                ),
              ],

              buttonOptions: QuillSimpleToolbarButtonOptions(
                base: QuillToolbarBaseButtonOptions(
                  afterButtonPressed: () {
                    final isDesktop = {
                      TargetPlatform.linux,
                      TargetPlatform.windows,
                      TargetPlatform.macOS,
                    }.contains(defaultTargetPlatform);
                    if (isDesktop) {
                      focusNode.requestFocus();
                    }
                  },
                  iconTheme: QuillIconTheme(
                    iconButtonUnselectedData: IconButtonData(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Colors.black,
                        ), // icon color
                        backgroundColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ), // bg
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    // 🔹 Selected (active) icon style
                    iconButtonSelectedData: IconButtonData(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          ColorResources.appMainColor,
                        ), // icon color
                        backgroundColor: MaterialStateProperty.all(
                          ColorResources.appMainColor.withOpacity(0.3),
                        ), // bg
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                linkStyle: QuillToolbarLinkStyleButtonOptions(
                  dialogTheme: QuillDialogTheme(
                    dialogBackgroundColor: ColorResources.whiteColor,
                    labelTextStyle: TextStyle(
                      color: ColorResources.appMainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    inputTextStyle: TextStyle(color: Colors.black),
                    linkDialogPadding: EdgeInsets.all(16),
                  ),
                  validateLink: (link) => true,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 🔹 Editor
          SizedBox(
            child: QuillEditor(
              focusNode: focusNode,
              scrollController: scrollController,
              controller: controller,
              config: QuillEditorConfig(
                placeholder: 'Start writing your notes...',
                padding: EdgeInsets.all(16),
                scrollable: true,
                embedBuilders: [TimeStampEmbedBuilder()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(String value) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) => node.value.data;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        Text(embedContext.node.value.data as String),
      ],
    );
  }
}
