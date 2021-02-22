import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/m_import_acc.dart';
import 'package:wallet_apps/src/screen/main/import_account/import_acc_body.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_infor.dart';

class ImportAcc extends StatefulWidget {
  final CreateAccModel importAccModel;

  ImportAcc(this.importAccModel);
  static const route = '/import';

  @override
  State<StatefulWidget> createState() {
    return ImportAccState();
  }
}

class ImportAccState extends State<ImportAcc> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  ImportAccModel _importAccModel = ImportAccModel();

  PackageInfo _packageInfo;

  FirebaseRemote _firebaseRemote;

  bool status;
  int currentVersion;

  bool enable = false;

  String tempMnemonic;

  var snackBar;

  @override
  void initState() {
    newVersionNotifier(context);
    AppServices.noInternetConnection(globalKey);
    super.initState();
  }

  void newVersionNotifier(BuildContext context) async {
    try {
      // _firebaseRemote = FirebaseRemote(); /* Declare instance firebaseRemote */
      // await _firebaseRemote.initRemoteConfig();
      // _firebaseRemote.parseVersion = AppUtils.versionConverter(_firebaseRemote.latestVersion);
      // _packageInfo = await PackageInfo.fromPlatform();
      // currentVersion = AppUtils.versionConverter("${_packageInfo.version}+${_packageInfo.buildNumber}");
      // // await dialog(context, Text("${_packageInfo.version}+${_packageInfo.buildNumber}"), Text("Version"));
      // await StorageServices.fetchData("user_token").then((value) { // Checking IsLogged Value
      //   if (value != null){
      //     setState(() {
      //       status = value['isLoggedIn'];
      //     });
      //   }
      // });
      // if (_firebaseRemote.parseVersion > currentVersion) {
      //   await showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //         title: Center(
      //           child: textScale(
      //             text: "App update required",
      //             hexaColor: "#000000",
      //             fontWeight: FontWeight.w600
      //           ),
      //         ),
      //         content: Text(
      //           "${_firebaseRemote.content}",
      //           style: TextStyle(
      //             fontSize: 14.0
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //         actions: <Widget>[
      //           FlatButton(
      //             child: Text("Later"),
      //             onPressed: () {
      //               Navigator.of(context).pop(false);
      //             },
      //           ),
      //           FlatButton(
      //             child: Text("Update"),
      //             onPressed: () {
      //               _launchUrl(_firebaseRemote.iosAppId,_firebaseRemote.androidAppId);
      //               Navigator.of(context).pop(true);
      //             },
      //           )
      //         ],
      //       );
      //     }
      //   );
      //   tokenExpireChecker(context);
      // } else {
      //   tokenExpireChecker(context);
      // }
    } catch (e) {}
  }

  void _launchUrl(String _iosAppId, String _androidAppId) async {
    StoreRedirect.redirect(iOSAppId: _iosAppId, androidAppId: _androidAppId);
  }

  void navigatePage(BuildContext context) {
    /* Navigate Login Screen */
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  // void validateMnemonic() {
  //   tempMnemonic = _importAccModel.mnemonicCon.text;
  //   widget.importAccModel.mnemonicList = tempMnemonic.split(' ');
  //   if (widget.importAccModel.mnemonicList.length == 12) {
  //     print("Equal");
  //     setState(() {
  //       enable = true;
  //     });
  //   }
  //   // Validate User Input Less Than 12 Words And Greater Than 12 Words To Disable Button
  //   else if (widget.importAccModel.mnemonicList.length < 12 ||
  //       widget.importAccModel.mnemonicList.length > 12) {
  //     print("Less or greater");
  //     if (enable) {
  //       setState(() {
  //         enable = false;
  //       });
  //     }
  //   }
  //   print("Button $enable");
  //   print("length ${widget.importAccModel.mnemonicList.length}");
  //   print(widget.importAccModel.mnemonicList);
  // }

  String onChanged(String value) {
    validateMnemonic(value).then((value) {
      setState(() {
        enable = value;
      });
    });
  }

  Future<bool> validateMnemonic(String mnemonic) async {
    final res =
        await widget.importAccModel.sdk.api.keyring.validateMnemonic(mnemonic);
    print(res);
    return res;
  }

  void clearInput() {
    _importAccModel.mnemonicCon.clear();
    setState(() {
      enable = false;
    });
  }

  void onSubmit() async => await submit();

  Future<void> submit() async {
    validateMnemonic(_importAccModel.mnemonicCon.text).then((value) async {
      if (value) {
        setState(() {
          widget.importAccModel.mnemonic = _importAccModel.mnemonicCon.text;
        });
        await Navigator.pushNamed(context, ImportUserInfo.route);
        clearInput();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: ImportAccBody(
            importAccModel: _importAccModel,
            onChanged: onChanged,
            onSubmit: onSubmit,
            clearInput: clearInput,
            enable: enable,
            submit: submit,
          ),
        ) //welcomeBody(context, navigatePage),
        );
  }
}
