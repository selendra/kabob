import 'package:wallet_apps/index.dart';
import 'package:http/http.dart' as http;

class AddAsset extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddAssetState();
  }
}

class AddAssetState extends State<AddAsset> {
  ModelAsset _modelAsset = ModelAsset();

  PostRequest _postRequest = PostRequest();

  GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _modelAsset.result = {};
    AppServices.noInternetConnection(globalKey);
    super.initState();
  }

  void addContract() async {}

  String validateAssetCode(String value) {
    if (_modelAsset.nodeAssetCode.hasFocus) {
      _modelAsset.responseAssetCode = instanceValidate.validateAsset(value);
      if (_modelAsset.responseAssetCode != null)
        _modelAsset.responseAssetCode += "asset code";
    }
    return _modelAsset.responseAssetCode;
  }

  String validateIssuer(String value) {
    if (_modelAsset.nodeIssuer.hasFocus) {
      _modelAsset.responseIssuer = instanceValidate.validateAsset(value);
      if (_modelAsset.responseIssuer != null)
        _modelAsset.responseIssuer += "asset issuer";
    }
    return _modelAsset.responseIssuer;
  }

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
    // enableButton(true);
    // Validate Form Of All Field
    // validateAllFieldNotEmpty();
  }

  void onSubmit() {
    if (_modelAsset.nodeAssetCode.hasFocus) {
      FocusScope.of(context).requestFocus(_modelAsset.nodeIssuer);
    } else if (_modelAsset.nodeIssuer.hasFocus) {
      if (_modelAsset.enable) submitAsset(context);
    }
  }

  void submitAsset(BuildContext context) async {
    try {
      final res = await http.get('http://localhost:3000/:service/contract/');

      print(res);
    } catch (e) {
      print(e.toString());
    }
    // dialogLoading(context); // Loading
    // try {
    //   _modelAsset.result = await _postRequest.addAsset(_modelAsset);
    //   Navigator.pop(context); // Close Loading
    //   if (_modelAsset.result.containsKey('message')) {
    //     await dialog(
    //         context,
    //         Text(_modelAsset.result['message']),
    //         Icon(Icons.done_outline,
    //             color: hexaCodeToColor(
    //               AppColors.lightBlueSky,
    //             )));
    //     _modelAsset.result.addAll({"dialog_name": "addAssetScreen"});
    //     Navigator.pop(context, _modelAsset.result);
    //   } else {
    //     await dialog(context, Text(_modelAsset.result['error']['message']),
    //         warningTitleDialog());
    //     Navigator.pop(context, {}); /* Disable Loading Process */
    //   }
    // } on SocketException catch (e) {
    //   await dialog(context, Text("${e.message}"), Text("Message"));
    //   snackBar(globalKey, e.message.toString());
    // } catch (e) {
    //   await dialog(context, Text(e.message.toString()), Text("Message"));
    // }
  }

  void popScreen() {
    Navigator.pop(context, {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: AddAssetBody(
          assetM: _modelAsset,
          validateAssetCode: validateAssetCode,
          validateIssuer: validateIssuer,
          popScreen: popScreen,
          onChanged: onChanged,
          onSubmit: onSubmit,
          submitAsset: submitAsset,
        ),
      ),
    );
  }
}