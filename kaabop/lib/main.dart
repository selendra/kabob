import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'src/route/router.dart' as router;

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
  bool _apiConnected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initApi();
    Provider.of<ContractProvider>(context, listen: false).initClient();
    Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
  }

  Future<void> initApi() async {
    Provider.of<ApiProvider>(context, listen: false).initApi().then(
      (value) {
        isDotContain();
        isBnbContain();
        isBscContain();
        Provider.of<ApiProvider>(context, listen: false).connectNode().then(
          (value) {
            if (value != null) {
              setState(() {
                _apiConnected = true;
              });
              if (ApiProvider.keyring.keyPairs.isNotEmpty) {
                initContract();
                Provider.of<ApiProvider>(context, listen: false)
                    .getCurrentAccount();
                Provider.of<ApiProvider>(context, listen: false)
                    .getAddressIcon();
                Provider.of<ApiProvider>(context, listen: false)
                    .getChainDecimal();
              }
            }
          },
        );
      },
    );
  }

  Future<void> isDotContain() async {
    await StorageServices.readBool('DOT').then((value) {
      if (value) {
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('DOT');
        Provider.of<ApiProvider>(context, listen: false).isDotContain();
        Provider.of<ApiProvider>(context, listen: false).connectPolNon();
      }
    });
  }

  Future<void> isBnbContain() async {
    await StorageServices.readBool('BNB').then((value) {
      if (value) {
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('BNB');
        Provider.of<ContractProvider>(context, listen: false).getBscDecimal();
        Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
      }
    });
  }

  Future<void> isBscContain() async {
    await StorageServices.readBool('AYF').then((value) {
      if (value) {
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('AYF');
        Provider.of<ContractProvider>(context, listen: false)
            .getBscDecimal()
            .then((value) {
          Provider.of<ContractProvider>(context, listen: false).getBscBalance();
        });
        Provider.of<ContractProvider>(context, listen: false).getSymbol();
      }
    });
  }

  Future<void> initContract() async {
    await StorageServices.readBool('KMPI').then((value) {
      if (value) {
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('KMPI');
        Provider.of<ContractProvider>(context, listen: false).initKmpi();
      }
    });

    await StorageServices.readBool('ATD').then(
      (value) {
        if (value) {
          Provider.of<WalletProvider>(context, listen: false)
              .addTokenSymbol('ATD');
          Provider.of<ContractProvider>(context, listen: false).initAtd();
          Provider.of<ContractProvider>(context, listen: false)
              .fetchAtdBalance();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (builder, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              initialRoute: AppText.splashScreenView,
              title: AppText.appName,
              theme: AppStyle.myTheme(),
              onGenerateRoute: router.generateRoute,
              routes: {
                Home.route: (_) => Home(_apiConnected),
              },
              builder: (context, widget) => ResponsiveWrapper.builder(
                BouncingScrollWrapper.builder(context, widget),
                maxWidth: 1200,
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
