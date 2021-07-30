import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';
import 'src/route/router.dart' as router;

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  bool _apiConnected = false;

  @override
  void initState() {
    readTheme();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      MarketProvider().fetchTokenMarketPrice(context);
      initApi();
      isBtcContain();

      clearOldBtcAddr();

      Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
    });

    super.initState();
  }

  Future<void> initApi() async {
    Provider.of<ApiProvider>(context, listen: false).initApi().then(
      (value) async {
        if (ApiProvider.keyring.keyPairs.isNotEmpty) {
          Provider.of<ApiProvider>(context, listen: false).getAddressIcon();
          Provider.of<ApiProvider>(context, listen: false).getCurrentAccount();
          Provider.of<ApiProvider>(context, listen: false).connectPolNon();
          Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
          Provider.of<ContractProvider>(context, listen: false).getBscBalance();
          Provider.of<ContractProvider>(context, listen: false)
              .getBscV2Balance();
          // ContractProvider().checkAllowance();

          isKgoContain();

          getSavedContractToken();

          getEtherSavedContractToken();

          //swapToken();


         

          Provider.of<ContractProvider>(context, listen: false)
              .getEtherBalance();
        }
        Provider.of<ApiProvider>(context, listen: false).connectNode().then(
          (value) {
            if (value != null) {
              setState(() {
                _apiConnected = true;
              });

              if (ApiProvider.keyring.keyPairs.isNotEmpty) {
                Provider.of<ApiProvider>(context, listen: false)
                    .getChainDecimal();
              }
            }
          },
        );
      },
    );
  }

  void readTheme() async {
    final res = await StorageServices.fetchData('dark');
    //final sysTheme = _checkIfDarkModeEnabled();

    if (res != null) {
      Provider.of<ThemeProvider>(context, listen: false).changeMode();
    }
    //   if (sysTheme) {
    //     Provider.of<ThemeProvider>(context, listen: false).changeMode();
    //   } else {
    //     Provider.of<ThemeProvider>(context, listen: false).changeMode();
    //   }
    // }
  }

  Future<void> swapToken() async {
    final res = await ApiProvider().swapToken(
        '0xed4ef39b5043fdff35a66a1a56e3188d8830e5d42e2bbe7dfa38ac559c62b952',
        '0.01');

    print(res);
  }

  // bool _checkIfDarkModeEnabled() {
  //   var brightness = SchedulerBinding.instance.window.platformBrightness;
  //   bool darkModeOn = brightness == Brightness.dark;
  //   return darkModeOn;
  // }

  Future<void> getSavedContractToken() async {
    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData('contractList');

    if (res != null) {
      for (final i in res) {
        final symbol = await contractProvider.query(i.toString(), 'symbol', []);
        final decimal =
            await contractProvider.query(i.toString(), 'decimals', []);
        final balance = await contractProvider.query(i.toString(), 'balanceOf',
            [EthereumAddress.fromHex(contractProvider.ethAdd)]);

        contractProvider.addContractToken(TokenModel(
          contractAddr: i.toString(),
          decimal: decimal[0].toString(),
          symbol: symbol[0].toString(),
          balance: balance[0].toString(),
          org: 'BEP-20',
        ));
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('${symbol[0]} (BEP-20)');
      }
    }
  }

  Future<void> getEtherSavedContractToken() async {
    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData('ethContractList');

    if (res != null) {
      for (final i in res) {
        final symbol =
            await contractProvider.queryEther(i.toString(), 'symbol', []);
        final decimal =
            await contractProvider.queryEther(i.toString(), 'decimals', []);
        final balance = await contractProvider.queryEther(i.toString(),
            'balanceOf', [EthereumAddress.fromHex(contractProvider.ethAdd)]);

        contractProvider.addContractToken(TokenModel(
          contractAddr: i.toString(),
          decimal: decimal[0].toString(),
          symbol: symbol[0].toString(),
          balance: balance[0].toString(),
          org: 'ERC-20',
        ));
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('${symbol[0]} (ERC-20)');
      }
    }
  }

  Future<void> isBtcContain() async {
    final res = await StorageServices.fetchData('bech32');

    if (res != null) {
      Provider.of<ApiProvider>(context, listen: false)
          .getBtcBalance(res.toString());
      Provider.of<ApiProvider>(context, listen: false)
          .isBtcAvailable('contain');

      Provider.of<ApiProvider>(context, listen: false)
          .setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
    }
  }

  clearOldBtcAddr() async {
    final res = await StorageServices.fetchData('btcaddress');
    if (res != null) {
      await StorageServices.removeKey('btcaddress');
    }
  }

  Future<void> isKgoContain() async {
    Provider.of<ContractProvider>(context, listen: false)
        .getKgoDecimal()
        .then((value) {
      Provider.of<ContractProvider>(context, listen: false).getKgoBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (builder, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return Consumer<ThemeProvider>(
              builder: (context, value, child) {
                return MaterialApp(
                  navigatorKey: AppUtils.globalKey,
                  title: AppText.appName,
                  theme: AppStyle.myTheme(context),
                  onGenerateRoute: router.generateRoute,
                  routes: {
                    Home.route: (_) => Home(apiConnected: _apiConnected),
                  },
                  initialRoute: AppText.splashScreenView,
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
      },
    );
  }
}
