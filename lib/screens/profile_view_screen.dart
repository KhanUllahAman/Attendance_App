import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orioattendanceapp/Utils/Layout/layout.dart';
import '../Controllers/profile_view_controller.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';

class ProfileViewScreen extends StatefulWidget {
  static const String routeName = '/profileViewScreen';
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  final controller = Get.put(ProfileViewController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AnnotatedRegion(
      value: ColorResources.getSystemUiOverlayAllPages(),
      child: Layout(
        title: "Profile",
        currentTab: 3,
        showAppBar: true,
        showBackButton: true,
        showLogo: true,
        body: Obx(() {
          if (controller.connectionType.value == 0) {
            return buildFullScreenOfflineUI(mq);
          }
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchEmployeeProfile();
            },
            color: ColorResources.appMainColor,
            backgroundColor: Colors.white,
            elevation: 0.0,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: mq.size.width * 0.04,
                    right: mq.size.width * 0.04,
                    top: mq.size.height * 0.02,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom +
                        mq.size.height * 0.02,
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Apploader();
                    }
                    if (controller.employeeProfile.value == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Failed to load profile data'),
                            SizedBox(height: mq.size.height * 0.02),
                            AppButton(
                              mediaQuery: mq,
                              isLoading: false,
                              onPressed: () =>
                                  controller.fetchEmployeeProfile(),
                              child: Text(
                                'Retry',
                                style: GoogleFonts.sora(
                                  color: ColorResources.blackColor,
                                  fontSize: mq.size.width * 0.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    gradient: ColorResources.appBarGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Obx(
                                    () => Container(
                                      width: mq.size.width * 0.32,
                                      height: mq.size.width * 0.32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image:
                                              controller.selectedImage.value !=
                                                  null
                                              ? FileImage(
                                                  File(
                                                    controller
                                                        .selectedImage
                                                        .value!
                                                        .path,
                                                  ),
                                                )
                                              : NetworkImage(
                                                      "http://162.211.84.202:3001/uploads/users/${controller.employeeProfile.value!.profilePicture ?? 'default.png'}",
                                                    )
                                                    as ImageProvider,
                                          fit: BoxFit.fill,
                                          onError: (exception, stackTrace) =>
                                              const AssetImage(
                                                'assets/images/profile.png',
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _showImagePickerBottomSheet(context),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        mq.size.width * 0.02,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorResources.appMainColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: ColorResources.whiteColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Iconsax.camera,
                                        size: mq.size.width * 0.05,
                                        color: ColorResources.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: mq.size.height * 0.03),
                          Container(
                            padding: EdgeInsets.all(mq.size.width * 0.04),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 248, 248),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader("Personal Information", mq),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Full Name',
                                        style: GoogleFonts.sora(
                                          color: ColorResources.blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      CustomTextFeild(
                                        controller:
                                            controller.fullNameController,
                                        mediaQuery: mq,
                                        hintText: 'Enter Full Name',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Father Name',
                                        style: GoogleFonts.sora(
                                          color: ColorResources.blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      CustomTextFeild(
                                        controller:
                                            controller.fatherNameController,
                                        mediaQuery: mq,
                                        hintText: 'Enter Father Name',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date of Birth',
                                        style: GoogleFonts.sora(
                                          color: ColorResources.blackColor,
                                          fontSize: mq.size.width * 0.038,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () =>
                                            controller.showDatePicker(context),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: mq.size.width * 0.04,
                                            vertical: mq.size.height * 0.015,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ColorResources.blackColor
                                                .withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(
                                              mq.size.width * 0.03,
                                            ),
                                            border: Border.all(
                                              color: Colors.white10,
                                              width: 1,
                                            ),
                                          ),
                                          child: Obx(
                                            () => Text(
                                              controller.dob.value.isEmpty
                                                  ? 'Select Date of Birth'
                                                  : controller.dob.value,
                                              style: GoogleFonts.sora(
                                                color:
                                                    controller.dob.value.isEmpty
                                                    ? Colors.black38
                                                    : Colors.black54,
                                                fontSize: mq.size.width * 0.038,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                _buildSectionHeader("Contact Information", mq),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email',
                                        style: GoogleFonts.sora(
                                          color: ColorResources.blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      CustomTextFeild(
                                        controller: controller.emailController,
                                        mediaQuery: mq,
                                        hintText: 'Enter Email',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Phone',
                                        style: GoogleFonts.sora(
                                          color: ColorResources.blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      CustomTextFeild(
                                        controller: controller.phoneController,
                                        mediaQuery: mq,
                                        hintText: 'Enter Phone Number',
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(11),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CNIC',
                                        style: GoogleFonts.sora(
                                          color: ColorResources.blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      CustomTextFeild(
                                        controller: controller.cnicController,
                                        mediaQuery: mq,
                                        hintText: '12345-1234567-1',
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(15),
                                          CnicInputFormatter(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address',
                                        style: GoogleFonts.sora(
                                          color: ColorResources.blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      CustomTextFeild(
                                        controller:
                                            controller.addressController,
                                        mediaQuery: mq,
                                        hintText: 'Enter Address',
                                        maxLines: 3,
                                        keyboardType: TextInputType.multiline,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24),
                                _buildSectionHeader("Organization Info", mq),
                                _buildInfoField(
                                  'Employee Code',
                                  controller
                                      .employeeProfile
                                      .value!
                                      .employeeCode,
                                  mq,
                                ),
                                _buildInfoField(
                                  'Department',
                                  controller
                                          .employeeProfile
                                          .value!
                                          .departmentName ??
                                      '--',
                                  mq,
                                ),
                                _buildInfoField(
                                  'Designation',
                                  controller
                                          .employeeProfile
                                          .value!
                                          .designationTitle ??
                                      '--',
                                  mq,
                                ),
                                _buildInfoField(
                                  'Shift',
                                  controller.employeeProfile.value!.shiftName ??
                                      '--',
                                  mq,
                                ),
                                _buildInfoField(
                                  'Shift Time',
                                  controller
                                      .employeeProfile
                                      .value!
                                      .formattedShiftTime,
                                  mq,
                                ),
                                _buildInfoField(
                                  'Join Date',
                                  controller
                                      .employeeProfile
                                      .value!
                                      .formattedJoinDate,
                                  mq,
                                ),
                                _buildInfoField(
                                  'Teams',
                                  controller.employeeProfile.value!.teamNames ??
                                      '--',
                                  mq,
                                ),
                                _buildInfoField(
                                  'Team Leads',
                                  controller.employeeProfile.value!.teamLeads ??
                                      '--',
                                  mq,
                                ),
                                SizedBox(height: mq.size.height * 0.035),
                              ],
                            ),
                          ),
                          SizedBox(height: mq.size.height * 0.03),
                          Obx(
                            () => AppButton(
                              mediaQuery: mq,
                              isLoading: controller.isLoading.value,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  final updatedData = {
                                    "employee_id": controller
                                        .employeeProfile
                                        .value!
                                        .employeeId,
                                    "fullname":
                                        controller.fullNameController.text,
                                    "father_name":
                                        controller.fatherNameController.text,
                                    "dob": controller.dobController.text,
                                    "email": controller.emailController.text,
                                    "phone": controller.phoneController.text,
                                    "cnic": controller.cnicController.text,
                                    "address":
                                        controller.addressController.text,
                                    "profile_picture":
                                        controller.selectedImageBase64.value,
                                  };
                                  controller.updateEmployeeProfile(updatedData);
                                }
                              },
                              child: Text(
                                'Update Profile',
                                style: GoogleFonts.sora(
                                  color: ColorResources.whiteColor,
                                  fontSize: mq.size.width * 0.04,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: mq.size.height * 0.03),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ).noKeyboard(),
    );
  }

  Widget _buildInfoField(String label, String value, MediaQueryData mq) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.sora(
              color: ColorResources.blackColor,
              fontSize: mq.size.width * 0.038,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: mq.size.width * 0.04,
              vertical: mq.size.height * 0.015,
            ),
            decoration: BoxDecoration(
              color: ColorResources.blackColor.withOpacity(0.02),
              borderRadius: BorderRadius.circular(mq.size.width * 0.03),
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.sora(
                      color: Colors.black54,
                      fontSize: mq.size.width * 0.038,
                    ),
                  ),
                ),
                Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: Colors.grey.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, MediaQueryData mq) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.size.height * 0.015),
      child: Text(
        title,
        style: GoogleFonts.sora(
          color: ColorResources.blackColor,
          fontSize: mq.size.width * 0.042,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: ColorResources.backgroundWhiteColor,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Iconsax.gallery),
                title: Text('Choose from Gallery'),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Iconsax.camera),
                title: Text('Take a Photo'),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
