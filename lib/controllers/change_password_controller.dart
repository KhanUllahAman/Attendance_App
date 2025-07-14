import 'package:flutter/widgets.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';

class ChangePasswordController extends NetworkManager {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
}
