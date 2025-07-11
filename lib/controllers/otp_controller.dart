import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../Network/Network Manager/network_manager.dart';

class OtpController extends NetworkManager {
  final RxBool isLoading = false.obs;
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final RxString username = ''.obs;
}
