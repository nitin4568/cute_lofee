import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {

  static Future<bool> isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      /// 🔥 REAL INTERNET CHECK
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}