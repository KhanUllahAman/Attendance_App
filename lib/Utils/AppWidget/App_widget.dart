import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Controllers/notification_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../Controllers/dropdown_controller.dart';
import '../../Network/Network Manager/network_manager.dart';
import '../Colors/color_resoursec.dart';
import '../Snack Bar/custom_snack_bar.dart';

extension AppWidgetExtension on Widget {
  Widget noKeyboard() => GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
    child: this,
  );
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
    Get.put(NetworkManager());
  }
}

class CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';
    if (digits.length <= 5) {
      formatted = digits;
    } else if (digits.length <= 12) {
      formatted = '${digits.substring(0, 5)}-${digits.substring(5)}';
    } else if (digits.length <= 13) {
      formatted =
          '${digits.substring(0, 5)}-${digits.substring(5, 12)}-${digits.substring(12)}';
    } else {
      formatted =
          '${digits.substring(0, 5)}-${digits.substring(5, 12)}-${digits.substring(12, 13)}';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CustomTextFeild extends StatefulWidget {
  const CustomTextFeild({
    super.key,
    this.controller,
    required this.mediaQuery,
    this.hintText,
    this.validator,
    this.isPassword = false,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.onTap,
  });

  final TextEditingController? controller;
  final MediaQueryData mediaQuery;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final VoidCallback? onTap;

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final mq = widget.mediaQuery;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      style: GoogleFonts.sora(
        color: Colors.black54,
        fontSize: mq.size.width * 0.038,
      ),
      cursorColor: widget.readOnly
          ? Colors.transparent
          : ColorResources.appMainColor,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: mq.size.width * 0.04,
          vertical: mq.size.height * 0.015,
        ),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.sora(
          color: Colors.black38,
          fontSize: mq.size.width * 0.030,
        ),
        filled: true,
        fillColor: widget.readOnly
            ? ColorResources.blackColor.withOpacity(0.025)
            : ColorResources.blackColor.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mq.size.width * 0.03),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mq.size.width * 0.03),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: widget.readOnly
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq.size.width * 0.03),
                borderSide: const BorderSide(color: Colors.transparent),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq.size.width * 0.03),
                borderSide: BorderSide(
                  color: ColorResources.appMainColor,
                  width: 2,
                ),
              ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mq.size.width * 0.03),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mq.size.width * 0.03),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: GoogleFonts.sora(
          color: Colors.red,
          fontSize: mq.size.width * 0.030,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Iconsax.eye_slash : Iconsax.eye,
                  color: ColorResources.blackColor,
                  size: mq.size.width * 0.055,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}

class SearchableDropdown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final Function(String) onChange;
  final Color fillColor;
  final Color hintColor;
  final Color textColor;
  final DropdownController dropdownController;
  final bool isEnabled;
  final String? topText;

  const SearchableDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChange,
    required this.fillColor,
    required this.hintColor,
    required this.textColor,
    required this.dropdownController,
    this.isEnabled = true,
    this.topText,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: GestureDetector(
        onTap: () => _openSearchBottomSheet(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() {
                      final selectedItem =
                          dropdownController.selectedItem.value;
                      return Text(
                        selectedItem.isEmpty ? hintText : selectedItem,
                        style: GoogleFonts.sora(
                          color: selectedItem.isEmpty ? hintColor : textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    }),
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined, color: textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSearchBottomSheet(BuildContext context) {
    Get.bottomSheet(
      SearchBottomSheet(
        items: items,
        onSelect: (selectedItem) {
          dropdownController.selectItem(selectedItem);
          onChange(selectedItem);
          Get.back();
        },
        topText: topText ?? "Select an item",
        selectedValue: dropdownController.selectedItem.value,
      ),
      isScrollControlled: true,
      backgroundColor: ColorResources.backgroundWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}

class SearchBottomSheet extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelect;
  final String topText;
  final String? selectedValue;

  const SearchBottomSheet({
    super.key,
    required this.items,
    required this.onSelect,
    required this.topText,
    this.selectedValue,
  });

  @override
  _SearchBottomSheetState createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  String query = '';
  List<String> filteredItems = [];
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    selectedItem = widget.selectedValue;
  }

  void _filterItems(String input) {
    setState(() {
      query = input;
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: ColorResources.backgroundWhiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    widget.topText,
                    style: GoogleFonts.sora(
                      fontWeight: FontWeight.bold,
                      color: ColorResources.blackColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Iconsax.close_circle,
                  color: ColorResources.appMainColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: _filterItems,
            style: GoogleFonts.sora(
              color: ColorResources.blackColor,
              fontSize: mq.size.width * 0.038, // 👈 responsive font
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: mq.size.width * 0.04,
                vertical: mq.size.height * 0.015,
              ),
              hintText: "Search",
              hintStyle: GoogleFonts.sora(
                color: Colors.black38,
                fontSize: mq.size.width * 0.030, // 👈 responsive font
              ),
              filled: true,
              fillColor: ColorResources.blackColor.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq.size.width * 0.03),
                borderSide: const BorderSide(color: Colors.white10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq.size.width * 0.03),
                borderSide: const BorderSide(color: Colors.white10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq.size.width * 0.03),
                borderSide: BorderSide(color: ColorResources.appMainColor),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black38,
                size: mq.size.width * 0.055, // 👈 responsive icon size
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredItems.isNotEmpty
                ? ListView.separated(
                    itemCount: filteredItems.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = item == selectedItem;
                      return ListTile(
                        title: Text(
                          item,
                          style: GoogleFonts.sora(
                            fontSize: 15,
                            color: ColorResources.blackColor,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          setState(() => selectedItem = item);
                          widget.onSelect(item);
                        },
                      );
                    },
                  )
                : Center(
                    child: Text("No items found", style: GoogleFonts.sora()),
                  ),
          ),
        ],
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.mediaQuery,
    required this.onPressed,
    required this.child,
    required this.isLoading,
    this.backgroundColor = ColorResources.appMainColor,
  });

  final MediaQueryData mediaQuery;
  final VoidCallback onPressed;
  final Widget child;
  final bool isLoading;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: mediaQuery.size.height * 0.06,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => isLoading
                ? ColorResources.blackColor.withOpacity(0.05)
                : backgroundColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide.none,
            ),
          ),
          elevation: MaterialStateProperty.all(0),
          shadowColor: MaterialStateProperty.all(
            Colors.transparent,
          ), // Ensures no shadow
        ),
        child: child,
      ),
    );
  }
}

