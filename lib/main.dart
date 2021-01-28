import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:polkawallet_sdk/api/types/balanceData.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wallet_apps/src/screen/home/menu/account.dart';
import 'package:wallet_apps/src/screen/main/import_account/import_acc.dart';

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
  final Keyring keyring = Keyring();
  final WalletSDK sdk = WalletSDK();
  BalanceData _balance;
  bool _sdkReady = false;
  bool _apiConnected = false;
  String mBalance = '0';
  String kpiBalance = '0';
  String _msgChannel;

  @override
  void initState() {
    _initApi();
    super.initState();
  }

  Future<void> _initApi() async {
    await keyring.init();

    await sdk.init(keyring);
    setState(() {
      _sdkReady = true;
    });
    if (_sdkReady) {
      connectNode();

      // getDecrypt();
    }
  }

  // void getDecrypt() async {
  //   final seed = await KeyringPrivateStore().getDecryptedSeed(
  //     '0xa2d1d33cc490d34ccc6938f8b30430428da815a85bf5927adc85d9e27cbbfc1a',
  //     '123456',
  //   );
  //   print('raw seed' + seed.toString());
  // }

  Future<void> _initContract() async {
    await GetRequest().initContract().then((value) {
      print(value);
      print(keyring.keyPairs[0].toJson());
      print('address: ${keyring.keyPairs[0].address}');
      print('pubKey: ${keyring.keyPairs[0].pubKey}');
      //final String pairs = jsonEncode(keyring.store.list);
      // print('address' + keyring.keyPairs[0].address);

      // print(pairs);
      // transfer();
    });
  }

  // Future<void> transfer() async {
  //   final String pairs = jsonEncode(keyring.store.list);
  //   final res =
  //       await http.post('http://localhost:3000/:service/contract/transfer',
  //           headers: <String, String>{
  //             "content-type": "application/json",
  //           },
  //           body: jsonEncode(<String, dynamic>{
  //             "pair": pairs,
  //             "to": '5GuhfoxCt4BDns8wC44JPazpwijfxk2jFSdU8SqUa3YvnEVF',
  //             "value": 1,
  //           }));
  //   print(res);
  // }

  Future<void> connectNode() async {
    final node = NetworkParams();

    node.name = 'Indracore';
    node.endpoint = 'wss://rpc-testnet.selendra.org';

    node.ss58 = 42;
    final res = await sdk.api.connectNode(keyring, [node]);

    print('res $res');
    if (res != null) {
      setState(() {
        _apiConnected = true;

        _subscribeBalance();
        _balanceOf(keyring.keyPairs[0].address, keyring.keyPairs[0].address);
        //_initContract();

        //_importFromMnemonic();
      });
      // _importFromMnemonic();

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
        await sdk.api.account.subscribeBalance(keyring.current.address, (res) {
      setState(() {
        _balance = res;
        mBalance = int.parse(_balance.freeBalance).toString();
        print(mBalance);
      });
    });

    setState(() {
      _msgChannel = channel;
      print('$channel');
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
                MySplashScreen.route: (_) => MySplashScreen(keyring),
                Home.route: (_) => Home(sdk, keyring, _apiConnected, mBalance,
                    _msgChannel, kpiBalance),
                ImportAcc.route: (_) => ImportAcc(sdk, keyring),
                Account.route: (_) => Account(sdk, keyring),
                ReceiveWallet.route: (_) =>
                    ReceiveWallet(sdk: sdk, keyring: keyring),
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
