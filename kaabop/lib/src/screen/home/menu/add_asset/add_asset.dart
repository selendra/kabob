import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class AddAsset extends StatefulWidget {
  static const route = '/addasset';
  @override
  State<StatefulWidget> createState() {
    return AddAssetState();
  }
}

class AddAssetState extends State<AddAsset> {
  final ModelAsset _modelAsset = ModelAsset();

  final FlareControls _flareController = FlareControls();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  FlareControls flareController = FlareControls();
  String _tokenSymbol = '', initialValue = 'Ethereum';

  @override
  void initState() {
    _modelAsset.result = {};
    _modelAsset.match = false;
    AppServices.noInternetConnection(globalKey);

    super.initState();
  }

  Future<bool> validateEtherAddress(String address) async {
    final res = await ApiProvider.sdk.api.validateEtherAddr(address);
    return res;
  }

  Future<bool> validateAddress(String address) async {
    final res = await ApiProvider.sdk.api.keyring.validateAddress(address);
    return res;
  }

  void validateAllFieldNotEmpty() {
    // Validator 1 : All Field Not Empty
    if (_modelAsset.controllerAssetCode.text.isNotEmpty &&
        _modelAsset.controllerIssuer.text.isNotEmpty) {
      validateAllFieldNoError();
    } else if (_modelAsset.enable) {
      enableButton(false);
    } // Disable Button If All Field Not Empty
  }

  void validateAllFieldNoError() {
    if (_modelAsset.responseAssetCode == null &&
        _modelAsset.responseIssuer == null) {
      enableButton(true); // Enable Button If All Field Not Empty
    } else if (_modelAsset.enable) {
      enableButton(false);
    } // Disable Button If All Field Not Empty
  }

  // ignore: avoid_positional_boolean_parameters
  void enableButton(bool enable) {
    setState(() {
      _modelAsset.enable = enable;
    });
  }

  Future<void> addAsset() async {
    dialogLoading(context);
    if (_modelAsset.match) {
      Provider.of<ContractProvider>(context, listen: false)
          .addToken(ContractProvider().kmpi.symbol, context);
    } else {
      print(initialValue);
      Provider.of<ContractProvider>(context, listen: false).addToken(
        _tokenSymbol,
        context,
        network: initialValue,
        contractAddr: _modelAsset.controllerAssetCode.text,
      );
    }
    await enableAnimation();
  }

  Future<void> submitAsset() async {
    setState(() {
      _modelAsset.loading = true;
    });
    final resEther =
        await validateEtherAddress(_modelAsset.controllerAssetCode.text);
    final res = await validateAddress(_modelAsset.controllerAssetCode.text);

    if (res || resEther) {
      if (res) {
        if (_modelAsset.controllerAssetCode.text == AppConfig.kmpiAddr) {
          setState(() {
            _modelAsset.match = true;
            _modelAsset.loading = false;
          });
        }
      } else {
        if (initialValue == 'Ethereum') {
          searchEtherContract();
        } else {
          final res =
              await Provider.of<ContractProvider>(context, listen: false)
                  .query(_modelAsset.controllerAssetCode.text, 'symbol', []);
          if (res != null) {
            setState(() {
              _tokenSymbol = res[0].toString();
              _modelAsset.loading = false;
            });
          }
        }
      }
    } else {
      await dialog(context, const Text('Invalid token contract address!'),
          const Text('Opps'));
      setState(() {
        _modelAsset.loading = false;
      });
    }
  }

  Future<void> searchEtherContract() async {
    try {
      final res = await Provider.of<ContractProvider>(context, listen: false)
          .queryEther(_modelAsset.controllerAssetCode.text, 'symbol', []);
      print(res[0]);
      if (res != null) {
        setState(() {
          _tokenSymbol = res[0].toString();
          _modelAsset.loading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void onSubmit() {
    if (_modelAsset.formStateAsset.currentState.validate()) {
      submitAsset();
    }
  }

  String onChanged(String textChange) {
    if (_modelAsset.formStateAsset.currentState.validate()) {
      enableButton(true);
    } else {
      enableButton(false);
    }

    return null;
  }

  void onChangeDropDown(String network) {
    setState(() {
      initialValue = network;
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

  Future<void> enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _modelAsset.added = true;
    });
    flareController.play('Checkmark');

    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            AddAssetBody(
              assetM: _modelAsset,
              initialValue: initialValue,
              onChangeDropDown: onChangeDropDown,
              addAsset: addAsset,
              popScreen: popScreen,
              onChanged: onChanged,
              qrRes: qrRes,
              tokenSymbol: _tokenSymbol,
              onSubmit: onSubmit,
              submitAsset: submitAsset,
            ),
            if (_modelAsset.added == false)
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
                      child: CustomAnimation.flareAnimation(_flareController,
                          "assets/animation/check.flr", "Checkmark"),
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
