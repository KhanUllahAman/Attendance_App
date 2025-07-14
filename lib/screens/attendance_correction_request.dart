import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';

import '../Controllers/attendance_correction_controller.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';

class AttendanceCorrectionRequest extends StatelessWidget {
  static const String routeName = '/attendanceCorrectionRequest';
  const AttendanceCorrectionRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return GetBuilder<AttendanceCorrectionController>(
      init: AttendanceCorrectionController(),
      builder: (controller) {
        return AnnotatedRegion(
          value: ColorResources.getSystemUiOverlayAllPages(false),
          child: Layout(
            currentTab: 4,
            showAppBar: true,
            showLogo: true,
            showBackButton: true,
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.size.height * 0.03),
                  Text(
                    "Attendance Correction",
                    style: GoogleFonts.sora(
                      fontSize: mq.size.width * 0.040,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.whiteColor,
                    ),
                  ),
                  SizedBox(height: mq.size.height * 0.03),
                  GestureDetector(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 1),
                        initialDate: controller.selectedDate.value ?? now,
                      );
                      if (picked != null) controller.setSelectedDate(picked);
                    },
                    child: Obx(() {
                      return CustomTextFeild(
                        mediaQuery: mq,
                        controller: TextEditingController(
                          text: controller.selectedDate.value != null
                              ? DateFormat(
                                  'yyyy-MM-dd',
                                ).format(controller.selectedDate.value!)
                              : '',
                        ),
                        hintText: 'Select Attendance Date',
                        readOnly: true,
                      );
                    }),
                  ),

                  SizedBox(height: mq.size.height * 0.02),

                  // Searchable Dropdown
                  SearchableDropdown(
                    hintText: 'Select Request Type',
                    items: controller.requestTypes,
                    dropdownController:
                        controller.requestTypeDropdownController,
                    onChange: (val) =>
                        controller.selectedRequestType.value = val,
                    fillColor: ColorResources.whiteColor.withOpacity(0.05),
                    hintColor: Colors.white70,
                    textColor: Colors.white,
                  ),

                  SizedBox(height: mq.size.height * 0.02),

                  // Conditional Time Pickers
                  Obx(() {
                    final type = controller.selectedRequestType.value;
                    return Column(
                      children: [
                        if (type == 'missed_check_in' ||
                            type == 'wrong_time' ||
                            type == 'both')
                          CustomTimePickerField(
                            label: 'Check-In Time',
                            selectedTime: controller.checkInTime.value,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      timePickerTheme: TimePickerThemeData(
                                        backgroundColor:
                                            ColorResources.secondryColor,
                                        dialHandColor:
                                            ColorResources.appMainColor,
                                        dialTextColor:
                                            ColorResources.whiteColor,
                                        entryModeIconColor:
                                            ColorResources.appMainColor,
                                        hourMinuteTextColor:
                                            ColorResources.whiteColor,
                                        dayPeriodTextColor:
                                            ColorResources.whiteColor,
                                        helpTextStyle: TextStyle(
                                          color: ColorResources.whiteColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      colorScheme: ColorScheme.dark(
                                        primary: ColorResources.appMainColor,
                                        onPrimary: ColorResources.whiteColor,
                                        surface: ColorResources.secondryColor,
                                        onSurface: ColorResources.whiteColor,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              ColorResources.appMainColor,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                controller.setCheckInTime(picked);
                              }
                            },
                          ),
                        if (type == 'missed_check_out' ||
                            type == 'wrong_time' ||
                            type == 'both')
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomTimePickerField(
                              label: 'Check-Out Time',
                              selectedTime: controller.checkOutTime.value,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        timePickerTheme: TimePickerThemeData(
                                          backgroundColor:
                                              ColorResources.secondryColor,
                                          dialHandColor:
                                              ColorResources.appMainColor,
                                          dialTextColor:
                                              ColorResources.whiteColor,
                                          entryModeIconColor:
                                              ColorResources.appMainColor,
                                          hourMinuteTextColor:
                                              ColorResources.whiteColor,
                                          dayPeriodTextColor:
                                              ColorResources.whiteColor,
                                          helpTextStyle: TextStyle(
                                            color: ColorResources.whiteColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        colorScheme: ColorScheme.dark(
                                          primary: ColorResources.appMainColor,
                                          onPrimary: ColorResources.whiteColor,
                                          surface: ColorResources.secondryColor,
                                          onSurface: ColorResources.whiteColor,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                ColorResources.appMainColor,
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  controller.setCheckInTime(picked);
                                }
                              },
                            ),
                          ),
                      ],
                    );
                  }),

                  SizedBox(height: mq.size.height * 0.02),

                  // Reason
                  CustomTextFeild(
                    controller: controller.reasonController,
                    mediaQuery: mq,
                    hintText: 'Reason for Correction',
                  ),

                  SizedBox(height: mq.size.height * 0.04),

                  // Submit Button
                  AppButton(
                    mediaQuery: mq,
                    isLoading: false,
                    onPressed: controller.submitRequest,
                    child: Text(
                      "Submit Request",
                      style: GoogleFonts.sora(
                        fontSize: mq.size.width * 0.035,
                        fontWeight: FontWeight.w400,
                        color: ColorResources.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
