import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';
import 'package:wallet_apps/src/screen/check_in/check_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Catch Error During Callback
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletProvider>(
          create: (context) => WalletProvider(),
        ),
        ChangeNotifierProvider<ApiProvider>(
          create: (context) => ApiProvider(),
        ),
        ChangeNotifierProvider<ContractProvider>(
          create: (context) => ContractProvider(),
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  final _createAccModel = CreateAccModel();

  @override
  void initState() {
    _createAccModel.sdk = WalletSDK();
    _createAccModel.keyring = Keyring();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initApi();
  }

  Future<void> initApi() async {
    Provider.of<ApiProvider>(context, listen: false).initApi().then((value) {
      Provider.of<ApiProvider>(context, listen: false)
          .connectNode()
          .then((value) {
        if (value != null) {
          setState(() {
            _createAccModel.apiConnected = true;
          });
          if (ApiProvider.keyring.keyPairs.isNotEmpty) {
            initContract();
            Provider.of<ApiProvider>(context, listen: false)
                .getCurrentAccount();
            Provider.of<ApiProvider>(context, listen: false).getAddressIcon();
            Provider.of<ApiProvider>(context, listen: false).getChainDecimal();
          }
        }
      });
    });
  }

  Future<void> initContract() async {
    await StorageServices.readBool('KMPI').then((value) {
      if (value) {
        Provider.of<ContractProvider>(context, listen: false).initKmpi();
      }
    });

    await StorageServices.readBool('ATD').then((value) {
      if (value) {
        Provider.of<ContractProvider>(context, listen: false).initAtd();
        Provider.of<ContractProvider>(context, listen: false).fetchAtdBalance();
      }
    });
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
                Home.route: (_) => Home(sdkModel: _createAccModel),
                CheckIn.route: (_) => CheckIn(_createAccModel),
                Account.route: (_) => Account(),
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
                // ignore: avoid_redundant_argument_values
                minWidth: 450,
                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                  const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
