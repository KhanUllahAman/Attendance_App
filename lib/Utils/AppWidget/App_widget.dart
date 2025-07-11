import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
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
    Get.put(NetworkManager());
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
    this.readOnly,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final MediaQueryData mediaQuery;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType:
          widget.keyboardType ??
          (widget.isPassword ? TextInputType.text : TextInputType.emailAddress),
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputFormatters, // Add this line
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: ColorResources.greyColor,
        fontSize: widget.mediaQuery.size.width * 0.03,
      ),
      cursorColor: widget.readOnly == true
          ? Colors.transparent
          : ColorResources.appMainColor,
      readOnly: widget.readOnly ?? false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.sora(
          color: ColorResources.greyColor,
          fontSize: widget.mediaQuery.size.width * 0.03,
        ),
        filled: true,
        fillColor: ColorResources.textfeildColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide(
            color: widget.readOnly == true
                ? ColorResources.appMainColor
                : ColorResources.greyColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide(
            color: widget.readOnly == true
                ? ColorResources.appMainColor
                : Colors.transparent,
          ),
        ),
        focusedBorder: widget.readOnly == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: const BorderSide(
                  color: ColorResources.appMainColor,
                  width: 3.0,
                ),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: const BorderSide(
                  color: ColorResources.appMainColor,
                  width: 3.0,
                ),
              ),
        errorStyle: GoogleFonts.sora(
          fontWeight: FontWeight.normal,
          fontSize: widget.mediaQuery.size.width * 0.03,
          color: ColorResources.appMainColor,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Iconsax.eye_slash : Iconsax.eye,
                  color: ColorResources.greyColor,
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
  final List<String> items; // Changed to List<String>
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
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: IgnorePointer(
        ignoring: !isEnabled,
        child: GestureDetector(
          onTap: isEnabled
              ? () {
                  _openSearchBottomSheet(context);
                }
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                          style: TextStyle(
                            color: selectedItem.isEmpty ? hintColor : textColor,
                            fontSize: 13,
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
      ).noKeyboard(),
      barrierColor: Colors.black.withOpacity(0.1),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}

class SearchBottomSheet extends StatefulWidget {
  final List<String> items; // Changed to List<String>
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
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: ColorResources.whiteColor,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: _filterItems,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                suffixIcon: const Icon(
                  Icons.search,
                  color: ColorResources.blackColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredItems.isNotEmpty
                ? ListView.separated(
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(thickness: 1, height: 1),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = item == selectedItem;

                      return ListTile(
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedItem = item;
                          });
                          widget.onSelect(item);
                        },
                      );
                    },
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "No items found",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: ColorResources.blackColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading
              ? ColorResources.greyColor
              : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
        ),
        child: child,
      ),
    );
  }
}

Widget buildInfoRow(String label, String value, double screenHeight) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.sora(
              fontSize: screenHeight * 0.016,
              fontWeight: FontWeight.w500,
              color: ColorResources.textBlueColor,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: GoogleFonts.sora(
              fontSize: screenHeight * 0.016,
              fontWeight: FontWeight.w400,
              color: ColorResources.textBlueColor,
            ),
            softWrap: true, // Enable text wrapping
            overflow: TextOverflow.clip, // Clip overflow if necessary
          ),
        ),
      ],
    ),
  );
}

