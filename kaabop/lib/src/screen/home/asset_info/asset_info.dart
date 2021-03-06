import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/model_asset_info.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import 'package:wallet_apps/src/screen/check_in/check_in.dart';
import 'package:wallet_apps/src/screen/home/asset_info/asset_history.dart';
import 'package:wallet_apps/src/screen/home/asset_info/asset_info_c.dart';
import 'package:wallet_apps/src/screen/home/asset_info/att_activity.dart';
import '../../../../index.dart';

class AssetInfo extends StatefulWidget {
  final CreateAccModel sdkModel;
  final String assetLogo;
  final String balance;
  final String tokenSymbol;

  AssetInfo({this.sdkModel, this.assetLogo, this.balance, this.tokenSymbol});
  @override
  _AssetInfoState createState() => _AssetInfoState();
}

class _AssetInfoState extends State<AssetInfo> {
  ModelAssetInfo _modelAssetInfo = ModelAssetInfo();

  FlareControls _flareController = FlareControls();
  ModelScanPay _scanPayM = ModelScanPay();
  GetWalletMethod _method = GetWalletMethod();

  TxHistory _txHistoryModel = TxHistory();

  List<Map> _checkInList = [];
  List<Map> _checkOutList = [];
  List<Map> _checkAll = [];
  GlobalKey<ScaffoldState> _globalKey;
  GlobalKey _keyQrShare = GlobalKey();

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
    });
    _flareController.play('Checkmark');
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  Future<List<TxHistory>> readTxHistory() async {
    await StorageServices.fetchData('txhistory').then((value) {
      if (value != null) {
        for (var i in value) {
          if ((i['symbol'] == 'SEL')) {
            _txHistoryModel.tx.add(TxHistory(
              date: i['date'],
              symbol: i['symbol'],
              destination: i['destination'],
              sender: i['sender'],
              amount: i['amount'],
              org: i['fee'],
            ));
          } else {
            _txHistoryModel.txKpi.add(TxHistory(
              date: i['date'],
              symbol: i['symbol'],
              destination: i['destination'],
              sender: i['sender'],
              amount: i['amount'],
              org: i['fee'],
            ));
          }
        }
      }
      //var responseJson = json.decode(value);
      ////print(responseJson);
    });
    setState(() {});
    return _txHistoryModel.tx;
  }

  // Future<void> _deleteHistory(int index,String symbol) async {
  //   SharedPreferences _preferences = await SharedPreferences.getInstance();

  //   _txHistoryModel.txKpi.removeAt(index);
  //   setState(() {});

  //   await clearOldHistory().then((value) async {
  //     await _preferences.setString(
  //         'txhistory', jsonEncode(_txHistoryModel.txKpi));
  //     //await StorageServices.addTxHistory(txHistory, '');
  //   });
  // }
  Future<void> _deleteHistory(int index, String symbol) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    //var newgfgList = new List.from(gfg1)..addAll(gfg2);

    if (symbol == 'SEL') {
      _txHistoryModel.tx.removeAt(index);
    } else {
      _txHistoryModel.txKpi.removeAt(index);
    }

    var newTxList = new List.from(_txHistoryModel.tx)
      ..addAll(_txHistoryModel.txKpi);

    await clearOldHistory().then((value) async {
      await _preferences.setString('txhistory', jsonEncode(newTxList));
      //await StorageServices.addTxHistory(txHistory, '');
    });
  }

  Future<void> clearOldHistory() async {
    await StorageServices.removeKey('txhistory');
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 3)).then((value) {
      if (widget.tokenSymbol == "ATD") {
        getAStatus();
        getCheckInList();
        getCheckOutList();
        sortList();
      }
    });
  }

  Future<void> getCheckInList() async {
    final res = await widget.sdkModel.sdk.api
        .getCheckInList(widget.sdkModel.keyring.keyPairs[0].address);

    setState(() {
      _checkInList.clear();
    });
    for (var i in res) {
      String latlong = i['location'];

      await addressName(LatLng(double.parse(latlong.split(',')[0]),
              double.parse(latlong.split(',')[1])))
          .then((value) async {
        if (value != null) {
          await dateConvert(i['time']).then((time) {
            setState(() {
              _checkInList
                  .add({'time': time, 'location': value, 'status': true});
            });
          });
        }
      });
    }
    if (!mounted) return;
    return res;
  }

  Future<void> getCheckOutList() async {
    final res = await widget.sdkModel.sdk.api
        .getCheckOutList(widget.sdkModel.keyring.keyPairs[0].address);

    setState(() {
      _checkOutList.clear();
    });

    for (var i in res) {
      String latlong = i['location'];

      await addressName(LatLng(double.parse(latlong.split(',')[0]),
              double.parse(latlong.split(',')[1])))
          .then((value) async {
        if (value != null) {
          await dateConvert(i['time']).then((time) {
            setState(() {
              _checkOutList
                  .add({'time': time, 'location': value, 'status': false});
            });
          });
        }
      });
    }
    if (!mounted) return;
    return res;
  }

  void initATD() async {
    if (widget.tokenSymbol == "ATD") {
      getAStatus();
      await getCheckInList();
      await getCheckOutList();
      sortList();
    }
  }

  Future<String> addressName(LatLng place) async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(place.latitude, place.longitude);

    return placemark[0].thoroughfare ??
        '' + ", " + placemark[0].subLocality ??
        '' + ", " + placemark[0].administrativeArea ??
        '';
  }

  Future<String> dateConvert(int millisecond) async {
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(millisecond);

    return df.format(date);
  }

  Future<void> sortList() async {
    _checkAll = List.from(_checkInList)..addAll(_checkOutList);
    _checkAll.sort((a, b) => a['time'].compareTo(b['time']));
    setState(() {});
    if (!mounted) return;
  }

  Future<void> getAStatus() async {
    final res = await widget.sdkModel.sdk.api
        .getAStatus(widget.sdkModel.keyring.keyPairs[0].address);
    if (res) {
      setState(() {
        widget.sdkModel.contractModel.attendantM.aStatus = true;
      });
    } else {
      widget.sdkModel.contractModel.attendantM.aStatus = false;
    }
  }

  String onChangedTransferFrom(String value) {
    _modelAssetInfo.formTransferFrom.currentState.validate();
    return value;
  }

  String onChangedBalancOf(String value) {
    _modelAssetInfo.formBalanceOf.currentState.validate();
    return value;
  }

  String onChangedApprove(String value) {
    _modelAssetInfo.formApprove.currentState.validate();
    return value;
  }

  String onChangedAllow(String value) {
    _modelAssetInfo.formAllowance.currentState.validate();
    return value;
  }

  String onSubmit(String value) {
    return value;
  }

  void showDetailDialog(TxHistory txHistory) async {
    await txDetailDialog(context, txHistory);
  }

  void qrRes() async {
    var _response = await Navigator.push(context, transitionRoute(QrScanner()));

    if (_response != null && _response != "null") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CheckIn(
                    widget.sdkModel,
                    qrRes: _response,
                  )));
    }
    // if (value != null && value != "null") {}
  }

  @override
  void initState() {
    readTxHistory();

    _globalKey = GlobalKey<ScaffoldState>();
    initATD();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      floatingActionButton: widget.tokenSymbol != "ATD"
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                qrRes();
              },
              backgroundColor: hexaCodeToColor(AppColors.secondary),
              child: Icon(
                Icons.location_on,
                size: 30,
              ),
            ),
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: "Asset",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: hexaCodeToColor(AppColors.cardColor),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: widget.tokenSymbol == 'SEL'
                          ? EdgeInsets.only(right: 0)
                          : EdgeInsets.only(right: 16),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.asset(widget.assetLogo),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Balance",
                            color: "#FFFFFF",
                            fontSize: 20,
                          ),
                          SizedBox(height: 5),
                          Expanded(
                            child: MyText(
                              text: widget.balance,
                              color: AppColors.secondary_text,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.tokenSymbol != "ATD"
                        ? Container()
                        : Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: MyText(
                                textAlign: TextAlign.right,
                                text: widget.sdkModel.contractModel.attendantM
                                        .aStatus
                                    ? 'Status: Check-In'
                                    : 'Status: Check-out',
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Container(
              padding: widget.tokenSymbol == 'ATD'
                  ? const EdgeInsets.symmetric(vertical: 0.0)
                  : const EdgeInsets.symmetric(vertical: 16.0),
              child: widget.tokenSymbol == 'ATD'
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 150,
                          child: FlatButton(
                            onPressed: () {
                              MyBottomSheet().trxOptions(
                                context: context,
                                sdk: widget.sdkModel.sdk,
                                keyring: widget.sdkModel.keyring,
                                sdkModel: widget.sdkModel,
                              );
                            },
                            color: hexaCodeToColor(AppColors.secondary),
                            disabledColor: Colors.grey[700],
                            focusColor: hexaCodeToColor(AppColors.secondary),
                            child: MyText(
                              text: 'Transfer',
                              color: '#FFFFFF',
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Container(
                          height: 50,
                          width: 150,
                          child: FlatButton(
                            onPressed: () {
                              AssetInfoC().showRecieved(
                                context,
                                widget.sdkModel,
                                _method,
                               // _globalKey,
                              //  _keyQrShare,
                              );
                            },
                            color: hexaCodeToColor(AppColors.secondary),
                            disabledColor: Colors.grey[700],
                            focusColor: hexaCodeToColor(AppColors.secondary),
                            child: MyText(
                              text: 'Recieved',
                              color: '#FFFFFF',
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: hexaCodeToColor(AppColors.secondary)),
                  ),
                  MyText(
                    text: 'Activity',
                    fontSize: 27,
                    color: "#FFFFFF",
                    left: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            widget.tokenSymbol == 'SEL'
                ? AssetHistory(_txHistoryModel.tx, _flareController,
                    _scanPayM.isPay, _deleteHistory, showDetailDialog)
                : Container(),
            widget.tokenSymbol == 'KMPI'
                ? AssetHistory(_txHistoryModel.txKpi, _flareController,
                    _scanPayM.isPay, _deleteHistory, showDetailDialog)
                : Container(),
            widget.tokenSymbol == 'ATD'
                ? AttActivity(
                    _checkAll.reversed.toList(),
                    widget.sdkModel,
                    _refresh,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
