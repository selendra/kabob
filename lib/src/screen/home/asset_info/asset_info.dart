import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_apps/src/models/fmt.dart';
import 'package:wallet_apps/src/models/model_asset_info.dart';
import 'package:wallet_apps/src/screen/home/asset_info/asset_info_c.dart';
import '../../../../index.dart';

class AssetInfo extends StatefulWidget {
  final String kpiBalance;
  final WalletSDK sdk;
  final Keyring keyring;
  AssetInfo({@required this.kpiBalance, this.sdk, this.keyring});
  @override
  _AssetInfoState createState() => _AssetInfoState();
}

class _AssetInfoState extends State<AssetInfo> {
  TextEditingController _ownerController = TextEditingController();
  TextEditingController _spenderController = TextEditingController();
  TextEditingController _recieverController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  TextEditingController _fromController = TextEditingController();

  AssetInfoC _c = AssetInfoC();
  ModelAssetInfo _modelAssetInfo = ModelAssetInfo();

  FlareControls _flareController = FlareControls();
  ModelScanPay _scanPayM = ModelScanPay();

  FocusNode _ownerNode = FocusNode();
  FocusNode _spenderNode = FocusNode();
  FocusNode _passNode = FocusNode();
  FocusNode _fromNode = FocusNode();

  String _kpiSupply = '0';
  String _kpiBalance = '0';
  bool _loading = false;

  void submitAllowance() {
    if (_ownerController.text != null && _spenderController.text != null) {
      allowance(_ownerController.text, _spenderController.text);
    }
  }

  void submitApprove() {
    if (_amountController.text != null &&
        _recieverController.text != null &&
        _pinController.text != null) {
      approve(_recieverController.text, _pinController.text,
          _amountController.text);
    }
  }

  void submitTransferFrom() {
    if (_amountController.text != null &&
        _recieverController.text != null &&
        _pinController.text != null) {
      transferFrom(_recieverController.text, _fromController.text,
          _pinController.text, _amountController.text);
    }
  }

  void submitBalanceOf() {
    if (_recieverController.text != null) {
      _balanceOf(widget.keyring.keyPairs[0].address, _recieverController.text);
    }
  }

