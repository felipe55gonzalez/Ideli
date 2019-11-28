import 'dart:io';

import 'package:connectivity/connectivity.dart';

final Connectivity _connectivity = Connectivity();

String wifiName, wifiBSSID, wifiIP;
Future<bool> checkConexion() async {
  ConnectivityResult result;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    result = await _connectivity.checkConnectivity();
  } on Error catch (e) {
    print(e.toString());
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
  switch (result) {
    case ConnectivityResult.wifi:
      try {
        if (Platform.isIOS) {
          LocationAuthorizationStatus status =
              await _connectivity.getLocationServiceAuthorization();
          if (status == LocationAuthorizationStatus.notDetermined) {
            status = await _connectivity.requestLocationServiceAuthorization();
          }
          if (status == LocationAuthorizationStatus.authorizedAlways ||
              status == LocationAuthorizationStatus.authorizedWhenInUse) {
            wifiName = await _connectivity.getWifiName();
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } else {
          wifiName = await _connectivity.getWifiName();
        }
      } on Error catch (e) {
        print(e.toString());
        wifiName = "Failed to get Wifi Name";
      }

      try {
        if (Platform.isIOS) {
          LocationAuthorizationStatus status =
              await _connectivity.getLocationServiceAuthorization();
          if (status == LocationAuthorizationStatus.notDetermined) {
            status = await _connectivity.requestLocationServiceAuthorization();
          }
          if (status == LocationAuthorizationStatus.authorizedAlways ||
              status == LocationAuthorizationStatus.authorizedWhenInUse) {
            wifiBSSID = await _connectivity.getWifiBSSID();
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } else {
          wifiBSSID = await _connectivity.getWifiBSSID();
        }
      } on Error catch (e) {
        print(e.toString());
        wifiBSSID = "Failed to get Wifi BSSID";
      }

      try {
        wifiIP = await _connectivity.getWifiIP();
      } on Error catch (e) {
        print(e.toString());
        wifiIP = "Failed to get Wifi IP";
      }
      print("wifi");
      return true;

      break;
    case ConnectivityResult.mobile:
    print("red movil");
      return true;
      break;
    case ConnectivityResult.none:
    print("sin conexiones");
      return false;

      break;
    default:
    print("default");
      return false;

      break;
  }
}
