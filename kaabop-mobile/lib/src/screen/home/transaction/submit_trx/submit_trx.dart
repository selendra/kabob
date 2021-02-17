import 'dart:ui';
import 'package:flare_flutter/flare_controls.dart';
import 'package:intl/intl.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/fmt.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import 'package:wallet_apps/src/screen/home/asset_info/asset_info_c.dart';

class SubmitTrx extends StatefulWidget {
  final String _walletKey;
  final List<dynamic> _listPortfolio;
  final bool enableInput;
  final CreateAccModel sdkModel;

  SubmitTrx(
      this._walletKey, this.enableInput, this._listPortfolio, this.sdkModel);
  @override
  State<StatefulWidget> createState() {
    return SubmitTrxState();
  }
}

class SubmitTrxState extends State<SubmitTrx> {
  ModelScanPay _scanPayM = ModelScanPay();
  TextEditingController _pwController = TextEditingController();
  FocusNode _pwNode = FocusNode();

  FlareControls flareController = FlareControls();

  AssetInfoC c = AssetInfoC();

  bool disable = false;
  bool _loading = false;

  @override
  void initState() {
    _scanPayM.asset = "SEL";
    print(c.transferFrom);

    AppServices.noInternetConnection(_scanPayM.globalKey);

    _scanPayM.controlReceiverAddress.text = widget._walletKey;
    _scanPayM.portfolio = widget._listPortfolio;
    super.initState();
  }

  void fetchIDs() async {
    await ProviderBloc.fetchUserIds();
    setState(() {});
  }

  void removeAllFocus() {
    _scanPayM.nodeAmount.unfocus();
    _scanPayM.nodeMemo.unfocus();
  }