  Future enableAnimation() async {
    setState(() {
      _scanPayM.isPay = true;
    });
    _flareController.play('Checkmark');
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  Future<void> approve(
      String recieverAddress, String pass, String amount) async {
    Navigator.pop(context);
    try {
      final res = await widget.sdk.api.keyring.approve(
          widget.keyring.keyPairs[0].pubKey, recieverAddress, amount, pass);

      print(res['hash']);
      if (res['hash'] != null) {
        await dialog(
            context,
            MyText(
              text: 'Approve Successfully!',
              textAlign: TextAlign.center,
            ),
            Text('Approve'));
      }
    } catch (e) {
      print(e.toString());
      await dialog(context, Text(e.toString()), Text('Opps!!'));
    }

    _amountController.text = '';
    _recieverController.text = '';
    _pinController.text = '';

    // Navigator.pop(context);
    // setState(() {
    //   _loading = true;
    // });
    // final pairs = await KeyringPrivateStore()
    //     .getDecryptedSeed('${widget.keyring.keyPairs[0].pubKey}', pass);
    // if (pairs['seed'] != null) {
    //   final res =
    //       await http.post('http://localhost:3000/:service/contract/approve',
    //           headers: <String, String>{
    //             "content-type": "application/json",
    //           },
    //           body: jsonEncode(<String, dynamic>{
    //             "sender": pairs['seed'],
    //             "to": recieverAddress,
    //             "value": amount,
    //           }));

    //   var resJson = jsonDecode(res.body);
    //   if (resJson == null) {
    //     await dialog(context, Text('Something went wrong!'), Text('Opps!!'));
    //   } else {

    //   }
    // } else {
    //   await dialog(
    //       context,
    //       MyText(
    //         text: 'Incorrect Pin',
    //         textAlign: TextAlign.center,
    //       ),
    //       Text('Approve'));
    // }

    // _amountController.text = '';
    // _recieverController.text = '';
    // _pinController.text = '';

    // setState(() {
    //   _loading = false;
    // });
  }

  Future<void> transferFrom(
      String recieverAddress, String from, String pin, String amount) async {
    Navigator.pop(context);
    dialogLoading(context);
    try {
      final res = await widget.sdk.api.keyring.contractTransferFrom(
        from,
        widget.keyring.keyPairs[0].pubKey,
        recieverAddress,
        amount,
        pin,
      );
      if (res['hash'] != null) {
        Navigator.pop(context);
        await enableAnimation();
      }
    } catch (e) {
      Navigator.pop(context);
      await dialog(context, Text(e.toString()), Text('Opps!!'));
    }
    _fromController.text = '';
    _amountController.text = '';
    _recieverController.text = '';
    _pinController.text = '';

    // setState(() {
    //   _loading = true;
    // });
    // final pairs = await KeyringPrivateStore()
    //     .getDecryptedSeed('${widget.keyring.keyPairs[0].pubKey}', pass);
    // if (pairs['seed'] == null) {
    //   await dialog(
    //       context,
    //       MyText(
    //         text: 'Incorrect Pin',
    //         textAlign: TextAlign.center,
    //       ),
    //       Text('Approve'));
    // } else {
    //   final res = await http.post(
    //       'http://localhost:3000/:service/contract/transferfrom',
    //       headers: <String, String>{
    //         "content-type": "application/json",
    //       },
    //       body: jsonEncode(<String, dynamic>{
    //         "sender": pairs['seed'],
    //         "from": from,
    //         "to": recieverAddress,
    //         "value": amount,
    //       }));

    //   var resJson = jsonDecode(res.body);

    //   if (resJson == null) {
    //     await dialog(context, Text('Something went wrong!'), Text('Opps!!'));
    //   } else {
    //     await dialog(
    //         context, Text('Transfer From Successfully'), Text('Transfer From'));
    //   }
    // }

    // _amountController.text = '';
    // _recieverController.text = '';
    // _pinController.text = '';

    // setState(() {
    //   _loading = false;
    // });
  }

  Future<void> allowance(String owner, String spender) async {
    Navigator.pop(context);
    try {
      final res = await widget.sdk.api.allowance(owner, spender);
      if (res != null) {
        await dialog(context, Text('Allowance: ${BigInt.parse(res['output'])}'),
            Text('Allowance'));
      }
    } catch (e) {
      print(e.toString());
    }
    _ownerController.text = '';
    _spenderController.text = '';
  }

  Future<void> totalSupply() async {
    try {
      final res = await widget.sdk.api.totalSupply(
        widget.keyring.keyPairs[0].address,
      );
      print(res.toString());
      print(res['output']);
      if (res != null) {
        setState(() {
          _kpiSupply = BigInt.parse(res['output']).toString();
        });
        print(_kpiSupply);
      }
    } catch (e) {
      print(e.toString());
      await dialog(context, Text(e.toString()), Text('Opps!!'));
    }
  }

  Future<void> _balanceOf(String from, String who) async {
    Navigator.pop(context);
    try {
      final res = await widget.sdk.api.balanceOf(from, who);
      if (res != null) {
        await dialog(
            context,
            MyText(
              text: 'Account Balance: ${BigInt.parse(res['output'])}',
              textAlign: TextAlign.center,
            ),
            Text('Balance Of'));
      }
    } catch (e) {
      print(e.toString());
      await dialog(context, Text(e.toString()), Text('Opps!!'));
    }
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 3)).then((value) {
      _balanceOf(widget.keyring.keyPairs[0].address,
          widget.keyring.keyPairs[0].address);
    });
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

  // String validateAmount(String value) {
  //   if (_scanPayM.nodeAmount.hasFocus) {
  //     _scanPayM.responseAmount = instanceValidate.validateSendToken(value);
  //     enableButton();
  //     if (_scanPayM.responseAmount != null)
  //       return _scanPayM.responseAmount += "amount";
  //   }
  //   return _scanPayM.responseAmount;
  // }

