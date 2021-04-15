import 'dart:math';
import 'dart:ui';
import 'package:flare_flutter/flare_controls.dart';
import 'package:intl/intl.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import 'package:wallet_apps/src/screen/home/asset_info/asset_info_c.dart';

class SubmitTrx extends StatefulWidget {
  final String _walletKey;
  final String asset;
  final List<dynamic> _listPortfolio;
  final bool enableInput;

  const SubmitTrx(
      // ignore: avoid_positional_boolean_parameters
      this._walletKey,
      // ignore: avoid_positional_boolean_parameters
      this.enableInput,
      this._listPortfolio,
      {this.asset});
  @override
  State<StatefulWidget> createState() {
    return SubmitTrxState();
  }
}

class SubmitTrxState extends State<SubmitTrx> {
  final ModelScanPay _scanPayM = ModelScanPay();

  FlareControls flareController = FlareControls();

  AssetInfoC c = AssetInfoC();

  bool disable = false;
  final bool _loading = false;

  @override
  void initState() {
    widget.asset != null
        ? _scanPayM.asset = widget.asset
        : _scanPayM.asset = "SEL";

    AppServices.noInternetConnection(_scanPayM.globalKey);

    _scanPayM.controlReceiverAddress.text = widget._walletKey;
    _scanPayM.portfolio = widget._listPortfolio;

    super.initState();
  }

  // List<Map<String, String>> nativeList = [
  //   {'asset_code': 'SEL'},
  //   {'asset_code': 'DOT'},
  //   {'asset_code': 'KMPI'},
  //   {'asset_code': 'BNB'},
  //   {'asset_code': 'AYF'}
  // ];

