import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/fmt.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';
import 'package:wallet_apps/src/screen/home/menu/account.dart';
import 'package:wallet_apps/src/screen/main/confirm_mnemonic.dart';
import 'package:wallet_apps/src/screen/main/contents_backup.dart';
import 'package:wallet_apps/src/screen/main/import_account/import_acc.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_infor.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    _createAccModel.sdk = WalletSDK();
    _createAccModel.keyring = Keyring();
    _initApi();
    super.initState();
  }

  Future<void> _initApi() async {
    await FlutterWebviewPlugin().reload();

    await _createAccModel.keyring.init();
    await _createAccModel.sdk.init(_createAccModel.keyring);

    _createAccModel.sdkReady = true;

    if (_createAccModel.sdkReady) {
      connectNode();
    }
  }

  Future<void> connectNode() async {
    print('connectNode');
    final node = NetworkParams();

    node.name = 'Indranet hosted By Selendra';
    node.endpoint = 'wss://rpc-testnet.selendra.org';
    node.ss58 = 42;
    print(node.endpoint);

    final res = await _createAccModel.sdk.api
        .connectNode(_createAccModel.keyring, [node]);

    print('resConnectNode $res');
    setState(() {});
    if (res != null) {
      print('res null');
      setState(() {
        _createAccModel.apiConnected = true;

        _subscribeBalance();
        callContract();
      });
    } else {
      print('res null');
    }
  }

  Future<void> _subscribeBalance() async {
    if (_createAccModel.keyring.keyPairs.isNotEmpty) {
      print('subscribe');
      final channel = await _createAccModel.sdk.api.account
          .subscribeBalance(_createAccModel.keyring.current.address, (res) {
        setState(() {
          _createAccModel.balance = res;
          _createAccModel.mBalance =
              Fmt.balance(_createAccModel.balance.freeBalance, 18);
          //print(mBalance);
        });
      });
      setState(() {
        _createAccModel.msgChannel = channel;
        print('Channel $channel');
      });
    }
  }

  Future<void> callContract() async {
    await _createAccModel.sdk.api.callContract();

    if (_createAccModel.keyring.keyPairs.isNotEmpty) {
      _balanceOf(_createAccModel.keyring.keyPairs[0].address,
          _createAccModel.keyring.keyPairs[0].address);
      _totalSupply();
    }
  }

  Future<void> _totalSupply() async {
    try {
      final res = await _createAccModel.sdk.api.totalSupply(
        _createAccModel.keyring.keyPairs[0].address,
      );
      print(res.toString());
      print(res['output']);
      if (res != null) {
        setState(() {
          _createAccModel.kpiSupply = BigInt.parse(res['output']).toString();
        });
      }
    } catch (e) {
      print(e.toString());
      await dialog(context, Text(e.toString()), Text('Opps!!'));
    }
  }

  Future<void> _balanceOf(String from, String who) async {
    final res = await _createAccModel.sdk.api.balanceOf(from, who);
    if (res != null) {
      setState(() {
        _createAccModel.kpiBalance = BigInt.parse(res['output']).toString();
      });
    }
  }

  void unsubsribeBalance(String _msgChannel) {
    if (_msgChannel != null) {
      _createAccModel.sdk.api.unsubscribeMessage(_msgChannel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builder, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<WalletProvider>(
                create: (_) => WalletProvider(),
              ),
              ChangeNotifierProvider<ContractProvider>(
                create: (_) => ContractProvider(),
              ),
            ],
            child: MaterialApp(
              initialRoute: '/',
              title: 'Kaabop',
              theme: AppStyle.myTheme(),
              routes: {
                MySplashScreen.route: (_) => MySplashScreen(_createAccModel),
                ContentsBackup.route: (_) => ContentsBackup(_createAccModel),
                ImportUserInfo.route: (_) => ImportUserInfo(_createAccModel),
                ConfirmMnemonic.route: (_) => ConfirmMnemonic(_createAccModel),
                Home.route: (_) => Home(_createAccModel),
                ImportAcc.route: (_) => ImportAcc(_createAccModel),
                Account.route: (_) =>
                    Account(_createAccModel.sdk, _createAccModel.keyring),
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