  Future<bool> validateInput() {
    /* Check User Fill Out ALL */
    if (_scanPayM.controlAmount.text != null &&
        _scanPayM.controlAmount.text != "" &&
        _scanPayM.controlReceiverAddress != null &&
        _scanPayM.controlReceiverAddress.text.isNotEmpty &&
        _scanPayM.asset != null) {
      return Future.delayed(Duration(milliseconds: 50), () {
        return true;
      });
    }
    return null;
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

  Future<String> passwordDialog() async {
    String result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: MyText(
              text: 'Enter your password',
            ),
            content: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  MyInputField(
                    obcureText: true,
                    controller: _pwController,
                    focusNode: _pwNode,
                    onChanged: null,
                    onSubmit: null,
                  ),
                ],
              ),
            ),
          );
        });
    return result;
  }

  String validateWallet(String value) {
    if (_scanPayM.nodeAmount.hasFocus) {
      _scanPayM.responseAmount = instanceValidate.validateSendToken(value);
      enableButton();
      if (_scanPayM.responseAmount != null)
        return _scanPayM.responseAmount += "wallet";
    }
    return _scanPayM.responseWallet;
  }

  Future<bool> validateAddress(String address) async {
    final res = await widget.sdkModel.sdk.api.keyring.validateAddress(address);
    return res;
  }

  String validateAmount(String value) {
    if (_scanPayM.nodeAmount.hasFocus) {
      _scanPayM.responseAmount = instanceValidate.validateSendToken(value);
      enableButton();
      if (_scanPayM.responseAmount != null)
        return _scanPayM.responseAmount += "amount";
    }
    return _scanPayM.responseAmount;
  }

  String validateMemo(String value) {
    if (_scanPayM.nodeMemo.hasFocus) {
      _scanPayM.responseMemo = instanceValidate.validateSendToken(value);
      enableButton();
      if (_scanPayM.responseMemo != null)
        return _scanPayM.responseMemo += "memo";
    }
    return _scanPayM.responseMemo;
  }

  void onChanged(String value) {
    _scanPayM.formStateKey.currentState.validate();
  }

  void onSubmit(BuildContext context) {
    if (_scanPayM.nodeReceiverAddress.hasFocus) {
      FocusScope.of(context).requestFocus(_scanPayM.nodeAmount);
    } else if (_scanPayM.nodeAmount.hasFocus) {
      FocusScope.of(context).requestFocus(_scanPayM.nodeMemo);
    } else {
      if (_scanPayM.enable == true) clickSend();
    }
  }

  void enableButton() {
    if (_scanPayM.controlAmount.text != '' && _scanPayM.asset != null)
      setState(() => _scanPayM.enable = true);
    else if (_scanPayM.enable == true) setState(() => _scanPayM.enable = false);
  }

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
      disable = true;
    });
    flareController.play('Checkmark');
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  void processingSubmit() async {
    /* Loading Processing Animation */
    int perioud = 500;
    while (_scanPayM.isPay == true) {
      await Future.delayed(Duration(milliseconds: perioud), () {
        if (this.mounted) setState(() => _scanPayM.loadingDot = ".");
        perioud = 300;
      });
      await Future.delayed(Duration(milliseconds: perioud), () {
        if (this.mounted) setState(() => _scanPayM.loadingDot = ". .");
        perioud = 300;
      });
      await Future.delayed(Duration(milliseconds: perioud), () {
        if (this.mounted) setState(() => _scanPayM.loadingDot = ". . .");
        perioud = 300;
      });
    }
  }

  void popScreen() {
    /* Close Current Screen */
    Navigator.pop(context, null);
  }

  void resetAssetsDropDown(String data) {
    print("My asset $data");
    /* Reset Asset */
    setState(() {
      _scanPayM.asset = data;
    });
    enableButton();
  }

  Future<void> transfer(String to, String pass, String value) async {
    // String hash =
    //     '0x6bc6587597acb08c96db1d83307e967dc1d7c9674d025122a417d01a53848112';
    dialogLoading(context,
        content: 'Please wait! This might take a little bit longer');

    print(widget.sdkModel.keyring.keyPairs[0].address);
    print(widget.sdkModel.keyring.keyPairs[0].pubKey);
    try {
      final res = await widget.sdkModel.sdk.api.keyring.contractTransfer(
        widget.sdkModel.keyring.keyPairs[0].pubKey,
        to,
        value,
        pass,
        widget.sdkModel.contractModel.pHash,
      );

      if (res['hash'] != null) {
        // assetbalanceOf(widget.sdkModel.keyring.keyPairs[0].address,
        //     widget.sdkModel.keyring.keyPairs[0].address);
        await _balanceOfByPartition();

        saveTxHistory(TxHistory(
          date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
          symbol: 'KMPI',
          destination: to,
          sender: widget.sdkModel.keyring.current.address,
          org: 'KOOMPI',
          amount: value.trim(),
        ));

        await enableAnimation();
      }
    } catch (e) {
      Navigator.pop(context);
      await dialog(context, Text(e.toString()), Text('Opps!!'));
    }
  }

  Future<String> sendTx(String target, String amount, String pin) async {
    dialogLoading(context);
    String mhash;
    final sender = TxSenderData(
      widget.sdkModel.keyring.current.address,
      widget.sdkModel.keyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);
    try {
      final hash = await widget.sdkModel.sdk.api.tx.signAndSend(
          txInfo,
          [
            // params.to
            // _testAddressGav,
            target,
            // params.amount
            Fmt.tokenInt(amount.trim(), 18).toString(),
          ],
          pin, onStatusChange: (status) async {
        print(status);
      });

      //print('tx status: $_status');
      print('hash: $hash');

      if (hash != null) {
        saveTxHistory(TxHistory(
          date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
          symbol: 'SEL',
          destination: target,
          sender: widget.sdkModel.keyring.current.address,
          org: 'Selendra',
          amount: amount.trim(),
        ));

        await enableAnimation();
      }
    } catch (e) {
      print(e.message);
      Navigator.pop(context);
      await dialog(context, Text(e.message), Text("Opps"));
    }

    return mhash;
  }

  Future<void> _balanceOfByPartition() async {
    try {
      final res = await widget.sdkModel.sdk.api.balanceOfByPartition(
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.contractModel.pHash,
      );
      // final res = await _createAccModel.sdk.api.balanceOfByPartition(
      //   '14gV68QsGAEUGkcuV5JA1hx2ZFTuKJthMFfnkDyLMZyn8nnb',
      //   '14gV68QsGAEUGkcuV5JA1hx2ZFTuKJthMFfnkDyLMZyn8nnb',
      //   '0x0000000000000000000000000000000000000000000000000000000000000001',
      // );
      widget.sdkModel.contractModel.pBalance =
          BigInt.parse(res['output']).toString();

      print('balanceOfByPartition $res');
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> assetbalanceOf(String from, String who) async {
  //   final res = await widget.sdkModel.sdk.api.balanceOf(from, who);
  //   if (res != null) {
  //     setState(() {
  //       widget.sdkModel.contractModel.pBalance =
  //           BigInt.parse(res['output']).toString();
  //       print(widget.sdkModel.contractModel.pBalance);
  //     });
  //   }
  // }

  void clickSend() async {
    String pin;

    if (_scanPayM.formStateKey.currentState.validate()) {
      /* Send payment */
      // Navigator.push(context, MaterialPageRoute(builder: (contxt) => FillPin()));
      await Future.delayed(Duration(milliseconds: 100), () {
        // Unfocus All Field Input
        unFocusAllField();
      });

      //await passwordDialog();

      await validateAddress(_scanPayM.controlReceiverAddress.text)
          .then((value) async {
        if (value) {
          await dialogBox().then((value) async {
            pin = value;
            if (pin != null &&
                _scanPayM.controlAmount.text != null &&
                _scanPayM.controlReceiverAddress.text != null) {
              if (_scanPayM.asset == 'SEL') {
                sendTx(_scanPayM.controlReceiverAddress.text,
                    _scanPayM.controlAmount.text, pin);
              } else {
                if (int.parse(widget.sdkModel.contractModel.pBalance) <
                    int.parse(_scanPayM.controlAmount.text)) {
                  await await dialog(
                      context,
                      Text(
                          'Sorry, You do not have enough balance to make transaction '),
                      Text('Insufficient Balance'));
                } else {
                  transfer(_scanPayM.controlReceiverAddress.text, pin,
                      _scanPayM.controlAmount.text);
                }
              }
            } else {
              print('amount is null');
            }
          });
        } else {
          await dialog(context, Text('Please fill in a valid address'),
              Text('Invalid Address'));
        }
      });
    }
  }

  void saveTxHistory(TxHistory txHistory) async {
    await StorageServices.addTxHistory(txHistory, 'txhistory');
  }

  void unFocusAllField() {
    _scanPayM.nodeAmount.unfocus();
    _scanPayM.nodeMemo.unfocus();
    _scanPayM.nodeReceiverAddress.unfocus();
  }

  PopupMenuItem item(Map<String, dynamic> list) {
    /* Display Drop Down List */
    return PopupMenuItem(
        value: list["asset_code"],
        child: Align(
          alignment: Alignment.center,
          child: Text(
            list["asset_code"],
          ),
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scanPayM.globalKey,
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : BodyScaffold(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  SubmitTrxBody(
                    enableInput: widget.enableInput,
                    dialog: dialogBox,
                    scanPayM: _scanPayM,
                    validateWallet: validateAddress,
                    validateAmount: validateAmount,
                    validateMemo: validateMemo,
                    onChanged: onChanged,
                    onSubmit: onSubmit,
                    validateInput: validateInput,
                    clickSend: clickSend,
                    resetAssetsDropDown: resetAssetsDropDown,
                    sdkModel: widget.sdkModel,
                    item: item,
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
                                    flareController,
                                    "assets/animation/check.flr",
                                    "Checkmark"),
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