Widget buildActionButton(
  BuildContext context, {
  required VoidCallback onEditTap,
  required VoidCallback onDeleteTap,
}) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Text(
          'Action',
          style: GoogleFonts.sora(
            fontSize: screenHeight * 0.016,
            fontWeight: FontWeight.w500,
            color: ColorResources.textBlueColor,
          ),
        ),
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onEditTap,
              child: Row(
                children: [
                  Icon(
                    Iconsax.edit,
                    size: screenHeight * 0.025,
                    color: ColorResources.appMainColor,
                  ),
                  SizedBox(width: screenHeight * 0.005),
                  Text(
                    "Edit",
                    style: GoogleFonts.sora(
                      fontSize: screenHeight * 0.016,
                      fontWeight: FontWeight.w400,
                      color: ColorResources.textBlueColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.020),
            GestureDetector(
              onTap: onDeleteTap,
              child: Row(
                children: [
                  Icon(
                    Iconsax.trash,
                    size: screenHeight * 0.025,
                    color: ColorResources.appMainColor,
                  ),
                  SizedBox(width: screenHeight * 0.005),
                  Text(
                    "Delete",
                    style: GoogleFonts.sora(
                      fontSize: screenHeight * 0.016,
                      fontWeight: FontWeight.w400,
                      color: ColorResources.textBlueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildInfoDeshRow(
  String label,
  String value,
  VoidCallback onTap,
  double screenHeight, {
  VoidCallback? onLabelTap,
  bool isShowButton = true,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: onLabelTap != null
              ? GestureDetector(
                  onTap: onLabelTap,
                  child: Text(
                    label,
                    style: GoogleFonts.sora(
                      fontSize: screenHeight * 0.016,
                      fontWeight: FontWeight.w500,
                      color: ColorResources.appMainColor,
                    ),
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.sora(
                    fontSize: screenHeight * 0.016,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.textBlueColor,
                  ),
                ),
        ),
        isShowButton == true
            ? Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: GoogleFonts.sora(
                      fontSize: screenHeight * 0.016,
                      fontWeight: FontWeight.w400,
                      color: ColorResources.appMainColor,
                      decoration: TextDecoration.underline,
                      decorationColor: ColorResources.appMainColor,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    ),
  );
}

class CustomBottomSheet {
  static void show({
    required BuildContext context,
    required String svgIconPath,
    required String title,
    required String subtitle,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryButtonTap,
    VoidCallback? onSecondaryButtonTap,
    Color? primaryButtonColor,
    Color? secondaryButtonColor,
    Color? primaryButtonTextColor,
    Color? secondaryButtonTextColor,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(svgIconPath),
              SizedBox(height: screenHeight * 0.02),
              Text(
                title,
                style: GoogleFonts.sora(
                  fontSize: screenHeight * 0.026,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.textBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                subtitle,
                style: GoogleFonts.sora(
                  fontSize: screenHeight * 0.016,
                  fontWeight: FontWeight.w400,
                  color: ColorResources.greyColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (secondaryButtonText != null)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.02),
                        child: ElevatedButton(
                          onPressed: onSecondaryButtonTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                secondaryButtonTextColor ??
                                const Color(0xFFFF0000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                          child: Text(
                            secondaryButtonText,
                            style: GoogleFonts.sora(
                              fontSize: screenHeight * 0.018,
                              fontWeight: FontWeight.w500,
                              color: ColorResources.textBlueColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (primaryButtonText != null)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: ElevatedButton(
                          onPressed: onPrimaryButtonTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                primaryButtonColor ?? const Color(0xFFFF0000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                          child: Text(
                            primaryButtonText,
                            style: GoogleFonts.sora(
                              fontSize: screenHeight * 0.018,
                              fontWeight: FontWeight.w500,
                              color: primaryButtonTextColor ?? Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        );
      },
    );
  }
}

class Apploader extends StatelessWidget {
  const Apploader({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          width: screenWidth * 0.2,
          height: screenHeight * 0.1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: CupertinoActivityIndicator(
              color: ColorResources.appMainColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDateRangePicker extends StatefulWidget {
  final Function(DateTime?, DateTime?) onDateRangeSelected;
  const CustomDateRangePicker({super.key, required this.onDateRangeSelected});

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

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
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
                color: ColorResources.textBlueColor,
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
                lastMonthIcon: const Icon(Icons.chevron_left, size: 15),
                nextMonthIcon: const Icon(Icons.chevron_right, size: 15),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
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
              Text(
                "Selected: ${formatDate(selectedDateRange[0]!)} - ${formatDate(selectedDateRange[1]!)}",
                style: GoogleFonts.sora(
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.w500,
                  color: ColorResources.textBlueColor,
                ),
              ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}

// Search Bottom Sheet Widget
class SearchBottomSheetFilter extends StatefulWidget {
  final Function(String) onSearch;
  const SearchBottomSheetFilter({super.key, required this.onSearch});

  @override
  State<SearchBottomSheetFilter> createState() =>
      _SearchBottomSheetFilterState();
}

class _SearchBottomSheetFilterState extends State<SearchBottomSheetFilter> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(screenHeight * 0.02),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Search Pickup Locations',
            style: GoogleFonts.sora(
              fontSize: screenHeight * 0.02,
              fontWeight: FontWeight.w600,
              color: ColorResources.textBlueColor,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Enter name to search',
              hintStyle: GoogleFonts.sora(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) => widget.onSearch(value),
          ),
          SizedBox(height: screenHeight * 0.02),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorResources.appMainColor,
              padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.04),
            ),
            child: Text('Close', style: GoogleFonts.sora(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

String formatDateRange(DateTime? start, DateTime? end) {
  if (start == null || end == null) return 'Select Date Range';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return '${formatter.format(start)} - ${formatter.format(end)}';
}
