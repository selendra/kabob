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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MarketProvider().fetchTokenMarketPrice(context);
      initApi();
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
          isKgoContain();

          //isBscContain();

          getSavedContractToken();

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
                initContract();

                Provider.of<ApiProvider>(context, listen: false)
                    .getChainDecimal();
              }
            }
          },
        );
      },
    );
  }

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

  // Future<void> isBnbContain() async {
  //   // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BNB');
  //   Provider.of<ContractProvider>(context, listen: false)
  //       .getBscDecimal()
  //       .then((value) {});
  // }

  Future<void> isKgoContain() async {
    // Provider.of<WalletProvider>(context, listen: false)
    //     .addTokenSymbol('KGO (BEP-20)');
    // Provider.of<ContractProvider>(context, listen: false).getKgoSymbol();
    Provider.of<ContractProvider>(context, listen: false)
        .getKgoDecimal()
        .then((value) {
      Provider.of<ContractProvider>(context, listen: false).getKgoBalance();
    });
  }

  // Future<void> isBscContain() async {
  //   // Provider.of<WalletProvider>(context, listen: false)
  //   //     .addTokenSymbol('SEL (BEP-20)');
  //   //Provider.of<ContractProvider>(context, listen: false).getSymbol();
  //   Provider.of<ContractProvider>(context, listen: false).getBscBalance();
  // }

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
              navigatorKey: AppUtils.globalKey,
              title: AppText.appName,
              theme: AppStyle.myTheme(),
              onGenerateRoute: router.generateRoute,
              routes: {
                Home.route: (_) => Home(
                      apiConnected: _apiConnected,
                    ),
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
  }
}
