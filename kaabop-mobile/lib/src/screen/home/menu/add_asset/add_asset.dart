import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

class AddAsset extends StatefulWidget {
  final CreateAccModel sdkModel;
  AddAsset(this.sdkModel);
  static const route = '/addasset';
  @override
  State<StatefulWidget> createState() {
    return AddAssetState();
  }
}

class AddAssetState extends State<AddAsset> {
  ModelAsset _modelAsset = ModelAsset();


  FlareControls _flareController = FlareControls();

  GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _modelAsset.result = {};
    _modelAsset.match = false;
    AppServices.noInternetConnection(globalKey);
    initContract();
    super.initState();
  }

  void addContract() async {}



  Future<bool> validateAddress(String address) async {
    final res = await widget.sdkModel.sdk.api.keyring.validateAddress(address);
    return res;
  }

  // String validateIssuer(String value) {
  //   if (_modelAsset.nodeIssuer.hasFocus) {
  //     _modelAsset.responseIssuer = instanceValidate.validateAsset(value);
  //     if (_modelAsset.responseIssuer != null)
  //       _modelAsset.responseIssuer += "asset issuer";
  //   }
  //   return _modelAsset.responseIssuer;
  // }

  void validateAllFieldNotEmpty() {
    // Validator 1 : All Field Not Empty
    if (_modelAsset.controllerAssetCode.text.isNotEmpty &&
        _modelAsset.controllerIssuer.text.isNotEmpty) {
      validateAllFieldNoError();
    } else if (_modelAsset.enable)
      enableButton(false); // Disable Button If All Field Not Empty
  }

  void validateAllFieldNoError() {
    if (_modelAsset.responseAssetCode == null &&
        _modelAsset.responseIssuer == null) {
      enableButton(true); // Enable Button If All Field Not Empty
    } else if (_modelAsset.enable)
      enableButton(false); // Disable Button If All Field Not Empty
  }

  void enableButton(bool enable) {
    setState(() {
      _modelAsset.enable = enable;
    });
  }

  void onChanged(String textChange) {
    _modelAsset.formStateAsset.currentState.validate();
    enableButton(true);
  }

  void addAsset() async {
    dialogLoading(context);
    await _contractSymbol();
    await _getHashBySymbol().then((value) async {
      await _balanceOfByPartition();
    });
    await StorageServices.saveBool('KMPI', true);
    enableAnimation();
  }

  void addAssetInSearch() async{
    await _contractSymbol();
    await _getHashBySymbol().then((value) async {
      await _balanceOfByPartition();
    });
    setPortfolio();
    await StorageServices.saveBool('KMPI', true);
    Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
  }

  Future<void> initContract() async {
    await widget.sdkModel.sdk.api.callContract().then((value) {
      widget.sdkModel.contractModel.pContractAddress = value;
    });
  }

  Future<void> _contractSymbol() async {
    try {
      final res = await widget.sdkModel.sdk.api
          .contractSymbol(widget.sdkModel.keyring.keyPairs[0].address);
      if (res != null) {
        setState(() {
          widget.sdkModel.contractModel.pTokenSymbol = res[0];
        });
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> _getHashBySymbol() async {

    try {
      final res = await widget.sdkModel.sdk.api.getHashBySymbol(
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.contractModel.pTokenSymbol,
      );

      if (res != null) {
        widget.sdkModel.contractModel.pHash = res;
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> _balanceOfByPartition() async {
    try {
      //print(widget.sdkModel.keyring.keyPairs[0].address);
      //print(widget.sdkModel.contractModel.pHash);

      final res = await widget.sdkModel.sdk.api.balanceOfByPartition(
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.contractModel.pHash,
      );

      setState(() {
        widget.sdkModel.contractModel.pBalance = BigInt.parse(res['output']).toString();
      });
    } catch (e) {
      //print(e.toString());
    }
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

    walletProvider.availableToken.add({
      'symbol': widget.sdkModel.nativeSymbol,
      'balance': widget.sdkModel.nativeBalance,
    });
 
   Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  }


  // void onSubmit() {
  //   if (_modelAsset.nodeAssetCode.hasFocus) {
  //     FocusScope.of(context).requestFocus(_modelAsset.nodeIssuer);
  //   } else if (_modelAsset.nodeIssuer.hasFocus) {
  //     if (_modelAsset.enable) submitAsset(context);
  //   }
  // }

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _modelAsset.added = true;
    });
    _flareController.play('Checkmark');
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pop(context);
    });
  }

  void submitSearch() async {
    setState(() {
      _modelAsset.loading = true;
    });
    await StorageServices.readBool('KMPI').then((value) async {
      if (!value) {
        addAssetInSearch();
      } else {
        setState(() {
          _modelAsset.loading = false;
        });
        await dialog(
            context, Text('This asset is already added!'), Text('Asset Added'));
      }
    });
  }

  void submitAsset() async {
    setState(() {
      _modelAsset.loading = true;
    });
    await StorageServices.readBool('KMPI').then((value) async {
      if (!value) {
        await validateAddress(_modelAsset.controllerAssetCode.text)
            .then((value) async {
          //print(value);
          if (value) {
            if (_modelAsset.controllerAssetCode.text ==
                widget.sdkModel.contractModel.pContractAddress) {
              setState(() {
                _modelAsset.match = true;
                _modelAsset.loading = false;
              });

              //print(_modelAsset.match);
            } else {
              setState(() {
                _modelAsset.loading = false;
                _modelAsset.controllerAssetCode.text = '';
              });
              await dialog(context, Text('Failed to find asset by address.'),
                  Text('Asset not found'));
            }
          } else {
            setState(() {
              _modelAsset.loading = false;
            });
            await dialog(context, Text('Please fill in a valid address!'),
                Text('Invalid Address'));
          }
        });
      } else {
        setState(() {
          _modelAsset.loading = false;
        });
        await dialog(
            context, Text('This asset is already added!'), Text('Asset Added'));
      }
    });
  }

  void qrRes(String value) {
    if (value != null) {
      setState(() {
        _modelAsset.controllerAssetCode.text = value;
        _modelAsset.enable = true;
      });
    }
  }

  void popScreen() {
    Navigator.pop(context, {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            AddAssetBody(
              assetM: _modelAsset,
              popScreen: popScreen,
              onChanged: onChanged,
              onSubmit: null,
              submitAsset: submitAsset,
              addAsset: addAsset,
              submitSearch: submitSearch,
              sdkModel: widget.sdkModel,
              qrRes: qrRes,
            ),
            _modelAsset.added == false
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
