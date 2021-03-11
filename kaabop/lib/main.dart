import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';
import 'package:wallet_apps/src/screen/check_in/check_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Catch Error During Callback
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<WalletProvider>(
      create: (context) => WalletProvider(),
    ),
  ], child: App()));
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
    await _createAccModel.keyring.init();
    await FlutterWebviewPlugin().reload();
    await _createAccModel.sdk.init(_createAccModel.keyring);

    _createAccModel.sdkReady = true;

    if (_createAccModel.sdkReady) {
      connectNode();
    }
  }

  Future<void> connectNode() async {
    final node = NetworkParams();

    node.name = AppConfig.nodeName;
    node.endpoint = AppConfig.nodeEndpoint;
    node.ss58 = AppConfig.ss58;

    final res = await _createAccModel.sdk.api.connectNode(
      _createAccModel.keyring,
      [node],
    );

    setState(() {});
    if (res != null) {
      setState(() {
        _createAccModel.apiConnected = true;
      });
      await readContract();
      await readAtd();
      initContract();
      getChainDecimal();
      _subscribeBalance();
    }
  }

  Future<void> initAttendant() async {
    await _createAccModel.sdk.api.initAttendant();
    getToken();
  }

  Future<void> getToken() async {
    final res = await _createAccModel.sdk.api
        .getAToken(_createAccModel.keyring.keyPairs[0].address);

    setState(() {
      _createAccModel.contractModel.attendantM.aBalance =
          BigInt.parse(res).toString();
      _createAccModel.atdReady = true;
    });
  }

  Future<void> readAtd() async {
    await StorageServices.readBool(
      _createAccModel.contractModel.attendantM.aSymbol,
    ).then((value) async {
      if (value) {
        _createAccModel.contractModel.attendantM.isAContain = value;
        initAttendant();
      }
    });
  }

  Future<void> getChainDecimal() async {
    final res = await _createAccModel.sdk.api.getChainDecimal();
    _createAccModel.chainDecimal = res.toString();
  }

  Future<void> _subscribeBalance() async {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.clearPortfolio();
    if (_createAccModel.keyring.keyPairs.isNotEmpty) {
      final channel = await _createAccModel.sdk.api.account
          .subscribeBalance(_createAccModel.keyring.current.address, (res) {
        setState(() {
          _createAccModel.balance = res;
          _createAccModel.nativeBalance = Fmt.balance(
            _createAccModel.balance.freeBalance,
            18,
          );
          _createAccModel.dataReady = true;
        });
      });
      setState(() {
        _createAccModel.msgChannel = channel;
      });
    }
  }

  Future<void> readContract() async {
    await StorageServices.readBool(_createAccModel.contractModel.pTokenSymbol)
        .then((value) async {
      if (value) {
        setState(() {
          _createAccModel.contractModel.isContain = value;
        });
      }
    });
  
  }

  Future<void> initContract() async {
    if (_createAccModel.contractModel.isContain) {
      await _createAccModel.sdk.api.callContract().then((value) {
        _createAccModel.contractModel.pContractAddress = value;
      });
      if (_createAccModel.keyring.keyPairs.isNotEmpty) {
        await _contractSymbol();
        await _getHashBySymbol().then((value) async {
          _balanceOfByPartition();
        });
      }
    }
  }

  Future<void> _contractSymbol() async {
    try {
      final res = await _createAccModel.sdk.api
          .contractSymbol(_createAccModel.keyring.keyPairs[0].address);
      if (res != null) {
        setState(() {
          _createAccModel.contractModel.pTokenSymbol = res[0];
        });
      }
    } catch (e) {}
  }

  Future<void> _getHashBySymbol() async {
    try {
      final res = await _createAccModel.sdk.api.getHashBySymbol(
        _createAccModel.keyring.keyPairs[0].address,
        _createAccModel.contractModel.pTokenSymbol,
      );

      if (res != null) {
        _createAccModel.contractModel.pHash = res;
      }
    } catch (e) {}
  }

  Future<void> _balanceOfByPartition() async {
    try {
      final res = await _createAccModel.sdk.api.balanceOfByPartition(
        _createAccModel.keyring.keyPairs[0].address,
        _createAccModel.keyring.keyPairs[0].address,
        _createAccModel.contractModel.pHash,
      );

      setState(() {
        _createAccModel.contractModel.pBalance =
            BigInt.parse(res['output']).toString();
        _createAccModel.kmpiReady = true;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (builder, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              initialRoute: '/',
              title: AppText.appName,
              theme: AppStyle.myTheme(),
              routes: {
                Home.route: (_) => Home(_createAccModel),
                CheckIn.route: (_) => CheckIn(_createAccModel),
                Account.route: (_) => Account(_createAccModel),
                AddAsset.route: (_) => AddAsset(_createAccModel),
                ImportAcc.route: (_) => ImportAcc(_createAccModel),
                ReceiveWallet.route: (_) => ReceiveWallet(_createAccModel),
                MySplashScreen.route: (_) => MySplashScreen(_createAccModel),
                ContentsBackup.route: (_) => ContentsBackup(_createAccModel),
                ImportUserInfo.route: (_) => ImportUserInfo(_createAccModel),
                ConfirmMnemonic.route: (_) => ConfirmMnemonic(_createAccModel),
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
            );
          },
        );
      },
    );
  }
}