class Apploader extends StatelessWidget {
  const Apploader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: ColorResources.appMainColor,
        strokeWidth: 3.0,
        strokeCap: StrokeCap.square,
      ),
    );
  }
}

class RetryWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final String retryButtonText;
  final Color? buttonColor;
  final Color? textColor;

  const RetryWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.retryButtonText = 'Retry',
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
            const SizedBox(height: 20),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: textColor ?? Colors.black),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                retryButtonText,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDateRangePicker extends StatefulWidget {
  final Function(DateTime?, DateTime?) onDateRangeSelected;
  final bool allowFutureDates; // New parameter to control future dates
  final bool allowPastDates; // New parameter to control past dates
  final DateTime? firstDate; // Optional custom first date
  final DateTime? lastDate; // Optional custom last date

  const CustomDateRangePicker({
    super.key,
    required this.onDateRangeSelected,
    this.allowFutureDates = false,
    this.allowPastDates = true,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  List<DateTime?> selectedDateRange = [null, null];

  String formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Calculate the date range constraints
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime firstDate =
        widget.firstDate ?? (widget.allowPastDates ? DateTime(1900) : today);
    DateTime lastDate =
        widget.lastDate ?? (widget.allowFutureDates ? DateTime(2100) : today);

    // Ensure firstDate is not after lastDate
    if (firstDate.isAfter(lastDate)) {
      firstDate = lastDate;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      decoration: const BoxDecoration(
        color: ColorResources.backgroundWhiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Title
            Text(
              'Select Date Range',
              style: GoogleFonts.sora(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.w600,
                color: ColorResources.blackColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Buttons moved to the top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton(
                    backgroundColor: ColorResources.containerColor,
                    onPressed: () => Navigator.pop(context),
                    mediaQuery: mediaQuery,
                    isLoading: false,
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.sora(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: AppButton(
                    mediaQuery: mediaQuery,
                    onPressed: () {
                      if (selectedDateRange.length == 2 &&
                          selectedDateRange[0] != null &&
                          selectedDateRange[1] != null) {
                        widget.onDateRangeSelected(
                          selectedDateRange[0],
                          selectedDateRange[1],
                        );
                        Navigator.pop(context);
                      } else {
                        customSnackBar(
                          "Error",
                          "Please select a valid date range",
                          snackBarType: SnackBarType.error,
                        );
                      }
                    },
                    isLoading: false,
                    child: Text(
                      'Apply',
                      style: GoogleFonts.sora(
                        color: ColorResources.whiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: screenHeight * 0.015,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // Calendar
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
                selectedDayHighlightColor: ColorResources.appMainColor,
                selectedRangeHighlightColor: ColorResources.appMainColor
                    .withOpacity(0.3),
                selectedDayTextStyle: TextStyle(
                  color: ColorResources.whiteColor,
                  fontSize: screenWidth * 0.032,
                ),
                todayTextStyle: TextStyle(
                  color: ColorResources.appMainColor,
                  fontSize: screenWidth * 0.032,
                ),
                weekdayLabelTextStyle: TextStyle(
                  color: ColorResources.blackColor,
                  fontSize: screenWidth * 0.032,
                ),
                dayTextStyle: TextStyle(
                  color: ColorResources.blackColor,
                  fontSize: screenWidth * 0.032,
                ),
                controlsTextStyle: TextStyle(
                  color: ColorResources.appMainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.025,
                ),
                disableModePicker: true,
                lastMonthIcon: const Icon(
                  Icons.chevron_left,
                  size: 15,
                  color: ColorResources.blackColor,
                ),
                nextMonthIcon: const Icon(
                  Icons.chevron_right,
                  size: 15,
                  color: ColorResources.blackColor,
                ),
                firstDate: firstDate,
                lastDate: lastDate,
                disabledDayTextStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: screenWidth * 0.032,
                ),
              ),
              value: selectedDateRange,
              onValueChanged: (values) {
                setState(() {
                  selectedDateRange = [
                    if (values.isNotEmpty) values[0] else null,
                    if (values.length > 1) values[1] else null,
                  ];
                });
              },
            ),

            // Selected date range text
            if (selectedDateRange.length == 2 &&
                selectedDateRange[0] != null &&
                selectedDateRange[1] != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: Text(
                  "Selected: ${formatDate(selectedDateRange[0]!)} - ${formatDate(selectedDateRange[1]!)}",
                  style: GoogleFonts.sora(
                    fontSize: screenWidth * 0.032,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.blackColor,
                  ),
                ),
              ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}

class CustomDatePicker extends StatelessWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool allowFutureDates;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.allowFutureDates = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime effectiveFirstDate = firstDate ?? DateTime(1900);

    DateTime effectiveLastDate =
        lastDate ?? (allowFutureDates ? DateTime(2100) : today);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      decoration: const BoxDecoration(
        color: ColorResources.backgroundWhiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Date',
              style: GoogleFonts.sora(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.w600,
                color: ColorResources.blackColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton(
                    backgroundColor: ColorResources.containerColor,
                    onPressed: () => Navigator.pop(context),
                    mediaQuery: mediaQuery,
                    isLoading: false,
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.sora(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: AppButton(
                    mediaQuery: mediaQuery,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isLoading: false,
                    child: Text(
                      'OK',
                      style: GoogleFonts.sora(
                        color: ColorResources.whiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: screenHeight * 0.015,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // Calendar
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.single,
                selectedDayHighlightColor: ColorResources.appMainColor,
                selectedDayTextStyle: TextStyle(
                  color: ColorResources.whiteColor,
                  fontSize: screenWidth * 0.032,
                ),
                todayTextStyle: TextStyle(
                  color: ColorResources.appMainColor,
                  fontSize: screenWidth * 0.032,
                ),
                weekdayLabelTextStyle: TextStyle(
                  color: ColorResources.blackColor,
                  fontSize: screenWidth * 0.032,
                ),
                dayTextStyle: TextStyle(
                  color: ColorResources.blackColor,
                  fontSize: screenWidth * 0.032,
                ),
                controlsTextStyle: TextStyle(
                  color: ColorResources.appMainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.025,
                ),
                disableModePicker: true,
                lastMonthIcon: const Icon(
                  Icons.chevron_left,
                  size: 15,
                  color: ColorResources.blackColor,
                ),
                nextMonthIcon: const Icon(
                  Icons.chevron_right,
                  size: 15,
                  color: ColorResources.blackColor,
                ),
                firstDate: effectiveFirstDate,
                lastDate: effectiveLastDate,
                disabledDayTextStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: screenWidth * 0.032,
                ),
              ),
              value: initialDate != null ? [initialDate] : [],
              onValueChanged: (dates) {
                if (dates.isNotEmpty && dates[0] != null) {
                  // Additional check to prevent future dates if needed
                  if (!allowFutureDates && dates[0]!.isAfter(today)) {
                    customSnackBar(
                      "Error",
                      "Future dates are not allowed",
                      snackBarType: SnackBarType.error,
                    );
                    return;
                  }
                  onDateSelected(dates[0]!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

String formatDateRange(DateTime? start, DateTime? end) {
  if (start == null || end == null) return 'Select Date Range';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return '${formatter.format(start)} - ${formatter.format(end)}';
}

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onChanged;

  const CustomSearchField({
    super.key,
    required this.controller,
    this.hintText = "Search...",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.sora(
        color: ColorResources.blackColor,
        fontSize: mq.size.width * 0.038, // 👈 responsive font
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: mq.size.width * 0.04,
          vertical: mq.size.height * 0.015,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.sora(
          color: Colors.black38,
          fontSize: mq.size.width * 0.030, // 👈 responsive font
        ),
        filled: true,
        fillColor: ColorResources.blackColor.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mq.size.width * 0.03),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mq.size.width * 0.03),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mq.size.width * 0.03),
          borderSide: BorderSide(color: ColorResources.appMainColor),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black38,
          size: mq.size.width * 0.055, // 👈 responsive icon size
        ),
      ),
    );
  }
}

class CustomTimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? selectedTime;
  final VoidCallback onTap;

  const CustomTimePickerField({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onTap,
  });

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mq.size.width * 0.04,
          vertical: mq.size.height * 0.02,
        ),
        decoration: BoxDecoration(
          color: ColorResources.blackColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Colors.black38),
            SizedBox(width: mq.size.width * 0.04),
            Expanded(
              child: Text(
                "$label: ${_formatTime(selectedTime)}",
                style: GoogleFonts.sora(
                  color: Colors.black54,
                  fontSize: mq.size.width * 0.030,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerHomeScreen extends StatelessWidget {
  final MediaQueryData mediaQuery;

  const ShimmerHomeScreen({required this.mediaQuery, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.size.height * 0.45,
      color: ColorResources.backgroundWhiteColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -(mediaQuery.size.height * 0.14 / 2),
            left: mediaQuery.size.width * 0.05,
            right: mediaQuery.size.width * 0.05,
            child: Container(
              height: mediaQuery.size.height * 0.50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 248, 248),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Soft black shadow
                    blurRadius: 10, // How soft the shadow should be
                    spreadRadius: 2, // Slightly expands the shadow
                    offset: const Offset(0, 4), // Shadow position (x, y)
                  ),
                ],
              ),
              padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Time placeholder
                  SizedBox(height: mediaQuery.size.height * 0.01),
                  // Date placeholder
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                      width: mediaQuery.size.width * 0.5,
                      height: mediaQuery.size.width * 0.035,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  // Check-in/check-out button placeholder
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                      width: mediaQuery.size.width * 0.50,
                      height: mediaQuery.size.width * 0.50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: mediaQuery.size.width * 0.17,
                            height: mediaQuery.size.width * 0.17,
                            color: Colors.grey,
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.005),
                          Container(
                            width: mediaQuery.size.width * 0.15,
                            height: mediaQuery.size.width * 0.035,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  // Location text placeholder
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[300]!,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: mediaQuery.size.width * 0.06,
                          height: mediaQuery.size.width * 0.06,
                          color: Colors.grey,
                        ),
                        SizedBox(width: mediaQuery.size.width * 0.02),
                        Container(
                          width: mediaQuery.size.width * 0.4,
                          height: mediaQuery.size.width * 0.035,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.04),
                  // Check-in/check-out times placeholders
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[300]!,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: mediaQuery.size.width * 0.07,
                              height: mediaQuery.size.width * 0.07,
                              color: Colors.grey,
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Container(
                              width: mediaQuery.size.width * 0.1,
                              height: mediaQuery.size.width * 0.030,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.005),
                            Container(
                              width: mediaQuery.size.width * 0.15,
                              height: mediaQuery.size.width * 0.030,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: mediaQuery.size.width * 0.07,
                              height: mediaQuery.size.width * 0.07,
                              color: Colors.grey,
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Container(
                              width: mediaQuery.size.width * 0.1,
                              height: mediaQuery.size.width * 0.030,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.005),
                            Container(
                              width: mediaQuery.size.width * 0.15,
                              height: mediaQuery.size.width * 0.030,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: mediaQuery.size.width * 0.07,
                              height: mediaQuery.size.width * 0.07,
                              color: Colors.red,
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Container(
                              width: mediaQuery.size.width * 0.1,
                              height: mediaQuery.size.width * 0.030,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.005),
                            Container(
                              width: mediaQuery.size.width * 0.15,
                              height: mediaQuery.size.width * 0.030,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildShimmerAttendanceBoxes(MediaQueryData mediaQuery) {
  return Wrap(
    spacing: mediaQuery.size.width * 0.04,
    runSpacing: mediaQuery.size.height * 0.02,
    children: List.generate(8, (index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!,
        child: Container(
          width: mediaQuery.size.width * 0.26,
          height: mediaQuery.size.height * 0.12,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }),
  );
}

Widget buildFullScreenOfflineUI(MediaQueryData mediaQuery) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: mediaQuery.size.width * 0.2,
          color: ColorResources.appMainColor,
        ),
        SizedBox(height: mediaQuery.size.height * 0.02),
        Text(
          'No Internet Connection',
          style: GoogleFonts.sora(
            fontSize: mediaQuery.size.width * 0.045,
            fontWeight: FontWeight.w500,
            color: ColorResources.blackColor,
          ),
        ),
      ],
    ),
  );
}
