import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:polkawallet_sdk/api/types/balanceData.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/service/webViewRunner.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/contact_book/contact_book.dart';
import 'package:wallet_apps/src/screen/home/menu/account.dart';
import 'package:wallet_apps/src/screen/main/confirm_mnemonic.dart';
import 'package:wallet_apps/src/screen/main/contents_backup.dart';
import 'package:wallet_apps/src/screen/main/create_mnemoic.dart';
import 'package:wallet_apps/src/screen/main/import_account/import_acc.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_infor.dart';

void main() async {
  // Avoid Error, " accessed before the binding was initialized "
  WidgetsFlutterBinding.ensureInitialized();

  // Enable Debug Paint
  // debugPaintSizeEnabled = true;

  // Keep Screen Portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Catch Error During Callback
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  runApp(App()
      // DevicePreview(
      //   enabled: true,
      //   builder: (context) => App(),
      // )
      );
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {

  CreateAccModel _createAccModel = CreateAccModel();

  // final Keyring keyring = Keyring();
  // final WalletSDK sdk = WalletSDK();
  BalanceData _balance;
  bool _sdkReady = false;
  bool _apiConnected = false;
  String mBalance = '0';
  String kpiBalance = '0';
  String _msgChannel;

  @override
  void initState() {
    print("Hello my App");
    _createAccModel.keyring = Keyring();
    _createAccModel.sdk = WalletSDK();
    _initApi();
    super.initState();
  }

  Future<void> _initApi() async {

    print("init");
    await FlutterWebviewPlugin().reload();

    await _createAccModel.keyring.init();

    await _createAccModel.sdk.init(_createAccModel.keyring);

    _sdkReady = true;
    
    print("My sdk $_sdkReady");
    if (_sdkReady) {
      connectNode();
    }
    // try {
    // } on SocketException catch (e){
    //   print("Init api sochet error $e");
    // } catch (e) {
    //   print("Init api error $e");
    // }
  }

  Future<void> _initContract() async {
    try {
      await GetRequest().initContract().then((value) {
        print(value);
        print(_createAccModel.keyring.keyPairs[0].toJson());
        print('address: ${_createAccModel.keyring.keyPairs[0].address}');
        print('pubKey: ${_createAccModel.keyring.keyPairs[0].pubKey}');
        _balanceOf(_createAccModel.keyring.keyPairs[0].address, _createAccModel.keyring.keyPairs[0].address);
      });
    } catch (e) {
      print("My exception $e");
    }
  }

  Future<void> connectNode() async {
    try {
      final node = NetworkParams();

      node.name = 'Indranet hosted By Selendra';
      node.endpoint = 'wss://rpc-testnet.selendra.org';

      node.ss58 = 0;
      final res = await _createAccModel.sdk.api.connectNode(_createAccModel.keyring, [node]);

      print('res $res');
      setState(() {});
      if (res != null) {
        setState(() {
          _apiConnected = true;

          _subscribeBalance();
          // _initContract();

          //_importFromMnemonic();
        });
        // _importFromMnemonic();

      }
    } catch (e){
      print("Connect node error $e");
    }
  }

  Future<void> _balanceOf(String from, String who) async {
    await GetRequest().balanceOf(from, who).then((value) {
      print(value);
      if (value != null) {
        print(value);
        setState(() {
          kpiBalance = value;
        });
      }
    });
  }

  // Future<void> _importFromMnemonic() async {
  //   try {
  //     final json = await sdk.api.keyring.importAccount(
  //       keyring,
  //       keyType: KeyType.mnemonic,
  //       key:
  //           'wing know chapter eight shed lens mandate lake twenty useless bless glory',
  //       name: 'Chay',
  //       password: '123456',
  //     );
  //     final acc = await sdk.api.keyring.addAccount(
  //       keyring,
  //       keyType: KeyType.mnemonic,
  //       acc: json,
  //       password: '123456',
  //     );
  //     // if (acc != null) {
  //     //   await dialog(context, Text("You haved imported successfully"),
  //     //       Text('Congratulation'),
  //     //       action: FlatButton(
  //     //           onPressed: () {
  //     //             Navigator.pushReplacementNamed(context, Home.route);
  //     //           },
  //     //           child: Text('Continue')));
  //     // }
  //     print(acc.address);
  //     print(acc.name);
  //   } catch (e) {
  //     print("Hello error $e");
  //   }
  // }

  Future<void> _subscribeBalance() async {
    print('subscribe');
    final channel =
        await _createAccModel.sdk.api.account.subscribeBalance(_createAccModel.keyring.current.address, (res) {
      setState(() {
        _balance = res;
        mBalance = int.parse(_balance.freeBalance).toString();
        print(mBalance);
      });
    });

    setState(() {
      _msgChannel = channel;
      print('Channel $channel');
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builder, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return Provider(
              child: MaterialApp(
            initialRoute: '/',
            title: 'Kaabop',
            theme: AppStyle.myTheme(),
            routes: {
              // '/': (_) => ContactBook(),
              MySplashScreen.route: (_) => MySplashScreen(_createAccModel),
              ContentsBackup.route: (_) => ContentsBackup(_createAccModel),
              ImportUserInfo.route: (_) => ImportUserInfo(_createAccModel),
              ConfirmMnemonic.route: (_) => ConfirmMnemonic(_createAccModel),
              // ContactBook.route: (_) => ContactBook(_createAccModel),
              Home.route: (_) => Home(_createAccModel.sdk, _createAccModel.keyring, _apiConnected, mBalance, _msgChannel, kpiBalance),
              ImportAcc.route: (_) => ImportAcc(_createAccModel),
              Account.route: (_) => Account(_createAccModel.sdk, _createAccModel.keyring),
            },
            builder: (context, widget) => ResponsiveWrapper.builder(
                BouncingScrollWrapper.builder(context, widget),
                maxWidth: 1200,
                minWidth: 450,
                defaultScale: true,
                breakpoints: [
                  ResponsiveBreakpoint.autoScale(480, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
