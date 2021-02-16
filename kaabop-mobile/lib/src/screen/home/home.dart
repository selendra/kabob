import 'dart:ui';
import 'package:local_auth/auth_strings.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';

class Home extends StatefulWidget {
  final CreateAccModel sdkModel;
  Home(this.sdkModel);

  static const route = '/home';

  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  GlobalKey<AnimatedCircularChartState> chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  MenuModel menuModel = MenuModel();

  HomeModel _homeM = HomeModel();

  PostRequest _postRequest = PostRequest();

  PortfolioM _portfolioM = PortfolioM();

  PortfolioRateModel _portfolioRate = PortfolioRateModel();

  // Local_localAuth _localAuth = Local_localAuth();

  String mBalance = '';
  String status = '';

  List<Color> pieColorList = [
    hexaCodeToColor("#08B952"),
    hexaCodeToColor("#40FF90"),
    hexaCodeToColor("#00FFF0"),
    hexaCodeToColor(AppColors.bgdColor)
  ];
  Map<String, double> dataMap = {
    "FLutter": 5,
    "React": 3,
    "Xamain": 2,
    "Ionic": 2,
  };

  Future<void> getCurrentAccount() async {
    final List<KeyPairData> ls = widget.sdkModel.keyring.keyPairs;
    setState(() {
      widget.sdkModel.userModel.username = ls[0].name;
      widget.sdkModel.userModel.address = ls[0].address;

      _homeM.userData['first_name'] = ls[0].name;
      _homeM.userData['wallet'] = ls[0].address;
    });
  }

  String action = "no_action";

  @override
  initState() {
    /* Initialize State */
    // print("My name ${widget.keyring.current.name}");

    _homeM.portfolioList = null;
    _portfolioM.list = [];
    if (mounted) {
      _homeM.result = {};
      _homeM.globalKey = GlobalKey<ScaffoldState>();
      _homeM.total = 0;
      _homeM.circularChart = [
        CircularSegmentEntry(
            _homeM.emptyChartData, hexaCodeToColor(AppColors.cardColor))
      ];
      _homeM.userData = {};
      setChartData();
      getCurrentAccount();
    }

    menuModel.result.addAll({"pin": '', "confirm": '', "error": ''});

    if (widget.sdkModel.apiConnected) {
      status = null;
    }

    if (!widget.sdkModel.apiConnected) {
      startNode();
    }

    super.initState();
  }

  // Future<void> authenticateBiometric(Local_localAuth _localAuth) async {
  //   try {
  //     // Trigger _localAuth By Finger Print
  //     var res = await _localAuth.authenticateWithBiometrics(
  //       localizedReason: 'Scan your fingerprint to authenticate',
  //       useErrorDialogs: true,
  //       stickyAuth: true,
  //     );

  //     print(res);
  //   } on PlatformException catch (e) {}

  //   //return _menuModel.authenticated;
  // }

  void startNode() async {
    await Future.delayed(Duration(seconds: 1), () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return disableNativePopBackButton(AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Column(
                children: [
                  CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(
                          hexaCodeToColor(AppColors.secondary))),
                  Align(
                    alignment: Alignment.center,
                    child: MyText(
                        text: "\nConnecting to Remote Node...",
                        color: "#000000",
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              content: Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: MyText(
                    text: "Please wait ! this might take a bit longer",
                    color: "#000000"),
              ),
            ));
          });
    });
  }

  void handleConnectNode() async {
    print("My connection status ${widget.sdkModel.apiConnected}");
    if (widget.sdkModel.apiConnected) {
      await Future.delayed(Duration(milliseconds: 300), () {
        status = null;
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setChartData() {
    setState(() {
      _portfolioM.circularChart = _homeM.circularChart;
    });
  }

  void opacityController(bool visible) {
    if (mounted) {
      setState(() {
        if (visible) {
          _homeM.visible = false;
        } else if (visible == false) {
          _homeM.visible = true;
        }
      });
    }
  }

  void resetState(String barcodeValue, String executeName) async {}

  Future<void> _balanceOf() async {
    try {
      final res = await widget.sdkModel.sdk.api.balanceOfByPartition(
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.keyring.keyPairs[0].address,
        widget.sdkModel.contractModel.pHash,
      );

      setState(() {
        widget.sdkModel
          ..contractModel.pBalance = BigInt.parse(res['output']).toString();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void toReceiveToken() async {
    /* Navigate Receive Token */
    await Navigator.of(context).push(RouteAnimation(
        enterPage: ReceiveWallet(
      sdk: widget.sdkModel.sdk,
      keyring: widget.sdkModel.keyring,
    )));
    if (Platform.isAndroid)
      await AndroidPlatform.resetBrightness();
    else
      await IOSPlatform.resetBrightness(IOSPlatform.defaultBrightnessLvl);
  }

  void openMyDrawer() {
    _homeM.globalKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    if (status != null) handleConnectNode();
    return Scaffold(
      key: _homeM.globalKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Menu(_homeM.userData),
      ),
      appBar: homeAppBar(context),
      body: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: HomeBody(
            portfolioM: _portfolioM,
            portfolioRateM: _portfolioRate,
            homeM: _homeM,
            pieColorList: pieColorList,
            dataMap: dataMap,
            sdkModel: widget.sdkModel,
            balanceOf: _balanceOf,
          )),
      floatingActionButton: SizedBox(
          width: 64,
          height: 64,
          child: FloatingActionButton(
            backgroundColor: hexaCodeToColor(AppColors.secondary)
                .withOpacity(!widget.sdkModel.apiConnected ? 0.3 : 1.0),
            child: SvgPicture.asset('assets/sld_qr.svg',
                width: 30,
                height: 30,
                color: !widget.sdkModel.apiConnected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white),
            onPressed: () async {
              await TrxOptionMethod.scanQR(
                  context, _homeM.portfolioList, resetState, widget.sdkModel);
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MyBottomAppBar(
          /* Bottom Navigation Bar */
          apiStatus: widget.sdkModel.apiConnected,
          homeM: _homeM,
          portfolioM: _portfolioM,
          postRequest: _postRequest,
          scanReceipt: null, // Bottom Center Button
          resetDbdState: resetState,
          toReceiveToken: toReceiveToken,
          opacityController: opacityController,
          openDrawer: openMyDrawer,
          sdkModel: widget.sdkModel),
    );
  }
}


