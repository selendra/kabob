// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dimissible_background.dart';
import 'package:wallet_apps/src/models/tx_history.dart';

class TrxActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TrxActivityState();
  }
}

class TrxActivityState extends State<TrxActivity> {
  // final RefreshController _refreshController = RefreshController();

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  bool isProgress = true;
  bool isLogout = false;

  TxHistory _txHistoryModel = TxHistory();

  @override
  void initState() {
    AppServices.noInternetConnection(_globalKey);
    readTxHistory();
    // fetchHistoryUser();
    super.initState();
  }

  Future<List<TxHistory>> readTxHistory() async {
    await StorageServices.fetchData('txhistory').then((value) {
      // print('My value $value');

      if (value != null) {
        _txHistoryModel.txHistoryList = value;
        for (var i in value) {
          if ((i['symbol'] == 'SEL')) {
            _txHistoryModel.tx.add(TxHistory(
              date: i['date'],
              symbol: i['symbol'],
              destination: i['destination'],
              sender: i['sender'],
              amount: i['amount'],
              org: i['fee'],
            ));
          } else {
            _txHistoryModel.txKpi.add(TxHistory(
              date: i['date'],
              symbol: i['symbol'],
              destination: i['destination'],
              sender: i['sender'],
              amount: i['amount'],
              org: i['fee'],
            ));
          }
        }
      }
      //var responseJson = json.decode(value);
      //print(responseJson);
    });
    setState(() {});
    return _txHistoryModel.tx;
  }

  Future<void> _deleteHistory(int index, String symbol) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    //var newgfgList = new List.from(gfg1)..addAll(gfg2);

    if (symbol == 'SEL') {
      _txHistoryModel.tx.removeAt(index);
    } else {
      _txHistoryModel.txKpi.removeAt(index);
    }

    var newTxList = new List.from(_txHistoryModel.tx)
      ..addAll(_txHistoryModel.txKpi);

    await clearOldHistory().then((value) async {
      await _preferences.setString('txhistory', jsonEncode(newTxList));
      //await StorageServices.addTxHistory(txHistory, '');
    });
  }

  Future<void> clearOldHistory() async {
    await StorageServices.removeKey('txhistory');
  }

  void showDetailDialog(TxHistory txHistory) async {
    await txDetailDialog(context, txHistory);
  }

  /* Log Out Method */
  void logOut() {
    /* Loading */
    dialogLoading(context);
    AppServices.clearStorage();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  /* Scroll Refresh */
  void reFresh() {
    setState(() {
      isProgress = true;
    });
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'SEL'),
    Tab(text: 'KMPI'),
  ];

  void popScreen() => Navigator.pop(context);

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: MyText(
            text: 'Transaction History',
            fontSize: 22.0,
            color: "#FFFFFF",
          ),
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: _txHistoryModel.tx == null
                  ? Container()
                  : ListView.builder(
                      itemCount: _txHistoryModel.tx.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: DismissibleBackground(),
                            onDismissed: (direction) {
                              _deleteHistory(
                                  index, _txHistoryModel.tx[index].symbol);
                            },
                            child: GestureDetector(
                              onTap: () {
                                showDetailDialog(_txHistoryModel.tx[index]);
                              },
                              child: rowDecorationStyle(
                                  child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: EdgeInsets.all(6),
                                    margin: EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color:
                                          hexaCodeToColor(AppColors.secondary),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: MyLogo(
                                      width: 50,
                                      height: 50,
                                      logoPath: "assets/sld_logo.svg",
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text:
                                              _txHistoryModel.tx[index].symbol,
                                          color: "#FFFFFF",
                                          fontSize: 18,
                                        ),
                                        MyText(
                                            text: _txHistoryModel.tx[index].org,
                                            fontSize: 15),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        MyText(
                                          text: _txHistoryModel.tx[index].date,
                                          fontSize: 12,
                                        ),
                                        SizedBox(height: 5.0),
                                        MyText(
                                          text:
                                              '-${_txHistoryModel.tx[index].amount}',
                                          color: AppColors.secondary_text,
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              )),
                            ));
                      },
                    ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: _txHistoryModel.txKpi == null
                  ? Container()
                  : ListView.builder(
                      itemCount: _txHistoryModel.txKpi.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: DismissibleBackground(),
                            onDismissed: (direction) {
                              _deleteHistory(
                                  index, _txHistoryModel.txKpi[index].symbol);
                            },
                            child: GestureDetector(
                              onTap: () {
                                showDetailDialog(_txHistoryModel.txKpi[index]);
                              },
                              child: rowDecorationStyle(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      padding: EdgeInsets.all(6),
                                      margin: EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                          color: hexaCodeToColor(
                                              AppColors.secondary),
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Image.asset(
                                          'assets/koompi_white_logo.png'),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: _txHistoryModel
                                                .txKpi[index].symbol,
                                            color: "#FFFFFF",
                                            fontSize: 18,
                                          ),
                                          MyText(
                                              text: _txHistoryModel
                                                  .txKpi[index].org,
                                              fontSize: 15),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            MyText(
                                              text: _txHistoryModel
                                                  .txKpi[index].date,
                                              fontSize: 12,
                                            ),
                                            SizedBox(height: 5.0),
                                            MyText(
                                              text:
                                                  '-${_txHistoryModel.txKpi[index].amount}',
                                              color: AppColors.secondary_text,
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
