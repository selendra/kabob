import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import '../../../../index.dart';
import 'asset_detail.dart';

class AssetInfo extends StatefulWidget {
  final String id;
  final String assetLogo;
  final String balance;
  final String tokenSymbol;
  final String org;
  final String marketPrice;
  final String priceChange24h;
  final Market marketData;

  const AssetInfo(
      {this.id,
      this.assetLogo,
      this.balance,
      this.tokenSymbol,
      this.org,
      this.marketPrice,
      this.priceChange24h,
      this.marketData});
  @override
  _AssetInfoState createState() => _AssetInfoState();
}

class _AssetInfoState extends State<AssetInfo> {
  final FlareControls _flareController = FlareControls();
  final ModelScanPay _scanPayM = ModelScanPay();
  final GetWalletMethod _method = GetWalletMethod();
  PageController controller;
  String totalUsd = '';

  int _tabIndex = 0;

  final TxHistory _txHistoryModel = TxHistory();

  final List<Map> _checkInList = [];
  final List<Map> _checkOutList = [];
  List<Map> _checkAll = [];
  GlobalKey<ScaffoldState> _globalKey;

  Future enableAnimation() async {
    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
    });
    _flareController.play('Checkmark');
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(
          context, Home.route, ModalRoute.withName('/'));
    });
  }

  Future<List<TxHistory>> readTxHistory() async {
    await StorageServices.fetchData('txhistory').then((value) {
      if (value != null) {
        for (final i in value) {
          // ignore: unnecessary_parenthesis
          if ((i['symbol'] == 'SEL')) {
            _txHistoryModel.tx.add(TxHistory(
              date: i['date'].toString(),
              symbol: i['symbol'].toString(),
              destination: i['destination'].toString(),
              sender: i['sender'].toString(),
              amount: i['amount'].toString(),
              org: i['fee'].toString(),
            ));
          } else {
            _txHistoryModel.txKpi.add(
              TxHistory(
                date: i['date'].toString(),
                symbol: i['symbol'].toString(),
                destination: i['destination'].toString(),
                sender: i['sender'].toString(),
                amount: i['amount'].toString(),
                org: i['fee'].toString(),
              ),
            );
          }
        }
      }
    });
    setState(() {});
    return _txHistoryModel.tx;
  }

  Future<void> _deleteHistory(int index, String symbol) async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();

    if (symbol == 'SEL') {
      _txHistoryModel.tx.removeAt(index);
    } else {
      _txHistoryModel.txKpi.removeAt(index);
    }

    final newTxList = List.from(_txHistoryModel.tx)
      ..addAll(_txHistoryModel.txKpi);

    await clearOldHistory().then((value) async {
      await _preferences.setString('txhistory', jsonEncode(newTxList));
    });
  }

  Future<void> clearOldHistory() async {
    await StorageServices.removeKey('txhistory');
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 3)).then((value) {
      if (widget.tokenSymbol == "ATD") {
        Provider.of<ContractProvider>(context, listen: false).getAStatus();
        getCheckInList();
        getCheckOutList();
        sortList();
      }
    });
  }

  Future<void> getCheckInList() async {
    final res = await ApiProvider.sdk.api
        .getCheckInList(ApiProvider.keyring.keyPairs[0].address);

    setState(() {
      _checkInList.clear();
    });
    for (final i in res) {
      final String latlong = i['location'].toString();

      await addressName(LatLng(double.parse(latlong.split(',')[0]),
              double.parse(latlong.split(',')[1])))
          .then((value) async {
        if (value != null) {
          await dateConvert(int.parse(i['time'].toString())).then((time) {
            setState(() {
              _checkInList
                  .add({'time': time, 'location': value, 'status': true});
            });
          });
        }
      });
    }
    if (!mounted) return;
    return res;
  }

  Future<void> getCheckOutList() async {
    final res = await ApiProvider.sdk.api
        .getCheckOutList(ApiProvider.keyring.keyPairs[0].address);

    setState(() {
      _checkOutList.clear();
    });

    for (final i in res) {
      final String latlong = i['location'].toString();

      await addressName(LatLng(double.parse(latlong.split(',')[0]),
              double.parse(latlong.split(',')[1])))
          .then((value) async {
        if (value != null) {
          await dateConvert(int.parse(i['time'].toString())).then((time) {
            setState(() {
              _checkOutList
                  .add({'time': time, 'location': value, 'status': false});
            });
          });
        }
      });
    }
    if (!mounted) return;
    return res;
  }

  Future<void> initATD() async {
    if (widget.tokenSymbol == "ATD") {
      Provider.of<ContractProvider>(context, listen: false).getAStatus();
      await getCheckInList();
      await getCheckOutList();
      sortList();
    }
  }

  Future<String> addressName(LatLng place) async {
    final List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(place.latitude, place.longitude);

    return placemark[0].thoroughfare ??
        '' + ", " + placemark[0].subLocality ??
        '' + ", " + placemark[0].administrativeArea ??
        '';
  }

  Future<String> dateConvert(int millisecond) async {
    final df = DateFormat('dd-MM-yyyy hh:mm a');
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecond);

    return df.format(date);
  }

  Future<void> sortList() async {
    _checkAll = List.from(_checkInList)..addAll(_checkOutList);

    _checkAll.sort(
      (a, b) => a['time'].toString().compareTo(
            b['time'].toString(),
          ),
    );
    setState(() {});
    if (!mounted) return;
  }

  String onSubmit(String value) {
    return value;
  }

  Future<void> showDetailDialog(TxHistory txHistory) async {
    await txDetailDialog(context, txHistory);
  }

  Future<void> qrRes() async {
    final _response =
        await Navigator.push(context, transitionRoute(QrScanner()));

    if (_response != null && _response != "null") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckIn(
            qrRes: _response.toString(),
          ),
        ),
      );
    }
  }

  void onPageChange(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  void onTabChange(int tabIndex) {
    controller.animateToPage(
      tabIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    _globalKey = GlobalKey<ScaffoldState>();
    controller = PageController();

    super.initState();
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.balance != AppText.loadingPattern &&
        widget.marketPrice != null) {
      var res = double.parse(widget.balance) * double.parse(widget.marketPrice);
      totalUsd = res.toStringAsFixed(2);
    }

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: _globalKey,
      floatingActionButton: widget.tokenSymbol != "ATD"
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                qrRes();
              },
              backgroundColor: hexaCodeToColor(AppColors.secondary),
              child: const Icon(
                Icons.location_on,
                size: 30,
              ),
            ),
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBox) {
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: 65,
                forceElevated: innerBox,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: isDarkTheme
                    ? hexaCodeToColor(AppColors.darkBgd)
                    : hexaCodeToColor(AppColors.cardColor),
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(right: 16),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Image.asset(
                          widget.assetLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      MyText(
                        fontSize: 16.0,
                        color: isDarkTheme
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                        text: widget.id == null
                            ? widget.tokenSymbol
                            : widget.id.toUpperCase(),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MyText(
                    color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                    top: 12.0,
                    right: 16.0,
                    fontSize: 16.0,
                    text: widget.org == 'BEP-20' ? 'BEP-20' : '',
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(
                      color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkBgd)
                          : hexaCodeToColor(AppColors.cardColor),
                      child: Column(
                        children: [
                          if (widget.tokenSymbol == "ATD")
                            Align(
                              alignment: Alignment.topRight,
                              child: Consumer<ContractProvider>(
                                builder: (context, value, child) {
                                  return MyText(
                                    textAlign: TextAlign.right,
                                    text: value.atd.status
                                        ? 'Status: Check-In'
                                        : 'Status: Check-out',
                                    fontSize: 16.0,
                                    right: 16.0,
                                    color: isDarkTheme
                                        ? AppColors.whiteColorHexa
                                        : AppColors.textColor,
                                  );
                                },
                              ),
                            )
                          else
                            Container(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          MyText(
                            text:
                                '${widget.balance}${' ${widget.tokenSymbol}'}',
                            //AppColors.secondarytext,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: isDarkTheme
                                ? AppColors.whiteColorHexa
                                : AppColors.textColor,
                          ),
                          MyText(
                            top: 8.0,
                            text: widget.balance != AppText.loadingPattern &&
                                    widget.marketPrice != null
                                ? '≈ \$$totalUsd'
                                : '≈ \$0.00',

                            fontSize: 28,
                            color: isDarkTheme
                                ? AppColors.whiteColorHexa
                                : AppColors.textColor,
                            //fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8.0),
                          if (widget.marketPrice == null)
                            Container()
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  text: '\$ ${widget.marketPrice}' ?? '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                      ? AppColors.whiteColorHexa
                                      : AppColors.textColor,
                                ),
                                const SizedBox(width: 6.0),
                                MyText(
                                  text: widget.priceChange24h.substring(0, 1) ==
                                          '-'
                                      ? '${widget.priceChange24h}%'
                                      : '+${widget.priceChange24h}%',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      widget.priceChange24h.substring(0, 1) ==
                                              '-'
                                          ? '#FF0000'
                                          : isDarkTheme
                                              ? '#00FF00'
                                              : '#66CD00',
                                ),
                              ],
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            padding: widget.tokenSymbol == 'ATD'
                                ? const EdgeInsets.symmetric()
                                : const EdgeInsets.symmetric(vertical: 16.0),
                            child: widget.tokenSymbol == 'ATD'
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 150,
                                        // ignore: deprecated_member_use
                                        child: FlatButton(
                                          onPressed: () {
                                            MyBottomSheet().trxOptions(
                                              context: context,
                                            );
                                          },
                                          color: hexaCodeToColor(
                                              AppColors.secondary),
                                          disabledColor: Colors.grey[700],
                                          focusColor: hexaCodeToColor(
                                              AppColors.secondary),
                                          child: const MyText(
                                              text: 'Transfer',
                                              color: AppColors.whiteColorHexa),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      SizedBox(
                                        height: 50,
                                        width: 150,
                                        // ignore: deprecated_member_use
                                        child: FlatButton(
                                          onPressed: () {
                                            AssetInfoC().showRecieved(
                                              context,
                                              _method,
                                              symbol: widget.tokenSymbol,
                                              org: widget.org,
                                            );
                                          },
                                          color: hexaCodeToColor(
                                            AppColors.secondary,
                                          ),
                                          disabledColor: Colors.grey[700],
                                          focusColor: hexaCodeToColor(
                                            AppColors.secondary,
                                          ),
                                          child: const MyText(
                                            text: 'Recieved',
                                            color: AppColors.whiteColorHexa,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 32.0,
                      color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkBgd)
                          : hexaCodeToColor(AppColors.cardColor),
                    ),
                    Container(
                      //padding: const EdgeInsets.only(top: 32.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                onTabChange(0);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? hexaCodeToColor(AppColors.darkCard)
                                      : hexaCodeToColor(AppColors.cardColor),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _tabIndex == 0
                                          ? hexaCodeToColor(AppColors.secondary)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                child: MyText(
                                  text: "Details",
                                  color: _tabIndex == 0
                                      ? AppColors.secondary
                                      : isDarkTheme
                                          ? AppColors.darkSecondaryText
                                          : AppColors.textColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                onTabChange(1);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? hexaCodeToColor(AppColors.darkCard)
                                      : hexaCodeToColor(AppColors.cardColor),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _tabIndex == 1
                                          ? hexaCodeToColor(AppColors.secondary)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                child: MyText(
                                  text: "Activity",
                                  color: _tabIndex == 1
                                      ? AppColors.secondary
                                      : isDarkTheme
                                          ? AppColors.darkSecondaryText
                                          : AppColors.textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), //
                    ),
                  ],
                ),
              ),
            ];
          },
          body: PageView(
            controller: controller,
            onPageChanged: (index) {
              onPageChange(index);
            },
            children: <Widget>[
              if (widget.marketData != null)
                Container(
                  color: isDarkTheme
                      ? hexaCodeToColor(AppColors.darkCard)
                      : hexaCodeToColor(AppColors.cardColor),
                  child: AssetDetail(widget.marketData),
                )
              else
                Container(
                  color: isDarkTheme
                      ? hexaCodeToColor(AppColors.darkCard)
                      : hexaCodeToColor(AppColors.cardColor),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/no_data.svg',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              Container(
                color: isDarkTheme
                    ? hexaCodeToColor(AppColors.darkCard)
                    : hexaCodeToColor(AppColors.cardColor),
                child: Center(
                    child: SvgPicture.asset(
                  'assets/icons/no_data.svg',
                  width: 150,
                  height: 150,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
