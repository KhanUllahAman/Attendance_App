import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NetworkManager extends GetxController {
  final RxInt connectionType = 0.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _streamSubscription;

  @override
  void onInit() {
    getConnectionType();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);
    super.onInit();
  }

  Future<void> getConnectionType() async {
    List<ConnectivityResult> connectivityResult;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
      _updateState(connectivityResult);
    } on PlatformException catch (e) {
      log('$e');
      connectionType.value = 0; 
      update();
    }
  }

  void _updateState(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      connectionType.value = 1;
    } else if (results.contains(ConnectivityResult.mobile)) {
      connectionType.value = 2;
    } else if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      connectionType.value = 0;
    } else {
      connectionType.value = 3;
    }
    update();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    super.onClose();
  }
}
