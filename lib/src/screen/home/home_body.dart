import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';

import 'package:wallet_apps/src/components/portfolio_c.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:pie_chart/pie_chart.dart';

import 'asset_info/asset_info.dart';

class HomeBody extends StatelessWidget {
  final Bloc bloc;
  final GlobalKey<AnimatedCircularChartState> chartKey;
  final List<dynamic> portfolioData;
  final HomeModel homeM;
  final PortfolioM portfolioM;
  final PortfolioRateModel portfolioRateM;
  final Function getWallet;
  final String accName;
  final String accAddress;
  final String accBalance;
  final bool apiStatus;
  final List<Color> pieColorList;
  final Map<String, double> dataMap;
  final String kpiBalance;
  final WalletSDK sdk;
  final Keyring keyring;

  HomeBody({
    this.bloc,
    this.chartKey,
    this.portfolioData,
    this.homeM,
    this.portfolioM,
    this.portfolioRateM,
    this.getWallet,
    this.accName,
    this.accAddress,
    this.accBalance,
    this.apiStatus,
    this.pieColorList,
    this.dataMap,
    this.kpiBalance,
    this.sdk,
    this.keyring,
  });

  Widget build(BuildContext context) {
    return Column(
      children: [
        MyHomeAppBar(
          title: "KAABOP",
          action: () {
            MyBottomSheet().notification(context: context);
          },
        ),

        Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: hexaCodeToColor(AppColors.cardColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(right: 16),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: SvgPicture.asset('assets/male_avatar.svg'),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: accName,
                                color: "#FFFFFF",
                                fontSize: 20,
                              ),
                              Container(
                                width: 100,
                                child: MyText(
                                  text: !apiStatus
                                      ? "Connecting to Remote Node"
                                      : "Indracore",
                                  color: AppColors.secondary_text,
                                  fontSize: 18,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 150,
                              child: MyText(
                                text: accBalance,
                                fontSize: 30,
                                color: AppColors.secondary_text,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: accAddress))
                              .then((value) => {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text('Copied to Clipboard')))
                                  });
                        },
                        child: MyText(
                          top: 16,
                          width: 200,
                          text: accAddress ?? "address",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 5,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: hexaCodeToColor(AppColors.secondary)),
                        ),
                        MyText(
                          text: 'Assets',
                          fontSize: 27,
                          color: "#FFFFFF",
                          left: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        Expanded(child: Container()),
                      ],
                    ))
              ],
            )),

        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      kpiBalance: kpiBalance,
                      sdk: sdk,
                      keyring: keyring,
                    ),
                  )
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Portfolio(
                  //         listData: portfolioM.list,
                  //         listChart: homeM.circularChart),
                  //   ),
                  );
            },
            child: buildRowList(
                portfolioM.list, portfolioRateM.totalRate, kpiBalance)),

        Container(
          margin: EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                width: 5,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: hexaCodeToColor(AppColors.secondary)),
              ),
              MyText(
                text: 'Portfolio',
                fontSize: 27,
                color: "#FFFFFF",
                left: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              RouteAnimation(
                enterPage: Portfolio(
                  listData: portfolioM.list,
                  listChart: homeM.circularChart,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
            padding: EdgeInsets.only(left: 25, top: 25, bottom: 25),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
                color: hexaCodeToColor(AppColors.cardColor),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: PieChart(
                        ringStrokeWidth: 15,
                        dataMap: dataMap,
                        chartType: ChartType.ring,
                        colorList: pieColorList,
                        centerText: "10%",
                        legendOptions: LegendOptions(
                          showLegends: false,
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: false,
                          showChartValueBackground: false,
                          chartValueStyle: TextStyle(
                            color: hexaCodeToColor("#FFFFFF"),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyPieChartRow(
                        color: pieColorList[0],
                        centerText: "KPI",
                        endText: "25%",
                      ),
                      MyPieChartRow(
                        color: pieColorList[1],
                        centerText: "SEL",
                        endText: "50%",
                      ),
                      MyPieChartRow(
                        color: pieColorList[2],
                        centerText: "POK",
                        endText: "25%",
                      ),
                      MyPieChartRow(
                        color: pieColorList[3],
                        centerText: "Emp",
                        endText: "0%",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // GestureDetector(
        //   onTap: (){
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => AddAsset(),
        //       )
        //     );
        //   },
        //   child: rowDecorationStyle(
        //     child: Row(
        //       children: <Widget>[

        //         MyCircularImage(
        //           padding: EdgeInsets.all(6),
        //           margin: EdgeInsets.only(right: 20
        //           ),
        //           decoration: BoxDecoration(
        //             color: hexaCodeToColor(AppColors.secondary),
        //             borderRadius: BorderRadius.circular(40)
        //           ),
        //           imagePath: 'assets/icons/plus_math.svg',
        //           width: 50,
        //           height: 50,
        //           colorImage: Colors.white,
        //         ),

        //         Flexible(
        //           child: Align(
        //             alignment: Alignment.centerLeft,
        //             child: MyText(
        //               text: "Add asset",
        //               color: "#EFF0F2",
        //               fontSize: 16,
        //             )
        //           )
        //         ),
        //       ],
        //     )
        //   ),
        // )

        // Expanded(
        //   child: Stack(
        //     children: [

        //       if (portfolioM.list.isEmpty) loading()

        //       else if (portfolioM.list.isNotEmpty && portfolioM.list[0].containsKey('error')) Container(
        //         height: MediaQuery.of(context).size.height,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [

        //             Expanded(
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   SvgPicture.asset('assets/no_data.svg', width: 200, height: 200),

        //                   MyFlatButton(
        //                     edgeMargin: EdgeInsets.only(top: 50),
        //                     width: 200,
        //                     textButton: "Get wallet",
        //                     action: getWallet,
        //                   )
        //                 ],
        //               ),
        //             )
        //           ],
        //         ),
        //       )

        //       else if (!portfolioM.list[0].containsKey('error')) SingleChildScrollView(
        //         child: Column(
        //           children: <Widget>[
        //             MyCircularChart(
        //               amount: "${homeM.total}",
        //               chartKey: chartKey,
        //               listChart: homeM.circularChart,
        //             ),

        //             Container(
        //               margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        //               padding: EdgeInsets.all(16.0),
        //               width: double.infinity,
        //               height: 222,
        //               decoration: BoxDecoration(
        //                 color: hexaCodeToColor(AppColors.cardColor),
        //                 borderRadius: BorderRadius.circular(8.0),
        //               ),
        //               child: LineChart(
        //                 mainData(),
        //                 swapAnimationDuration: Duration(seconds: 1),
        //               ),
        //             ),

        //             Container( /* Portfolio Title */
        //               alignment: Alignment.centerLeft,
        //               child: MyText(
        //                 bottom: 26,
        //                 left: 16,
        //                 text: "Portfolioes",
        //                 fontSize: 20,
        //                 color: "#FFFFFF",
        //               )
        //             ),

        //             MyRowHeader(),

        //             Container(
        //               constraints: BoxConstraints(
        //                 minHeight: 70,
        //                 maxHeight: 300
        //               ),
        //               child: GestureDetector(
        //                 onTap: (){
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (context) => Portfolio(listData: portfolioM.list, listChart: homeM.circularChart),
        //                     )
        //                   );
        //                 },
        //                 child: buildRowList(portfolioM.list, portfolioRateM.totalRate)
        //               ),
        //             ),

        //             // Add Asset
        //             GestureDetector(
        //               onTap: (){
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => AddAsset(),
        //                   )
        //                 );
        //               },
        //               child: rowDecorationStyle(
        //                 child: Row(
        //                   children: <Widget>[

        //                     MyCircularImage(
        //                       padding: EdgeInsets.all(6),
        //                       margin: EdgeInsets.only(right: 20
        //                       ),
        //                       decoration: BoxDecoration(
        //                         color: hexaCodeToColor(AppColors.secondary),
        //                         borderRadius: BorderRadius.circular(40)
        //                       ),
        //                       imagePath: 'assets/icons/plus_math.svg',
        //                       width: 50,
        //                       height: 50,
        //                       colorImage: Colors.white,
        //                     ),

        //                     Flexible(
        //                       child: Align(
        //                         alignment: Alignment.centerLeft,
        //                         child: MyText(
        //                           text: "Add asset",
        //                           color: "#EFF0F2",
        //                           fontSize: 16,
        //                         )
        //                       )
        //                     ),
        //                   ],
        //                 )
        //               ),
        //             )
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }
}
