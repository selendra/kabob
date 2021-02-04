// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:ui';

import 'package:polkawallet_sdk/api/types/balanceData.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/fmt.dart';

class Home extends StatefulWidget {
  // final WalletSDK sdk;
  // final Keyring keyring;
  // final bool apiConnected;
  // final String mBalance;
  // final String msgChannel;
  // final String kpiBalance;

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

  GetRequest _getRequest = GetRequest();

  Backend _backend = Backend();

  PackageInfo _packageInfo;

  PortfolioM _portfolioM = PortfolioM();

  PortfolioRateModel _portfolioRate = PortfolioRateModel();

  // FlareControls _flareControls = FlareControls();

  String accName = '';
  String accAddress;
  String mBalance = '0';
  String _msgChannel;
  String _kpiBalance = '0';

  BalanceData _balance;

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
      accName = ls[0].name;
      accAddress = ls[0].address;

      _homeM.userData['first_name'] = accName;
      _homeM.userData['wallet'] = accAddress;
    });
    print("Hello name ${ls[0].name}");
  }

  Future<void> _subscribeBalance() async {
    print('subscribe');
    final channel = await widget.sdkModel.sdk.api.account
        .subscribeBalance(widget.sdkModel.keyring.current.address, (res) {
      print(res);
      setState(() {
        _balance = res;
        mBalance = Fmt.balance(_balance.freeBalance, 18);
      });
    });

    print('mbalance: $mBalance');

    setState(() {
      _msgChannel = channel;
      print('$channel');
    });
  }

  Future<void> _balanceOf(String from, String who) async {
    await GetRequest().balanceOf(from, who).then((value) {
      print(value);
      if (value != null) {
        print(value);
        setState(() {
          _kpiBalance = value;
        });
      }
    });
  }

  Future<void> connectNode() async {
    print('connectNode');
    final node = NetworkParams();

    node.name = 'Indranet hosted By Selendra';
    node.endpoint = 'wss://rpc-testnet.selendra.org';
    node.ss58 = 0;
    final res = await widget.sdkModel.sdk.api.connectNode(widget.sdkModel.keyring, [node]);

    print('resConnectNode $res');

    if (res != null) {
      print(res);
      // _subscribeBalance();

      // _importFromMnemonic();

    } else {
      print('rese null');
    }
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
      // AppServices.noInternetConnection(_homeM.globalKey);
      _homeM.userData = {};
      setChartData();
      getCurrentAccount();
      //_subscribeBalance();
      // _balanceOf(widget.keyring.keyPairs[0].address,
      //     widget.keyring.keyPairs[0].address);

      /* User Profile */
      // getUserData();
      // fetchPortfolio();
      // triggerDeviceInfo();
      // if (Platform.isAndroid) appPermission();
      // fabsAnimation();
    }

    menuModel.result.addAll({"pin": '', "confirm": '', "error": ''});

    super.initState();
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

  // Initialize Fabs Animation
  void fabsAnimation() {
    if (mounted) {
      _homeM.animationController = AnimationController(
        duration: Duration(milliseconds: 250),
        vsync: this,
      );
      _homeM.degOneTranslationAnimation =
          Tween(begin: 0.0, end: 1.0).animate(_homeM.animationController);
      setState(() {});
      _homeM.animationController.addListener(() {});
    }
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

  Future<void> appPermission() async {
    await AndroidPlatform.checkPermission().then((value) async {
      if (value == false) {
        await Component.messagePermission(
            context: context,
            content: "We suggest you to enable permission on apps",
            method: () async {
              await AndroidPlatform.writePermission();
              Navigator.pop(context);
            });
      }
    });
  }

  /* ---------------------------Rest Api--------------------------- */
  Future<void> getUserData() async {
    /* Fetch User Data From Memory */
    if (mounted) {
      await _getRequest.getUserProfile().then((data) {
        print("User data ${data.body}");
        setState(() {
          if (data == null)
            _homeM.userData = {};
          else
            _homeM.userData = json.decode(data.body);
        });
      });
    }
  }

  void triggerDeviceInfo() async {
    if (mounted) {
      _packageInfo = await PackageInfo.fromPlatform();
      setState(() {});
    }
  }

  /* Fetch Portofolio */
  Future<void> fetchPortfolio() async {
    if (mounted) {
      await Future.delayed(Duration(milliseconds: 10), () {
        setState(() {
          _homeM.portfolioList = [];
          _portfolioM.list = [];
        });
      });

      try {
        /* Get Response Data */

        _backend.response = await _getRequest.getPortfolio();

        _backend.mapData = json.decode(_backend.response.body);

        setState(() {
          _portfolioM.list.add(_backend.mapData);
        });

        if (!_backend.mapData.containsKey('error')) {
          _portfolioRate.currentData = await _portfolioRate.getCurrentData();

          _portfolioRate.totalRate = await _portfolioRate.valueRate(
              _backend.mapData['data'], _portfolioRate.currentData);

          StorageServices.setData(_portfolioM.list,
              'portfolio'); /* Set Portfolio To Local Storage */
          resetDataPieChart(_portfolioM.list);
        }
      } catch (e) {
        print("My error $e");
        await dialog(
            context,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: textAlignCenter(text: "${e.message}")),
              ],
            ),
            warningTitleDialog());
      }
    }
  }

  /* ------------------------Method------------------------ */

  void resetDataPieChart(List<dynamic> portfolio) {
    if (portfolio.length != 0) {
      _homeM.total = 0.0;

      _homeM.circularChart.clear(); // Clear Pie Data

      print(
          json.decode(portfolio[0]['data']['balance']).toDouble().runtimeType);

      for (int i = 0; i < portfolio.length; i++) {
        // Add Totalportfolio
        _homeM.total +=
            (json.decode(portfolio[i]['data']['balance'])).toDouble();

        _homeM.circularChart.add(//Add More Data Follow Portfolio
            CircularSegmentEntry(
                (json.decode(portfolio[i]['data']['balance'])).toDouble(),
                hexaCodeToColor(AppColors.secondary)));
      }
      _homeM.emptyChartData -= _homeM.total;
      _homeM.circularChart.add(// Add Remain Empty Data
          CircularSegmentEntry(
              _homeM.emptyChartData, hexaCodeToColor(AppColors.cardColor)));

      _homeM.emptyChartData = 100.0; // Reset Remain Pie Data
    }
  }

  void menuCallBack(Map<String, dynamic> result) async {
    if (result != null) {
      _backend.mapData = await StorageServices.fetchData("getWallet");

      if (result.isNotEmpty) {
        // Log Out
        if (result.containsKey('log_out')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Welcome()),
          );
        } else if (result['dialog_name'] == "addAssetScreen") {
          await fetchPortfolio();
        } else if (result['dialog_name'] == 'edit_profile') {
          await getUserData();
        }
      }

      // If Get Wallet
      if (_backend.mapData != null) {
        await fetchPortfolio();
        await StorageServices.removeKey("getWallet");
      }
    }
  }

  /* ------------------------Fetch Local Data Method------------------------ */

  // Refech Data User And Portfolio
  _pullUpRefresh() async {
    _portfolioM.list = [];
    fetchPortfolio();
    getUserData();
    // _homeM.refreshController.refreshCompleted();
  }

  Future<dynamic> cropImageCamera(BuildContext context) async {
    File image = await camera();
    dialogLoading(context);
    if (image != null) {
      await Future.delayed(
          Duration(milliseconds: 300),
          () => Navigator.pop(
              context)); /* Wait 300 Millisecond And Close Loading Process */
      File cropImage = await ImageCropper.cropImage(
          // maxHeight: 4096,
          // maxWidth: 1024,
          sourcePath: image.path,
          androidUiSettings: AndroidUiSettings(
            backgroundColor: Colors.black,
            // lockAspectRatio: false
          ));
      return cropImage;
    }
    await Future.delayed(
        Duration(milliseconds: 100),
        () => Navigator.pop(
            context)); /* Wait 300 Millisecond And Close Loading Process */
    return null;
  }

  void scanReceipt() async {
    /* Receipt Scan Pay Process */
    try {
      var _barcode = await BarcodeScanner.scan();
      dialogLoading(context); /* Enable Loading Process */
      await _postRequest.getReward(_barcode.rawContent).then((onValue) async {
        if (onValue.containsKey('message'))
          await dialog(
              context,
              Text(onValue['message']),
              Icon(Icons.done_outline,
                  color: hexaCodeToColor(
                    AppColors.lightBlueSky,
                  )));
        else
          await dialog(
              context, Text(onValue['error']['message']), warningTitleDialog());
        // Disable Loading Process
        Navigator.pop(context);
        if (onValue.containsKey('message')) fetchPortfolio();
      });
    } catch (e) {
      await Future.delayed(Duration(milliseconds: 300), () {});
      AppServices.openSnackBar(_homeM.globalKey, e.message);
    }
  }

  Future<void> createPin() async {
    /* Set PIN Dialog */
    _homeM.result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Pin()));

    if (_homeM.result != null) {
      await fetchPortfolio();
      await getUserData();
      snackBar(_homeM.globalKey,
          "Successfully copy!Please keep your private key to safe place");
    }
  }

  void resetState(String barcodeValue, String executeName) async {
    /* Request Portfolio After Trx QR Success */
    await fetchPortfolio();
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

  void refresh() {
    _balanceOf(
        widget.sdkModel.keyring.keyPairs[0].address, widget.sdkModel.keyring.keyPairs[0].address);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Bloc();

    return Scaffold(
      key: _homeM.globalKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Menu(_homeM.userData, _packageInfo, menuCallBack),
      ),
      body: Stack(
        children: [
          BodyScaffold(
            height: MediaQuery.of(context).size.height,
            child: HomeBody(
              bloc: bloc,
              chartKey: chartKey,
              portfolioData: _homeM.portfolioList,
              portfolioM: _portfolioM,
              portfolioRateM: _portfolioRate,
              getWallet: createPin,
              homeM: _homeM,
              accName: accName,
              accAddress: accAddress,
              accBalance: widget.sdkModel.mBalance,
              apiStatus: widget.sdkModel.apiConnected,
              pieColorList: pieColorList,
              dataMap: dataMap,
              kpiBalance: widget.sdkModel.kpiBalance,
              sdk: widget.sdkModel.sdk,
              keyring: widget.sdkModel.keyring,
              refresh: refresh,
            )
          ),

          !widget.sdkModel.apiConnected ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.8),
          )
          : Container(),

          !widget.sdkModel.apiConnected ? Center(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 40, bottom: 40, left: 30, right: 30),
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                      hexaCodeToColor(AppColors.secondary))),

                  MyText(text: "\nConnecting to Remote Node...\n", textAlign: TextAlign.center, fontWeight: FontWeight.bold, color: "#000000"),

                  MyText(text: "Please wait ! this might take a bit longer", textAlign: TextAlign.center, color: "#000000"),
                ],
              ),
            )
          )
          : Container(),
        ],
      ),
      floatingActionButton: SizedBox(
          width: 64,
          height: 64,
          child: FloatingActionButton(
                backgroundColor: hexaCodeToColor(AppColors.secondary).withOpacity(!widget.sdkModel.apiConnected ? 0.3 : 1.0),
                child: SvgPicture.asset('assets/sld_qr.svg', width: 30, height: 30, color: !widget.sdkModel.apiConnected ? Colors.white.withOpacity(0.2) : Colors.white),
                onPressed: !widget.sdkModel.apiConnected ? null : () async {
                  await TrxOptionMethod.scanQR(context, _homeM.portfolioList, resetState, widget.sdkModel.sdk, widget.sdkModel.keyring);
                },
              )
      ),
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
        sdkModel: widget.sdkModel
      ),
    );
  }
}
