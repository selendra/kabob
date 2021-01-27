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
        
        // TOKEN
        Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
                  margin: EdgeInsets.only(bottom: 16),
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
                              MyText(
                                text: 'SEL',
                                color: AppColors.secondary_text,
                                fontSize: 30,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.bold,
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
                          width: 250,
                          text: !apiStatus
                              ? "Connecting to Remote Node"
                              : accAddress ?? "address",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Portfolio
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
                    margin: EdgeInsets.only(bottom: 16, top: 16),
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

                // Asset
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
                      accBalance: kpiBalance,
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

        
      ],
    );
  }
}
