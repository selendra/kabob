import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:latlong/latlong.dart';
import 'package:wallet_apps/src/models/checkin.m.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';
import 'package:wallet_apps/src/screen/check_in/check_in_body.dart';
import '../../provider/wallet_provider.dart';

class CheckIn extends StatefulWidget {
  
  final String qrRes;
  const CheckIn( {this.qrRes = ''});
  static const route = '/checkin';
  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  final CheckInModel _checkInModel = CheckInModel();
  FlareControls flareController = FlareControls();
  String _location;

  List<Map<String, String>> list = [
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
            list["status"].toString(),
          ),
        ));
  }

  void resetAssetsDropDown(String data) {
    setState(() {
      _checkInModel.status = data;
    });
  }

  String onChanged(String value) {
    if (_checkInModel.hashNode.hasFocus && value.isNotEmpty) {
      _checkInModel.checkInKey.currentState.validate();
      setState(() {
        _checkInModel.isEnable = true;
      });
    }
    return null;
  }

  Future<void> _getCurrentLocation() async {
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
  }

  Future<void> addressName(LatLng place) async {
    final List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(place.latitude, place.longitude);

    setState(() {
      _checkInModel.locationController.text =
          "${placemark[0].thoroughfare}, ${placemark[0].subLocality}, ${placemark[0].administrativeArea}";
      if (_checkInModel.hashController.text.isNotEmpty) {
        setState(() {
          _checkInModel.isEnable = true;
        });
      }
    });
  }

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _checkInModel.isSuccess = true;
    });
    Provider.of<ContractProvider>(context, listen: false).fetchAtdBalance();
    Provider.of<ContractProvider>(context, listen: false).getAStatus();

    flareController.play('Checkmark');
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  Future<String> dialogBox() async {
    /* Show Pin Code For Fill Out */
    final String _result = await showDialog(
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

  // void setPortfolio() {
  //   final walletProvider = Provider.of<WalletProvider>(context, listen: false);
  //   walletProvider.clearPortfolio();

  //   if (widget.sdkModel.contractModel.pHash != '') {
  //     walletProvider.addAvaibleToken({
  //       'symbol': widget.sdkModel.contractModel.pTokenSymbol,
  //       'balance': widget.sdkModel.contractModel.pBalance,
  //     });
  //   }

  //   if (widget.sdkModel.contractModel.attendantM.isAContain) {
  //     walletProvider.addAvaibleToken({
  //       'symbol': widget.sdkModel.contractModel.attendantM.aSymbol,
  //       'balance': widget.sdkModel.contractModel.attendantM.aBalance,
  //     });
  //   }

  //   walletProvider.availableToken.add({
  //     'symbol': widget.sdkModel.nativeSymbol,
  //     'balance': widget.sdkModel.nativeBalance,
  //   });

  //   if (!widget.sdkModel.contractModel.isContain &&
  //       !widget.sdkModel.contractModel.attendantM.isAContain) {
  //     Provider.of<WalletProvider>(context, listen: false).resetDatamap();
  //   }

  //   Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  // }

  Future<void> checkIn(String aHash, String password, String location) async {
    dialogLoading(context,
        content: 'Please wait! This might take a little bit longer');

    try {
      final res = await ApiProvider.sdk.api.keyring.aCheckIn(
        ApiProvider.keyring.keyPairs[0].pubKey,
        password,
        aHash,
        location,
      );

      if (res['status'] != null) {
        //print(res['status']);
        enableAnimation();
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
      //print(e.message);
    }
  }

  // Future<void> getToken() async {
  //   final res = await widget.sdkModel.sdk.api
  //       .getAToken(widget.sdkModel.keyring.keyPairs[0].address);

  //   widget.sdkModel.contractModel.attendantM.aBalance =
  //       BigInt.parse(res).toString();
  // }

  // Future<void> getAStatus() async {
  //   final res = await widget.sdkModel.sdk.api
  //       .getAStatus(widget.sdkModel.keyring.keyPairs[0].address);
  //   if (res) {
  //     widget.sdkModel.contractModel.attendantM.aStatus = true;
  //   } else {
  //     widget.sdkModel.contractModel.attendantM.aStatus = false;
  //   }

  //   //print(res);
  // }

  Future<void> checkOut(String aHash, String password, String location) async {
    dialogLoading(context,
        content: 'Please wait! This might take a little bit longer');
    try {
      final res = await ApiProvider.sdk.api.keyring.aCheckOut(
        ApiProvider.keyring.keyPairs[0].pubKey,
        password,
        aHash,
        location,
      );

      if (res['status'] != null) {
        enableAnimation();
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future<void> clickSend() async {
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
              resetAssetsDropDown,
              list,
              item,
            ),
            if (_checkInModel.isSuccess == false)
              Container()
            else
              BackdropFilter(
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
