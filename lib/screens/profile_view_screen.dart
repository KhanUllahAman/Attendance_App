// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:orioattendanceapp/Utils/Layout/layout.dart';
// import '../Controllers/profile_view_controller.dart';
// import '../Utils/AppWidget/App_widget.dart';
// import '../Utils/Colors/color_resoursec.dart';
// import '../models/profile_screen_model.dart';

// class ProfileViewScreen extends StatelessWidget {
//   static const String routeName = '/profileViewScreen';
//   final controller = Get.put(ProfileViewController());
//   final _formKey = GlobalKey<FormState>();

//   ProfileViewScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);

//     return AnnotatedRegion(
//       value: ColorResources.getSystemUiOverlayAllPages(false),
//       child: Layout(
//         currentTab: 3,
//         showAppBar: true,
//         showBackButton: true,
//         showLogo: true,
//         body: FocusScope(
//           // Wrap in FocusScope to manage focus
//           child: Stack(
//             children: [
//               SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: EdgeInsets.only(
//                   left: mq.size.width * 0.04,
//                   right: mq.size.width * 0.04,
//                   top: mq.size.height * 0.02,
//                   bottom: MediaQuery.of(context).viewInsets.bottom + mq.size.height * 0.02,
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Profile Picture
//                       Center(
//                         child: Container(
//                           padding: const EdgeInsets.all(7),
//                           decoration:  BoxDecoration(
//                             gradient: ColorResources.appBarGradient,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Obx(() {
//                             return CircleAvatar(
//                               radius: mq.size.width * 0.16,
//                               backgroundImage: controller.employeeProfile.value?.profilePicture != null &&
//                                       controller.employeeProfile.value!.profilePicture != 'default.png'
//                                   ? NetworkImage(controller.employeeProfile.value!.profilePicture!)
//                                   : const AssetImage('assets/images/profile.png') as ImageProvider,
//                               backgroundColor: ColorResources.whiteColor,
//                             );
//                           }),
//                         ),
//                       ),
//                       SizedBox(height: mq.size.height * 0.03),

//                       // Single Rounded Container for All Fields
//                       Obx(() {
//                         if (controller.employeeProfile.value == null) {
//                           return const SizedBox.shrink();
//                         }
//                         return Container(
//                           padding: EdgeInsets.all(mq.size.width * 0.04),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.05),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.white10),
//                           ),
//                           child: _buildProfileInfoSection(
//                             controller.employeeProfile.value!,
//                             mq,
//                             context,
//                           ),
//                         );
//                       }),

//                       SizedBox(height: mq.size.height * 0.03),

//                       // Update Button
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               final updatedData = {
//                                 "fullname": controller.fullNameController.text,
//                                 "fathername": controller.fatherNameController.text,
//                                 "dob": controller.dobController.text,
//                                 "email": controller.emailController.text,
//                                 "phone": controller.phoneController.text,
//                                 "cnic": controller.cnicController.text,
//                                 "address": controller.addressController.text,
//                               };
//                               controller.updateEmployeeProfile(updatedData);
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorResources.appMainColor,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: mq.size.width * 0.1,
//                               vertical: mq.size.height * 0.02,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: Text(
//                             'Update Profile',
//                             style: GoogleFonts.sora(
//                               color: Colors.white,
//                               fontSize: mq.size.width * 0.04,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: mq.size.height * 0.03),
//                     ],
//                   ),
//                 ),
//               ),
//               // Separate Obx for loading indicator
//               Obx(() => controller.isLoading.value ? const Apploader() : const SizedBox.shrink()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileInfoSection(
//       EmployeeProfile profile, MediaQueryData mq, BuildContext context) {
//     // Do not initialize controllers with profile data to keep fields empty
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Personal Information
//         _buildSectionHeader("Personal Information", mq),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Full Name',
//                 style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
//               ),
//               SizedBox(height: 4),
//               CustomTextFeild(
//                 controller: controller.fullNameController,
//                 mediaQuery: mq,
//                 hintText: 'Enter Full Name',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter full name';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Father Name',
//                 style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
//               ),
//               SizedBox(height: 4),
//               CustomTextFeild(
//                 controller: controller.fatherNameController,
//                 mediaQuery: mq,
//                 hintText: 'Enter Father Name',
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Date of Birth',
//                 style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
//               ),
//               SizedBox(height: 4),
//               CustomTextFeild(
//                 controller: controller.dobController,
//                 mediaQuery: mq,
//                 hintText: 'Select Date of Birth',
//                 readOnly: true,
//                 onTap: () => _selectDate(context, controller.dobController),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 12),

//         // Contact Information
//         _buildSectionHeader("Contact Information", mq),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Email',
//                 style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
//               ),
//               SizedBox(height: 4),
//               CustomTextFeild(
//                 controller: controller.emailController,
//                 mediaQuery: mq,
//                 hintText: 'Enter Email',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Phone',
//                 style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
//               ),
//               SizedBox(height: 4),
//               CustomTextFeild(
//                 controller: controller.phoneController,
//                 mediaQuery: mq,
//                 hintText: 'Enter Phone Number',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   return null;
//                 },
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(11),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'CNIC',
//                 style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
//               ),
//               SizedBox(height: 4),
//               CustomTextFeild(
//                 controller: controller.cnicController,
//                 mediaQuery: mq,
//                 hintText: 'Enter CNIC',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter CNIC';
//                   }
//                   if (value.length != 13) {
//                     return 'CNIC must be 13 digits';
//                   }
//                   return null;
//                 },
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(13),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Address',
//                 style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
//               ),
//               SizedBox(height: 4),
//               CustomTextFeild(
//                 controller: controller.addressController,
//                 mediaQuery: mq,
//                 hintText: 'Enter Address',
//                 maxLines: 3,
//                 keyboardType: TextInputType.multiline,
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 24),