  void removeAllFocus() {
    _scanPayM.nodeAmount.unfocus();
    _scanPayM.nodeMemo.unfocus();
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

  Future<bool> validateAddress(String address) async {
    final res = await ApiProvider.sdk.api.keyring.validateAddress(address);
    return res;
  }

  String onChanged(String value) {
    if (_scanPayM.nodeReceiverAddress.hasFocus) {
    } else if (_scanPayM.nodeAmount.hasFocus) {
      _scanPayM.formStateKey.currentState.validate();
      if (_scanPayM.formStateKey.currentState.validate()) {
        enableButton();
      } else {
        setState(() {
          _scanPayM.enable = false;
        });
      }
    }
    return value;
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
    if (_scanPayM.controlAmount.text != '' && _scanPayM.asset != null) {
      setState(() => _scanPayM.enable = true);
    } else if (_scanPayM.enable) {
      setState(() => _scanPayM.enable = false);
    }
  }

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
      disable = true;
    });
    flareController.play('Checkmark');

    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  void popScreen() {
    /* Close Current Screen */
    Navigator.pop(context, null);
  }

  void resetAssetsDropDown(String data) {
    setState(() {
      _scanPayM.asset = data;
    });
    enableButton();
  }

  Future<void> sendTxKmpi(String to, String pass, String value) async {
    dialogLoading(
      context,
      content: 'Please wait! This might take a little bit longer',
    );

    try {
      final res = await ApiProvider.sdk.api.keyring.contractTransfer(
        ApiProvider.keyring.keyPairs[0].pubKey,
        to,
        value,
        pass,
        Provider.of<ContractProvider>(context, listen: false).kmpi.hash,
      );

      if (res['status'] != null) {
        Provider.of<ContractProvider>(context, listen: false)
            .fetchKmpiBalance();

        saveTxHistory(TxHistory(
          date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
          symbol: 'KMPI',
          destination: to,
          sender: ApiProvider.keyring.current.address,
          org: 'KOOMPI',
          amount: value.trim(),
        ));

        await enableAnimation();
      }
    } catch (e) {
      Navigator.pop(context);
      await dialog(context, Text(e.message.toString()), const Text('Opps!!'));
    }
  }

  Future<String> sendTx(String target, String amount, String pin) async {
    dialogLoading(context);
    String mhash;
    final sender = TxSenderData(
      ApiProvider.keyring.current.address,
      ApiProvider.keyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);
    final chainDecimal =
        Provider.of<ApiProvider>(context, listen: false).nativeM.chainDecimal;
    try {
      final hash = await ApiProvider.sdk.api.tx.signAndSend(
          txInfo,
          [
            target,
            Fmt.tokenInt(
              amount.trim(),
              int.parse(chainDecimal),
            ).toString(),
          ],
          pin,
          onStatusChange: (status) async {});

      if (hash != null) {
        saveTxHistory(TxHistory(
          date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
          symbol: 'SEL',
          destination: target,
          sender: ApiProvider.keyring.current.address,
          org: 'SELENDRA',
          amount: amount.trim(),
        ));

        await enableAnimation();
      }
    } catch (e) {
      // print(e.message);
      Navigator.pop(context);
      await dialog(context, Text(e.message.toString()), const Text("Opps"));
    }

    return mhash;
  }

  Future<String> sendTxDot(String target, String amount, String pin) async {
    dialogLoading(context);
    String mhash;
    final sender = TxSenderData(
      ApiProvider.keyring.current.address,
      ApiProvider.keyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);

    try {
      final hash = await ApiProvider.sdk.api.tx.signAndSendDot(
          txInfo, [target, pow(double.parse(amount) * 10, 12)], pin,
          onStatusChange: (status) async {});

      if (hash != null) {
        // saveTxHistory(TxHistory(
        //   date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
        //   symbol: 'SEL',
        //   destination: target,
        //   sender: ApiProvider.keyring.current.address,
        //   org: 'SELENDRA',
        //   amount: amount.trim(),
        // ));

        await enableAnimation();
      }
    } catch (e) {
      // print(e.message);
      Navigator.pop(context);
      await dialog(context, Text(e.message.toString()), const Text("Opps"));
    }

    return mhash;
  }

  Future<void> clickSend() async {
    if (_scanPayM.formStateKey.currentState.validate()) {
      /* Send payment */

      await Future.delayed(const Duration(milliseconds: 100), () {
        // Unfocus All Field Input
        unFocusAllField();
      });

      await dialogBox().then((value) async {
        switch (_scanPayM.asset) {
          case "SEL":
            sendTx(
              _scanPayM.controlReceiverAddress.text,
              _scanPayM.controlAmount.text,
              value,
            );
            break;
          case "KMPI":
            sendTxKmpi(
              _scanPayM.controlReceiverAddress.text,
              value,
              _scanPayM.controlAmount.text,
            );
            break;
          case "DOT":
            sendTxDot(
              _scanPayM.controlReceiverAddress.text,
              _scanPayM.controlAmount.text,
              value,
            );
            break;
          case "SEL (BEP-20)":
            final chainDecimal = await ContractProvider()
                .query(AppConfig.bscMainnetAddr, 'decimals', []);
            if (chainDecimal != null) {
              sendTxAYF(
                AppConfig.bscMainnetAddr,
                chainDecimal[0].toString(),
                _scanPayM.controlReceiverAddress.text,
                _scanPayM.controlAmount.text,
                value,
              );
            }
            break;
          case "BNB":
            sendTxBnb(
              _scanPayM.controlReceiverAddress.text,
              _scanPayM.controlAmount.text,
              value,
            );
            break;
          default:
            final contractAddr =
                ContractProvider().findContractAddr(_scanPayM.asset);
            final chainDecimal =
                await ContractProvider().query(contractAddr, 'decimals', []);
            sendTxAYF(
              contractAddr,
              chainDecimal[0].toString(),
              _scanPayM.controlReceiverAddress.text,
              _scanPayM.controlAmount.text,
              value,
            );
            break;
        }
      });
    }
  }

  Future<void> sendTxBnb(String reciever, String amount, String pin) async {
    dialogLoading(context);
    final contract = Provider.of<ContractProvider>(context, listen: false);
    try {
      final res = await getPrivateKey(pin);

      if (res != null) {
        final hash = await contract.sendTxBnb(res, reciever, amount);
        if (hash != null) {
          Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
          enableAnimation();
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      await dialog(context, Text(e.message.toString()), const Text("Opps"));
    }
  }

  Future<void> sendTxAYF(String contractAddr, String chainDecimal,
      String reciever, String amount, String pin) async {
    dialogLoading(context);
    final contract = Provider.of<ContractProvider>(context, listen: false);
    try {
      final res = await getPrivateKey(pin);
      if (res != null) {
        final hash = await contract.sendTxBsc(
          contractAddr,
          chainDecimal,
          res,
          reciever,
          amount,
        );

        if (hash != null) {
          Provider.of<ContractProvider>(context, listen: false).getBscBalance();
          enableAnimation();
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      await dialog(context, Text(e.message.toString()), const Text("Opps"));
    }
  }

  Future<String> getPrivateKey(String pin) async {
    String privateKey;
    final encrytKey = await StorageServices().readSecure('private');
    try {
      privateKey =
          await ApiProvider.keyring.store.decryptPrivateKey(encrytKey, pin);
    } catch (e) {
      await dialog(
        context,
        const Text('PIN verification failed !'),
        const Text("Opps"),
      );
    }

    return privateKey;
  }

  Future<void> saveTxHistory(TxHistory txHistory) async {
    await StorageServices.addTxHistory(txHistory, 'txhistory');
  }

  void unFocusAllField() {
    _scanPayM.nodeAmount.unfocus();
    _scanPayM.nodeMemo.unfocus();
    _scanPayM.nodeReceiverAddress.unfocus();
  }

  PopupMenuItem item(List list) {
    /* Display Drop Down List */
    return PopupMenuItem(
      value: list,
      child: Align(
        child: Text(
          list.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scanPayM.globalKey,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : BodyScaffold(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Consumer<WalletProvider>(
                    builder: (context, value, child) {
                      return SubmitTrxBody(
                        enableInput: widget.enableInput,
                        dialog: dialogBox,
                        scanPayM: _scanPayM,
                        onChanged: onChanged,
                        onSubmit: onSubmit,
                        clickSend: clickSend,
                        resetAssetsDropDown: resetAssetsDropDown,
                        list: value.listSymbol,
                      );
                    },
                  ),
                  if (_scanPayM.isPay == false)
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
