import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';

class InternetChecker {
  static StreamSubscription<DataConnectionStatus> mListener;

  static checkInternet() async {
    mListener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
        //print("statusNet     $status");
          break;
        case DataConnectionStatus.disconnected:
        //print("statusNetOff     $status");
          break;
      }
    });

    return await DataConnectionChecker().connectionStatus;
  }
}
