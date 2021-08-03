import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';

class NetworkSensitive extends StatefulWidget {
  final Widget child;
  NetworkSensitive({@required this.child});
  @override
  _NetworkSensitiveState createState() => _NetworkSensitiveState();
}

class _NetworkSensitiveState extends State<NetworkSensitive> {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _result;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _result = await _connectivity.checkConnectivity();

      _updateConnectionStatus(_result);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    //return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _result = result;
    switch (result) {
      case ConnectivityResult.wifi:
        break;
      case ConnectivityResult.mobile:
        break;
      case ConnectivityResult.none:
        await customDialog(
            context, 'Please check your internet connection!', '');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> customDialog(
      BuildContext context, String text1, String text2) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                text1,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            ),
            FlatButton(
              onPressed: () async {
                final result = await _connectivity.checkConnectivity();
                if (result != ConnectivityResult.none) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'RETRY',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: hexaCodeToColor(AppColors.secondary),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
