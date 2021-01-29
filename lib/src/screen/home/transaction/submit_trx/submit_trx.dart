import 'dart:math';
import 'package:flare_flutter/flare_controls.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_apps/src/screen/home/asset_info/asset_info_c.dart';

class SubmitTrx extends StatefulWidget {
  final String _walletKey;
  final List<dynamic> _listPortfolio;
  final bool enableInput;
  final WalletSDK sdk;
  final Keyring keyring;

  SubmitTrx(this._walletKey, this.enableInput, this._listPortfolio, this.sdk,
      this.keyring);
  @override
  State<StatefulWidget> createState() {
    return SubmitTrxState();
  }
}

class SubmitTrxState extends State<SubmitTrx> {
  ModelScanPay _scanPayM = ModelScanPay();

  FlareControls flareController = FlareControls();

  PostRequest _postRequest = PostRequest();

  Backend _backend = Backend();
  AssetInfoC c = AssetInfoC();

  bool disable = false;
  bool _loading = false;

  @override
  void initState() {
    _scanPayM.asset = "SEL";
    print(c.transferFrom);
    // _scanPayM.portfolio.add("KPI");

    AppServices.noInternetConnection(_scanPayM.globalKey);
    _scanPayM.controlReceiverAddress.text = widget._walletKey;
    _scanPayM.portfolio = widget._listPortfolio;
    super.initState();
  }

  void fetchIDs() async {
    await Provider.fetchUserIds();
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

  String validateWallet(String value) {
    if (_scanPayM.nodeAmount.hasFocus) {
      _scanPayM.responseAmount = instanceValidate.validateSendToken(value);
      enableButton();
      if (_scanPayM.responseAmount != null)
        return _scanPayM.responseAmount += "wallet";
    }
    return _scanPayM.responseWallet;
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
    setState(() {
      _scanPayM.isPay = true;
      disable = true;
    });
    flareController.play('Checkmark');
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pop(context, _backend.mapData);
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
    final pairs = await KeyringPrivateStore()
        .getDecryptedSeed('${widget.keyring.keyPairs[0].pubKey}', '$pass');
    if (pairs['seed'] == null) {
      await dialog(context, Text('Incorrect Password'), Text('Transfer'));
    } else {
      final res =
          await http.post('http://localhost:3000/:service/contract/transfer',
              headers: <String, String>{
                "content-type": "application/json",
              },
              body: jsonEncode(<String, dynamic>{
                "pair": pairs['seed'],
                "to": to,
                "value": '5',
              }));
      //  print(res);

      var resJson = json.decode(res.body);
      print(resJson['result']);
      if (resJson['result'] != null) {
        await dialog(context, Text('Your transaction was successful'),
            Text('Transaction Success'),
            action: FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Home.route, ModalRoute.withName('/'));
                },
                child: Text('Okay')));
      }
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> transferFrom() async {
    final pairs = await KeyringPrivateStore()
        .getDecryptedSeed('${widget.keyring.keyPairs[0].pubKey}', '123456');

    final res =
        await http.post('http://localhost:3000/:service/contract/transferfrom',
            headers: <String, String>{
              "content-type": "application/json",
            },
            body: jsonEncode(<String, dynamic>{
              "sender": pairs['seed'],
              "to": '5GuhfoxCt4BDns8wC44JPazpwijfxk2jFSdU8SqUa3YvnEVF',
              "value": 20,
            }));

    print(res);
  }

  Future<String> sendTx(String target, String amount, String pin) async {
    print('sendtx');
    String mhash;
    final sender = TxSenderData(
      widget.keyring.current.address,
      widget.keyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);
    try {
      final hash = await widget.sdk.api.tx.signAndSend(
        txInfo,
        [
          // params.to
          // _testAddressGav,
          target,
          // params.amount
          amount,
        ],
        pin,
        onStatusChange: (status) async {
          print(status);
          if (status == 'Broadcast') {
          } else if (status == 'Ready') {
            setState(() {
              _loading = false;
            });
            await dialog(context, Text('Your transaction was successful'),
                Text('Transaction Success'),
                action: FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Home.route, ModalRoute.withName('/'));
                    },
                    child: Text('Okay')));
          }
        },
      );

      //print('tx status: $_status');
      print('hash: $hash');
      setState(() {
        mhash = hash[0];
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _loading = false;
      });
      await dialog(context, Text("${e.toString()}"), Text("Opps"));
      // if (e != null) {
      //   // setState(() {
      //   //   _loading = false;
      //   // });
      // }
    }
    setState(() {
      _loading = false;
    });
    return mhash;
  }

  void clickSend() async {
    String pin;
    /* Send payment */
    // Navigator.push(context, MaterialPageRoute(builder: (contxt) => FillPin()));
    await Future.delayed(Duration(milliseconds: 100), () {
      // Unfocus All Field Input
      unFocusAllField();
    });

    await dialogBox().then((value) {
      pin = value;
      if (pin != null &&
          _scanPayM.controlAmount.text != null &&
          _scanPayM.controlReceiverAddress.text != null) {
        setState(() {
          _loading = true;
        });
        //print(pin);

        if (_scanPayM.asset == 'SEL') {
          int amount = int.parse(_scanPayM.controlAmount.text) * pow(10, 18);

          sendTx(_scanPayM.controlReceiverAddress.text, amount.toString(), pin);
        } else {
          transfer(_scanPayM.controlReceiverAddress.text, pin,
              _scanPayM.controlAmount.text);
        }
      } else {
        print('amount is null');
      }

      // print(_scanPayM.controlAmount.text);
      // print(_scanPayM.controlReceiverAddress.text);
    });
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
                      validateWallet: validateWallet,
                      validateAmount: validateAmount,
                      validateMemo: validateMemo,
                      onChanged: onChanged,
                      onSubmit: onSubmit,
                      validateInput: validateInput,
                      clickSend: clickSend,
                      resetAssetsDropDown: resetAssetsDropDown,
                      item: item,
                    ),
                    // _scanPayM.isPay == false
                    //     ? Container()
                    //     :  BackdropFilter(
                    // Fill Blur Background
                    // filter: ImageFilter.blur(
                    //   sigmaX: 5.0,
                    //   sigmaY: 5.0,
                    // ),
                    // child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Expanded(
                    //         child: CustomAnimation.flareAnimation(
                    //             flareController,
                    //             "assets/animation/check.flr",
                    //             "Checkmark"))
                    //   ],
                    // )),
                  ],
                ),
              ));
  }
}
