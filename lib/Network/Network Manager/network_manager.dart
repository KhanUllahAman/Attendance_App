import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NetworkManager extends GetxController {
  int connectionType = 0;
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
      connectionType = 0; 
      update();
    }
  }

  void _updateState(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      connectionType = 1;
    } else if (results.contains(ConnectivityResult.mobile)) {
      connectionType = 2;
    } else if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      connectionType = 0;
    } else {
      connectionType = 3;
    }
    update();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    super.onClose();
  }
}
