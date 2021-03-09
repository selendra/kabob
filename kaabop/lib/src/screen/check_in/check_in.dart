import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:latlong/latlong.dart';
import 'package:wallet_apps/src/models/checkin.m.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';
import 'package:wallet_apps/src/screen/check_in/check_in_body.dart';

import '../../provider/wallet_provider.dart';

class CheckIn extends StatefulWidget {
  final CreateAccModel sdkModel;
  final String qrRes;
  CheckIn(this.sdkModel, {this.qrRes = ''});
  static const route = '/checkin';
  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  final CheckInModel _checkInModel = CheckInModel();
  FlareControls flareController = FlareControls();
  String _location;

  List list = [
    {'status': 'Check In'},
    {'status': 'Check Out'}
  ];

  PopupMenuItem item(Map<String, dynamic> list) {
    /* Display Drop Down List */
    return PopupMenuItem(
        value: list["status"],
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            list["status"],
          ),
        ));
  }

  void resetAssetsDropDown(String data) {
    setState(() {
      _checkInModel.status = data;
    });
  }

  void onChanged(String value) {
    if (_checkInModel.hashNode.hasFocus && value.isNotEmpty) {
      _checkInModel.checkInKey.currentState.validate();
      setState(() {
        _checkInModel.isEnable = true;
      });
    }
  }

  void _getCurrentLocation() async {
    final geoLocator = Geolocator()..forceAndroidLocationManager;
    geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      if (mounted) {
        //print(position);
        _location =
            '${position.latitude},${position.longitude}'; //position.toString();

        addressName(LatLng(position.latitude, position.longitude));
      }
    });

    // if (_isLive) {
    //   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    //   geolocator
    //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    //       .then((Position position) {
    //     if (mounted) {
    //       setState(() {
    //         _currentPosition = position;
    //         animateMove(
    //             LatLng(_currentPosition.latitude, _currentPosition.longitude),
    //             kDefaultMaxZoom - 2);
    //         addressName(
    //             LatLng(_currentPosition.latitude, _currentPosition.longitude));

    //         markers.add(Marker(
    //           point:
    //               LatLng(_currentPosition.latitude, _currentPosition.longitude),
    //           builder: (context) => Container(
    //             child: Icon(
    //               Icons.location_on,
    //               color: kDefaultColor,
    //               size: 50,
    //             ),
    //           ),
    //         ));
    //       });
    //     }
    //   }).catchError((e) {});
    // } else {
    //   markers.removeLast();
    //   // _key.currentState.contract();
    //   animateMove(kDefualtLatLng, kDefaultMapZoom);
    // }
    //if (!mounted) return;
  }

  addressName(LatLng place) async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(place.latitude, place.longitude);

    setState(() {
      _checkInModel.locationController.text = placemark[0].thoroughfare +
          ", " +
          placemark[0].subLocality +
          ", " +
          placemark[0].administrativeArea;
      if (_checkInModel.hashController.text.isNotEmpty) {
        setState(() {
          _checkInModel.isEnable = true;
        });
      }
    });

    for (var i in placemark) {
      //print(i.administrativeArea);
      //print(i.name);
    }
    //pattern for saving address throughtfare(st) +
    //subadministrative(sangkat) + sublocality(khan) + locality(province or city)

    // setState(() {
    //   animateMove(place, 15.0);
    //   locate = placemark[0].thoroughfare + placemark[0].subLocality;
    // });
    //_key.currentState.expand();
  }

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _checkInModel.isSuccess = true;
    });
    getToken();
    getAStatus();
    setPortfolio();
    flareController.play('Checkmark');
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  Future<String> dialogBox() async {
    /* Show Pin Code For Fill Out */
    String _result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: FillPin(),
          );
        });
    return _result;
  }

  void mqrRes(String value) {
    // if (value != null && value != "null") {
    //   setState(() {
    //     _checkInModel.hashController.text = value;
    //     if (_checkInModel.locationController.text.isNotEmpty) {
    //       setState(() {
    //         _checkInModel.isEnable = true;
    //       });
    //     }
    //   });
    // }
  }
  void setPortfolio() {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.clearPortfolio();

    if (widget.sdkModel.contractModel.pHash != '') {
      walletProvider.addAvaibleToken({
        'symbol': widget.sdkModel.contractModel.pTokenSymbol,
        'balance': widget.sdkModel.contractModel.pBalance,
      });
    }

    if (widget.sdkModel.contractModel.attendantM.isAContain) {
      walletProvider.updateAvailableToken({
        'symbol': widget.sdkModel.contractModel.attendantM.aSymbol,
        'balance': widget.sdkModel.contractModel.attendantM.aBalance,
      });
    }

    walletProvider.availableToken.add({
      'symbol': widget.sdkModel.nativeSymbol,
      'balance': widget.sdkModel.nativeBalance,
    });

    if (!widget.sdkModel.contractModel.isContain &&
        !widget.sdkModel.contractModel.attendantM.isAContain) {
      Provider.of<WalletProvider>(context, listen: false).resetDatamap();
    }

    Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  }

  Future<void> checkIn(String aHash, String password, String location) async {
    dialogLoading(context,
        content: 'Please wait! This might take a little bit longer');

    try {
      //print('res');
      final res = await widget.sdkModel.sdk.api.keyring.aCheckIn(
        widget.sdkModel.keyring.keyPairs[0].pubKey,
        password,
        aHash,
        location,
      );

      if ((res['status'] != null)) {
        //print(res['status']);
        enableAnimation();
      }
    } catch (e) {
      Navigator.pop(context);
      //print(e.message);
    }
  }

  Future<void> getToken() async {
    final res = await widget.sdkModel.sdk.api
        .getAToken(widget.sdkModel.keyring.keyPairs[0].address);

    widget.sdkModel.contractModel.attendantM.aBalance =
        BigInt.parse(res).toString();
  }

  Future<void> getAStatus() async {
    final res = await widget.sdkModel.sdk.api
        .getAStatus(widget.sdkModel.keyring.keyPairs[0].address);
    if (res) {
      widget.sdkModel.contractModel.attendantM.aStatus = true;
    } else {
      widget.sdkModel.contractModel.attendantM.aStatus = false;
    }

    //print(res);
  }

  Future<void> checkOut(String aHash, String password, String location) async {
    dialogLoading(context,
        content: 'Please wait! This might take a little bit longer');
    try {
      final res = await widget.sdkModel.sdk.api.keyring.aCheckOut(
        widget.sdkModel.keyring.keyPairs[0].pubKey,
        password,
        aHash,
        location,
      );

      if ((res['status'] != null)) {
        enableAnimation();
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  void clickSend() async {
    if (_checkInModel.checkInKey.currentState.validate()) {
      await dialogBox().then((value) {
        if (value != null && _location != null) {
          if (_checkInModel.status == "Check In") {
            //print('checkIN');
            checkIn(_checkInModel.hashController.text, value, _location);
          } else {
            //print('checkIN');
            checkOut(_checkInModel.hashController.text, value, _location);
          }
          // dialogLoading(context);
        }
      });
    }
  }

  @override
  void initState() {
    _checkInModel.status = 'Check In';
    _checkInModel.hashController.text = widget.qrRes;
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            CheckInBody(
              _checkInModel,
              onChanged,
              _getCurrentLocation,
              clickSend,
              mqrRes,
              resetAssetsDropDown,
              list,
              item,
            ),
            _checkInModel.isSuccess == false
                ? Container()
                : BackdropFilter(
                    // Fill Blur Background
                    filter: ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: CustomAnimation.flareAnimation(
                            flareController,
                            "assets/animation/check.flr",
                            "Checkmark",
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
