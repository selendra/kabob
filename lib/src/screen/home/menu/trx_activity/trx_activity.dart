// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wallet_apps/index.dart';
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

  List<dynamic> _activity = [];
  TxHistory _txHistoryModel = TxHistory();

  GetRequest _getRequest = GetRequest();

  InstanceTrxOrder _instanceTrxOrder;

  @override
  void initState() {
    _instanceTrxOrder = InstanceTrxOrder();
    AppServices.noInternetConnection(_globalKey);
    readTxHistory();
    // fetchHistoryUser();
    super.initState();
  }

  void fetchHistoryUser() async {
    /* Request Transaction History */
    try {
      await _getRequest.getReceipt().then((_response) {
        if (List<dynamic>.from(_response).length == 0)
          _activity =
              null; /* Assign TransactionActivity Variable With NUll If Reponse Empty Data */
        else
          _activity = _response;
      });
      if (!mounted) return; /* Prevent SetState After Dispose */
      setState(() {});
    } on SocketException catch (e) {
      await dialog(context, Text("${e.message}"), Text("Message"));
      snackBar(_globalKey, e.message.toString());
    } catch (e) {
      await dialog(context, Text(e.message.toString()), Text("Message"));
    }
  }

  void sortByDate(List _trxHistory) {
    _instanceTrxOrder = AppUtils.trxMonthOrder(_trxHistory);
  }

  Future<List<TxHistory>> readTxHistory() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String data = _pref.getString('test');
    print('my Data: $data');
    await StorageServices.fetchData('txhistory').then((value) {
      print('My value $value');
      if (value != null) {
        for (var i in value) {
          print(i);
          _txHistoryModel.tx.add(TxHistory(
            date: i['date'],
            destination: i['destination'],
            sender: i['sender'],
            amount: i['amount'],
            fee: i['fee'],
          ));
        }
      }
      //var responseJson = json.decode(value);
      //print(responseJson);
    });
    setState(() {});
    return _txHistoryModel.tx;
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
    fetchHistoryUser();
    // _refreshController.refreshCompleted();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'SEL'),
    Tab(text: 'KPI'),
  ];

  void popScreen() => Navigator.pop(context);

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
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
                        return GestureDetector(
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
                                    color: hexaCodeToColor(AppColors.secondary),
                                    borderRadius: BorderRadius.circular(40)),
                                child:
                                    Image.asset('assets/koompi_white_logo.png'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: 'SEL',
                                      color: "#FFFFFF",
                                      fontSize: 18,
                                    ),
                                    MyText(text: 'selendra', fontSize: 15),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                        );
                      },
                    ),
            ),
            Container(
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
