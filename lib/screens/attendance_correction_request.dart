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
    final AttendanceCorrectionController controller = Get.put(
      AttendanceCorrectionController(),
    );

    AttendanceCorrectionRequest({super.key});

    @override
    Widget build(BuildContext context) {
      final mq = MediaQuery.of(context);

      return AnnotatedRegion(
        value: ColorResources.getSystemUiOverlayAllPages(),
        child: Layout(
          title: "Attendance Correction Request",
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
                  padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: mq.size.height * 0.03),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => CustomDatePicker(
                              initialDate: controller.selectedDate.value,
                              allowFutureDates: false,
                              onDateSelected: (date) {
                                controller.setSelectedDate(date);
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: mq.size.width * 0.04,
                            vertical: mq.size.height * 0.015,
                          ),
                          decoration: BoxDecoration(
                            color: ColorResources.blackColor.withOpacity(
                              0.05,
                            ), // आपका ग्रे कलर
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(
                            () => Center(
                              child: Text(
                                controller.selectedDate.value != null
                                    ? DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(controller.selectedDate.value!)
                                    : 'Please Select Date',
                                style: GoogleFonts.sora(
                                  color: ColorResources.blackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: mq.size.height * 0.02),
                      SearchableDropdown(
                        hintText: 'Select Request Type',
                        items: controller.requestTypeOptions,
                        dropdownController:
                            controller.requestTypeDropdownController,
                        onChange: controller.setRequestType,
                        fillColor: ColorResources.blackColor.withOpacity(0.05),
                        hintColor: Colors.black38,
                        textColor: Colors.black54,
                      ),
                      SizedBox(height: mq.size.height * 0.02),
                      Obx(() {
                        final type = controller.selectedRequestType.value;
                        return Column(
                          children: [
                            if (type?.requiresCheckIn ?? false)
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
                                            backgroundColor: ColorResources
                                                .backgroundWhiteColor,
                                            dialHandColor:
                                                ColorResources.appMainColor,
                                            dialTextColor:
                                                ColorResources.blackColor,
                                            entryModeIconColor:
                                                ColorResources.appMainColor,
                                            hourMinuteTextColor:
                                                ColorResources.blackColor,
                                            dayPeriodTextColor:
                                                ColorResources.blackColor,
                                            helpTextStyle: TextStyle(
                                              color: ColorResources.blackColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          colorScheme: ColorScheme.dark(
                                            primary: ColorResources.appMainColor,
                                            onPrimary: ColorResources.blackColor,
                                            surface: ColorResources
                                                .backgroundWhiteColor,
                                            onSurface: ColorResources.blackColor,
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
                            if (type?.requiresCheckOut ?? false)
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
                                              backgroundColor: ColorResources
                                                  .backgroundWhiteColor,
                                              dialHandColor:
                                                  ColorResources.appMainColor,
                                              dialTextColor:
                                                  ColorResources.blackColor,
                                              entryModeIconColor:
                                                  ColorResources.appMainColor,
                                              hourMinuteTextColor:
                                                  ColorResources.blackColor,
                                              dayPeriodTextColor:
                                                  ColorResources.blackColor,
                                              helpTextStyle: TextStyle(
                                                color: ColorResources.blackColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                            colorScheme: ColorScheme.dark(
                                              primary:
                                                  ColorResources.appMainColor,
                                              onPrimary:
                                                  ColorResources.blackColor,
                                              surface: ColorResources
                                                  .backgroundWhiteColor,
                                              onSurface:
                                                  ColorResources.blackColor,
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
                                      controller.setCheckOutTime(picked);
                                    }
                                  },
                                ),
                              ),
                          ],
                        );
                      }),
                      SizedBox(height: mq.size.height * 0.02),
                      CustomTextFeild(
                        controller: controller.reasonController,
                        mediaQuery: mq,
                        hintText: 'Reason for Correction',
                        maxLines: 4,
                      ),
                      SizedBox(height: mq.size.height * 0.04),
                      AppButton(
                        mediaQuery: mq,
                        onPressed: () async {
                          await controller.submitRequest(context);
                        },
                        isLoading: controller.isLoading.value,
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
                if (controller.isLoading.value) Apploader(),
              ],
            );
          }),
        ).noKeyboard(),
      );
    }
  }