  @override
  void initState() {
    _kpiBalance = widget.kpiBalance;
    totalSupply();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
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
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 25, bottom: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: hexaCodeToColor(AppColors.cardColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(right: 16),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child:
                                  Image.asset('assets/koompi_white_logo.png'),
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
                                  MyText(
                                    text: _kpiBalance + " KPI",
                                    color: AppColors.secondary_text,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: MyText(
                                      text: "Total Supply: $_kpiSupply",
                                      color: AppColors.secondary_text,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      AssetInfoC().showBalanceOf(
                                          context,
                                          _modelAssetInfo.formBalanceOf,
                                          _recieverController,
                                          _ownerNode,
                                          onChangedBalancOf,
                                          onSubmit,
                                          submitBalanceOf);
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: MyText(
                                        text: "Check Balance",
                                        color: AppColors.secondary_text,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              MyBottomSheet().trxOptions(
                                context: context,
                                //portfolioList: homeM.portfolioList,
                                // resetHomeData: resetDbdState,
                                sdk: widget.sdk,
                                keyring: widget.keyring,
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: hexaCodeToColor(AppColors.cardColor),
                                  ),
                                  child: Icon(
                                    Icons.near_me,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                MyText(
                                  text:
                                      "Transfer", //portfolioData[0]["data"]['balance'],
                                  color: "#FFFFFF",
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //transfer();
                              AssetInfoC().showtransferFrom(
                                  context,
                                  _modelAssetInfo.formTransferFrom,
                                  _fromController,
                                  _recieverController,
                                  _amountController,
                                  _pinController,
                                  _fromNode,
                                  _ownerNode,
                                  _spenderNode,
                                  _passNode,
                                  onChangedTransferFrom,
                                  onSubmit,
                                  submitTransferFrom);

                              // MyBottomSheet().trxOptions(
                              //   context: context,
                              //   sdk: widget.sdk,
                              //   keyring: widget.keyring,
                              // );
                              // c.transferFrom = true;
                            },
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: hexaCodeToColor(AppColors.cardColor),
                                  ),
                                  child: Icon(
                                    Icons.swap_vert,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                MyText(
                                  text:
                                      "Transfer From", //portfolioData[0]["data"]['balance'],
                                  color: "#FFFFFF",
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              AssetInfoC().showApprove(
                                  context,
                                  _modelAssetInfo.formApprove,
                                  _recieverController,
                                  _amountController,
                                  _pinController,
                                  _ownerNode,
                                  _spenderNode,
                                  _passNode,
                                  onChangedApprove,
                                  onSubmit,
                                  submitApprove);
                            },
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: hexaCodeToColor(AppColors.cardColor),
                                  ),
                                  child: Icon(
                                    Icons.check_box,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                MyText(
                                  text:
                                      "Approve", //portfolioData[0]["data"]['balance'],
                                  color: "#FFFFFF",
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //allowance();
                              AssetInfoC().showAllowance(
                                context,
                                _modelAssetInfo.formAllowance,
                                _ownerController,
                                _spenderController,
                                _ownerNode,
                                _spenderNode,
                                onChangedAllow,
                                onSubmit,
                                submitAllowance,
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: hexaCodeToColor(AppColors.cardColor),
                                  ),
                                  child: Icon(
                                    Icons.receipt,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                MyText(
                                  text:
                                      "Allowance", //portfolioData[0]["data"]['balance'],
                                  color: "#FFFFFF",
                                  fontSize: 14,
                                ),
                              ],
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
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.only(left: 16, bottom: 8),
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        text: 'Yesterday',
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) => rowDecorationStyle(
                          child: Row(
                            children: <Widget>[
                              MyCircularImage(
                                padding: EdgeInsets.all(6),
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                    color: hexaCodeToColor(AppColors.secondary),
                                    borderRadius: BorderRadius.circular(40)),
                                imagePath: 'assets/sld_logo.svg',
                                width: 50,
                                height: 50,
                                colorImage: Colors.white,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        text: "KPI",
                                        color: "#FFFFFF",
                                        fontSize: 18,
                                      ),
                                      MyText(text: "Koompi", fontSize: 15),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                          width: double.infinity,
                                          text: "0",
                                          color: "#FFFFFF",
                                          fontSize: 18,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _scanPayM.isPay == false
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
                                        _flareController,
                                        "assets/animation/check.flr",
                                        "Checkmark"))
                              ],
                            )),
                  ],
                ),
        ),
      ),
    );
  }
}