//         // Organization Info (read-only)
//         _buildSectionHeader("Organization Info", mq),
//         _buildInfoField('Employee Code', profile.employeeCode),
//         _buildInfoField('Department', profile.departmentName ?? '--'),
//         _buildInfoField('Designation', profile.designationTitle ?? '--'),
//         _buildInfoField('Shift', profile.shiftName ?? '--'),
//         _buildInfoField('Shift Time', profile.formattedShiftTime),
//         _buildInfoField('Join Date', profile.formattedJoinDate),
//         _buildInfoField('Teams', profile.teamNames ?? '--'),
//         _buildInfoField('Team Leads', profile.teamLeads ?? '--'),
//         SizedBox(height: mq.size.height * 0.035),
//       ],
//     );
//   }

//   Widget _buildInfoField(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.sora(color: Colors.white60, fontSize: 14),
//           ),
//           SizedBox(height: 4),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               value,
//               style: GoogleFonts.sora(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, MediaQueryData mq) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: mq.size.height * 0.015),
//       child: Text(
//         title,
//         style: GoogleFonts.sora(
//           color: ColorResources.whiteColor,
//           fontSize: mq.size.width * 0.042,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(
//       BuildContext context, TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       controller.text = DateFormat('yyyy-MM-dd').format(picked);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
        currentTab: 3,
        showAppBar: true,
        showBackButton: true,
        showLogo: true,
        body: Obx(() {
          if (controller.connectionType.value == 0) {
            return buildFullScreenOfflineUI(mq);
          }
          return Stack(
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
                  // Check if the profile is loading
                  if (controller.isLoading.value) {
                    return const Apploader();
                  }
                  // Check if employeeProfile is null
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
                            onPressed: () => controller.fetchEmployeeProfile(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Picture
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              gradient: ColorResources.appBarGradient,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: mq.size.width * 0.16,
                              backgroundImage: AssetImage(
                                "assets/images/profile.png",
                              ),
                              backgroundColor: ColorResources.whiteColor,
                              onBackgroundImageError: (_, __) =>
                                  const AssetImage('assets/images/profile.png'),
                            ),
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
                                color: Colors.black.withOpacity(
                                  0.1,
                                ), // Soft black shadow
                                blurRadius: 10, // How soft the shadow should be
                                spreadRadius: 2, // Slightly expands the shadow
                                offset: const Offset(
                                  0,
                                  4,
                                ), // Shadow position (x, y)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      controller: controller.fullNameController,
                                      mediaQuery: mq,
                                      hintText: 'Enter Full Name',
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date of Birth',
                                      style: GoogleFonts.sora(
                                        color: ColorResources
                                            .blackColor, // Changed from white60 to match other labels
                                        fontSize:
                                            mq.size.width *
                                            0.038, // Consistent with other fields
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () =>
                                          controller.showDatePicker(context),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              mq.size.width *
                                              0.04, // Match CustomTextFeild
                                          vertical:
                                              mq.size.height *
                                              0.015, // Match CustomTextFeild
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorResources.blackColor
                                              .withOpacity(
                                                0.05,
                                              ), // Match CustomTextFeild
                                          borderRadius: BorderRadius.circular(
                                            mq.size.width * 0.03,
                                          ), // Match CustomTextFeild
                                          border: Border.all(
                                            color: Colors.white10,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          controller.dobController.text.isEmpty
                                              ? 'Select Date of Birth'
                                              : controller.dobController.text,
                                          style: GoogleFonts.sora(
                                            color:
                                                controller
                                                    .dobController
                                                    .text
                                                    .isEmpty
                                                ? Colors
                                                      .black38 // Match hint text color
                                                : Colors
                                                      .black54, // Match normal text color
                                            fontSize:
                                                mq.size.width *
                                                0.038, // Match CustomTextFeild
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(11),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        FilteringTextInputFormatter.digitsOnly,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      controller: controller.addressController,
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
                                controller.employeeProfile.value!.employeeCode,
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
                        AppButton(
                          mediaQuery: mq,
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            controller.updateEmployeeProfile({
                              'full_name': controller.fullNameController.text,
                              'father_name':
                                  controller.fatherNameController.text,
                              'dob': controller.dobController.text,
                              'email': controller.emailController.text,
                              'phone': controller.phoneController.text,
                              'cnic': controller.cnicController.text,
                              'address': controller.addressController.text,
                            });
                          },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: ColorResources.appMainColor,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  'Update Profile',
                                  style: GoogleFonts.sora(
                                    color: ColorResources.whiteColor,
                                    fontSize: mq.size.width * 0.04,
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
          );
        }),
      ),
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
              fontSize: mq.size.width * 0.038, // Match CustomTextFeild style
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
              color: ColorResources.blackColor.withOpacity(
                0.05,
              ), // Match CustomTextFeild
              borderRadius: BorderRadius.circular(mq.size.width * 0.03),
            ),
            child: Text(
              value,
              style: GoogleFonts.sora(
                color: Colors.black54, // Match CustomTextFeild text color
                fontSize:
                    mq.size.width * 0.038, // Match CustomTextFeild font size
              ),
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
}
