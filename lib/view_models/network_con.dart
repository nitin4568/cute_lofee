import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkController extends GetxController {
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnection();

    Connectivity().onConnectivityChanged.listen((result) {
      isConnected.value = result != ConnectivityResult.none;
    });
  }

  void checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    isConnected.value = result != ConnectivityResult.none;
  }
}