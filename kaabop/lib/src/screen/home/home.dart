import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class Home extends StatefulWidget {
  final bool apiConnected;
  // ignore: avoid_positional_boolean_parameters
  const Home(this.apiConnected);

  static const route = '/home';

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  MenuModel menuModel = MenuModel();
  final HomeModel _homeM = HomeModel();
  BuildContext dialogContext;

  String status = '';

  @override
  void initState() {
    if (widget.apiConnected) {
      status = null;
      Timer(const Duration(seconds: 3), () {
        setPortfolio();
        showAirdrop();
      });
    }

    if (!widget.apiConnected) {
      startNode(context);
    }
    Timer(const Duration(seconds: 20), () async {
      if (!widget.apiConnected) {
        await Future.delayed(const Duration(milliseconds: 200), () {
          status = null;
        });
        Navigator.of(context).pop();

        await dialog(
          AppUtils.globalKey.currentContext,
          const Text('Failed to connect to Selendra remote node.'),
          const Text('Connection Failed'),
        );
        Timer(const Duration(seconds: 3), () {
          setPortfolio();
          showAirdrop();
        });
      }
    });

    AppServices.noInternetConnection(_homeM.globalKey);

    super.initState();
  }

  Future<void> handleDialog() async {
    if (!Provider.of<ApiProvider>(context, listen: false).isConnected) {
      startNode(context);
    }
  }

  Future<void> toReceiveToken() async {
    await Navigator.pushNamed(context, AppText.recieveWalletView);
  }

  void openMyDrawer() {
    _homeM.globalKey.currentState.openDrawer();
  }

  void setPortfolio() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.clearPortfolio();

    final contract = Provider.of<ContractProvider>(context, listen: false);

    final api = Provider.of<ApiProvider>(context, listen: false);

    walletProvider.addAvaibleToken({
      'symbol': api.nativeM.symbol,
      'balance': api.nativeM.balance ?? '0',
    });
    if (contract.kmpi.isContain) {
      walletProvider.addAvaibleToken({
        'symbol': contract.kmpi.symbol,
        'balance': contract.kmpi.balance?? '0',
      });
    }

    if (contract.atd.isContain) {
      walletProvider.addAvaibleToken({
        'symbol': contract.atd.symbol,
        'balance': contract.atd.balance?? '0',
      });
    }

    if (contract.bnbNative.isContain) {
      walletProvider.addAvaibleToken({
        'symbol': contract.bnbNative.symbol,
        'balance': contract.bnbNative.balance?? '0',
      });
    }

    if (api.dot.isContain) {
      walletProvider.addAvaibleToken({
        'symbol': api.dot.symbol,
        'balance': api.dot.balance?? '0',
      });
    }

    if (contract.bscNative.isContain) {
      walletProvider.addAvaibleToken({
        'symbol': '${contract.bscNative.symbol} (BEP-20)',
        'balance': contract.bscNative.balance?? '0',
      });
    }

    if (contract.kgoNative.isContain) {
      walletProvider.addAvaibleToken({
        'symbol': '${contract.kgoNative.symbol} (BEP-20)',
        'balance': contract.kgoNative.balance,
      });
    }

    if (contract.token.isNotEmpty) {
      for (int i = 0; i < contract.token.length; i++) {
        walletProvider.addAvaibleToken({
          'symbol':'${contract.token[i].symbol} (BEP-20)',
          'balance': contract.token[i].balance,
        });
      }
    }

    Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  }

  Future<void> onClosed() async {
    await StorageServices.setUserID('claim', 'claim');
    Navigator.pop(context);
  }

  Future<void> onClaim() async {
    Navigator.pop(context);
    await StorageServices.setUserID('claim', 'claim');
    Navigator.push(context, RouteAnimation(enterPage: ClaimAirDrop()));
  }

  Future<void> handle() async {
    if (widget.apiConnected) {
      await Future.delayed(const Duration(milliseconds: 200), () {
        status = null;
      });

      Navigator.of(context).pop();
      Timer(const Duration(seconds: 3), () async {
        setPortfolio();
        showAirdrop();
      });
    }
  }

  Future<void> showAirdrop() async {
    Timer(const Duration(seconds: 1), () async {
      final res = await StorageServices.fetchData('claim');
      if (res == null) {
        await dialogEvent(context, 'assets/bep20.png', onClosed, onClaim);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (status != null) handle();
    return Scaffold(
      key: _homeM.globalKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Menu(_homeM.userData),
      ),
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: HomeBody(
          setPortfolio: setPortfolio,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          backgroundColor: hexaCodeToColor(AppColors.secondary)
              .withOpacity(!widget.apiConnected ? 0.3 : 1.0),
          onPressed: () async {
            await TrxOptionMethod.scanQR(
              context,
              _homeM.portfolioList,
            );
          },
          child: SvgPicture.asset(
            'assets/icons/qr_code.svg',
            width: 30,
            height: 30,
            color: !widget.apiConnected
                ? Colors.white.withOpacity(0.2)
                : Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MyBottomAppBar(
        apiStatus: widget.apiConnected,
        homeM: _homeM,
        toReceiveToken: toReceiveToken,
        openDrawer: openMyDrawer,
      ),
    );
  }
}
