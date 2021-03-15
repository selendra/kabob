// // import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:wallet_apps/index.dart';

// class TrxHistory extends StatefulWidget {
//   final String _walletKey;

//   const TrxHistory(this._walletKey);

//   @override
//   State<StatefulWidget> createState() {
//     return TrxHistoryState();
//   }
// }

// class TrxHistoryState extends State<TrxHistory> {
//   final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

//   bool isProgress = true;
//   bool isLogout = false;

//   List<dynamic> _trxHistoryData;
//   final List<dynamic> _trxSend = [];
//   final List<dynamic> _trxReceived = [];

//   InstanceTrxOrder _instanceTrxAllOrder;
//   InstanceTrxOrder _instanceTrxSendOrder;
//   InstanceTrxOrder _instanceTrxReceivedOrder;

//   @override
//   void initState() {
//     _instanceTrxAllOrder = InstanceTrxOrder();
//     _instanceTrxSendOrder = InstanceTrxOrder();
//     _instanceTrxReceivedOrder = InstanceTrxOrder();
//     AppServices.noInternetConnection(_globalKey);

//     super.initState();
//   }

//   // void collectByTrxType(List _trxHistoryData) {
//   //   // ignore: avoid_function_literals_in_foreach_calls
//   //   _trxHistoryData.forEach((element) {
//   //     if (widget._walletKey == element['sender']) {
//   //       // print("$element\n");
//   //       _trxSend.add(element);
//   //     } else if (widget._walletKey != element['sender']) {
//   //       /* Send Trx If Source Account Address Not Equal Wallet Adddress */
//   //       _trxReceived.add(element);
//   //     }
//   //   });
//   //   sortByDate(_trxSend, "Send");
//   //   sortByDate(_trxHistoryData, "All");
//   //   sortByDate(_trxReceived, "Received");
//   // }

//   // void sortByDate(List _trxHistoryData, String tab) {
//   //   if (tab == "Send") {
//   //     _instanceTrxSendOrder = AppUtils.trxMonthOrder(_trxHistoryData);
//   //   } else if (tab == "All") {
//   //     _instanceTrxAllOrder = AppUtils.trxMonthOrder(_trxHistoryData);
//   //   } else if (tab == "Received") {
//   //     _instanceTrxReceivedOrder = AppUtils.trxMonthOrder(_trxHistoryData);
//   //   }
//   // }

//   /* Scroll Refresh */
//   void reFresh() {
//     setState(() {
//       isProgress = true;
//     });

//     // _refreshController.refreshCompleted();
//   }

//   void popScreen() {
//     Navigator.pop(context, {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 1,
//       length: 3,
//       child: Scaffold(
//         key: _globalKey,
//         body: BodyScaffold(
//           height: MediaQuery.of(context).size.height,
//           child: TrxHistoryBody(
//             trxSend: _trxSend,
//             trxHistory: _trxHistoryData,
//             trxReceived: _trxReceived,
//             instanceTrxSendOrder: _instanceTrxSendOrder,
//             instanceTrxAllOrder: _instanceTrxAllOrder,
//             instanceTrxReceivedOrder: _instanceTrxReceivedOrder,
//             walletKey: widget._walletKey,
//             popScreen: popScreen,
//           ),
//         ),
//       ),
//     );
//   }
// }
