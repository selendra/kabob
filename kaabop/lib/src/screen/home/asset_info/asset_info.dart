import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/model_asset_info.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';
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

  const AssetInfo({
    this.sdkModel,
    this.assetLogo,
    this.balance,
    this.tokenSymbol,
  });
  @override
  _AssetInfoState createState() => _AssetInfoState();
}

class _AssetInfoState extends State<AssetInfo> {
  final FlareControls _flareController = FlareControls();
  final ModelScanPay _scanPayM = ModelScanPay();
  final GetWalletMethod _method = GetWalletMethod();

  final TxHistory _txHistoryModel = TxHistory();

  final List<Map> _checkInList = [];
  final List<Map> _checkOutList = [];
  List<Map> _checkAll = [];
  GlobalKey<ScaffoldState> _globalKey;

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
    });
    _flareController.play('Checkmark');
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  Future<List<TxHistory>> readTxHistory() async {
    await StorageServices.fetchData('txhistory').then((value) {
      if (value != null) {
        for (final i in value) {
          // ignore: unnecessary_parenthesis
          if ((i['symbol'] == 'SEL')) {
            _txHistoryModel.tx.add(TxHistory(
              date: i['date'].toString(),
              symbol: i['symbol'].toString(),
              destination: i['destination'].toString(),
              sender: i['sender'].toString(),
              amount: i['amount'].toString(),
              org: i['fee'].toString(),
            ));
          } else {
            _txHistoryModel.txKpi.add(
              TxHistory(
                date: i['date'].toString(),
                symbol: i['symbol'].toString(),
                destination: i['destination'].toString(),
                sender: i['sender'].toString(),
                amount: i['amount'].toString(),
                org: i['fee'].toString(),
              ),
            );
          }
        }
      }
    });
    setState(() {});
    return _txHistoryModel.tx;
  }

  Future<void> _deleteHistory(int index, String symbol) async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();

    if (symbol == 'SEL') {
      _txHistoryModel.tx.removeAt(index);
    } else {
      _txHistoryModel.txKpi.removeAt(index);
    }

    final newTxList = List.from(_txHistoryModel.tx)
      ..addAll(_txHistoryModel.txKpi);

    await clearOldHistory().then((value) async {
      await _preferences.setString('txhistory', jsonEncode(newTxList));
    });
  }

  Future<void> clearOldHistory() async {
    await StorageServices.removeKey('txhistory');
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 3)).then((value) {
      if (widget.tokenSymbol == "ATD") {
        Provider.of<ContractProvider>(context, listen: false).getAStatus();
        getCheckInList();
        getCheckOutList();
        sortList();
      }
    });
  }

  Future<void> getCheckInList() async {
    final res = await ApiProvider.sdk.api
        .getCheckInList(ApiProvider.keyring.keyPairs[0].address);

    setState(() {
      _checkInList.clear();
    });
    for (final i in res) {
      final String latlong = i['location'].toString();

      await addressName(LatLng(double.parse(latlong.split(',')[0]),
              double.parse(latlong.split(',')[1])))
          .then((value) async {
        if (value != null) {
          await dateConvert(int.parse(i['time'].toString())).then((time) {
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
    final res = await ApiProvider.sdk.api
        .getCheckOutList(ApiProvider.keyring.keyPairs[0].address);

    setState(() {
      _checkOutList.clear();
    });

    for (final i in res) {
      final String latlong = i['location'].toString();

      await addressName(LatLng(double.parse(latlong.split(',')[0]),
              double.parse(latlong.split(',')[1])))
          .then((value) async {
        if (value != null) {
          await dateConvert(int.parse(i['time'].toString())).then((time) {
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

  Future<void> initATD() async {
    if (widget.tokenSymbol == "ATD") {
      Provider.of<ContractProvider>(context, listen: false).getAStatus();
      await getCheckInList();
      await getCheckOutList();
      sortList();
    }
  }

  Future<String> addressName(LatLng place) async {
    final List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(place.latitude, place.longitude);

    return placemark[0].thoroughfare ??
        '' + ", " + placemark[0].subLocality ??
        '' + ", " + placemark[0].administrativeArea ??
        '';
  }

  Future<String> dateConvert(int millisecond) async {
    final df = DateFormat('dd-MM-yyyy hh:mm a');
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecond);

    return df.format(date);
  }

  Future<void> sortList() async {
    _checkAll = List.from(_checkInList)..addAll(_checkOutList);

    _checkAll.sort(
      (a, b) => a['time'].toString().compareTo(
            b['time'].toString(),
          ),
    );
    setState(() {});
    if (!mounted) return;
  }

  String onSubmit(String value) {
    return value;
  }

  Future<void> showDetailDialog(TxHistory txHistory) async {
    await txDetailDialog(context, txHistory);
  }

  Future<void> qrRes() async {
    final _response =
        await Navigator.push(context, transitionRoute(QrScanner()));

    if (_response != null && _response != "null") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckIn(
            widget.sdkModel,
            qrRes: _response.toString(),
          ),
        ),
      );
    }
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
              child: const Icon(
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
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 25,
                  bottom: 25,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: hexaCodeToColor(AppColors.cardColor),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: widget.tokenSymbol == 'SEL'
                          ? const EdgeInsets.only()
                          : const EdgeInsets.only(right: 16),
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
                          const MyText(
                            text: "Balance",
                            color: "#FFFFFF",
                            fontSize: 20,
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: MyText(
                              text: widget.balance,
                              color: AppColors.secondarytext,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.tokenSymbol != "ATD")
                      Container()
                    else
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Consumer<ContractProvider>(
                            builder: (context, value, child) {
                              return MyText(
                                textAlign: TextAlign.right,
                                text: value.atd.status
                                    ? 'Status: Check-In'
                                    : 'Status: Check-out',
                                fontSize: 14.0,
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: widget.tokenSymbol == 'ATD'
                  ? const EdgeInsets.symmetric()
                  : const EdgeInsets.symmetric(vertical: 16.0),
              child: widget.tokenSymbol == 'ATD'
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 150,
                          // ignore: deprecated_member_use
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
                            child: const MyText(
                              text: 'Transfer',
                              color: '#FFFFFF',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        SizedBox(
                          height: 50,
                          width: 150,
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () {
                              AssetInfoC().showRecieved(
                                context,
                               
                                _method,
                              );
                            },
                            color: hexaCodeToColor(
                              AppColors.secondary,
                            ),
                            disabledColor: Colors.grey[700],
                            focusColor: hexaCodeToColor(
                              AppColors.secondary,
                            ),
                            child: const MyText(
                              text: 'Recieved',
                              color: '#FFFFFF',
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: hexaCodeToColor(
                        AppColors.secondary,
                      ),
                    ),
                  ),
                  const MyText(
                    text: 'Activity',
                    fontSize: 27,
                    color: "#FFFFFF",
                    left: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            if (widget.tokenSymbol == 'SEL')
              AssetHistory(
                _txHistoryModel.tx,
                _flareController,
                _scanPayM.isPay,
                widget.assetLogo,
                _deleteHistory,
                showDetailDialog,
              )
            else
              Container(),
            if (widget.tokenSymbol == 'KMPI')
              AssetHistory(
                _txHistoryModel.txKpi,
                _flareController,
                _scanPayM.isPay,
                widget.assetLogo,
                _deleteHistory,
                showDetailDialog,
              )
            else
              Container(),
            if (widget.tokenSymbol == 'ATD')
              AttActivity(
                _checkAll.reversed.toList(),
                widget.sdkModel,
                _refresh,
              )
            else
              Container()
          ],
        ),
      ),
    );
  }
}
