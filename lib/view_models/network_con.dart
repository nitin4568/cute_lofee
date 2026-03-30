// import 'package:get/get.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// import '../resource/network.dart';
// class NetworkController extends GetxController {
//   var isConnected = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     /// 🔥 FIRST CHECK
//     checkConnection();
//
//     /// 🔥 LISTENER
//     Connectivity().onConnectivityChanged.listen((_) async {
//       isConnected.value = await NetworkUtils.isConnected();
//     });
//   }
//
//   void checkConnection() async {
//     isConnected.value = await NetworkUtils.isConnected();
//   }
// }