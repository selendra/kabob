import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/portfolio_c.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/menu/account.dart';
import 'asset_info/asset_info.dart';

class HomeBody extends StatelessWidget {
  final HomeModel homeM;
  final PortfolioM portfolioM;
  final PortfolioRateModel portfolioRateM;
  final List<Color> pieColorList;
  final Map<String, double> dataMap;
  final CreateAccModel sdkModel;
  final Function balanceOf;

  HomeBody(
      {this.homeM,
      this.portfolioM,
      this.portfolioRateM,
      this.pieColorList,
      this.dataMap,
      this.sdkModel,
      this.balanceOf});

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Account.route);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 25,
                    bottom: 25,
                  ),
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
                            margin: const EdgeInsets.only(right: 16),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: SvgPicture.asset(
                              'assets/male_avatar.svg',
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: sdkModel.userModel.username,
                                color: "#FFFFFF",
                                fontSize: 20,
                              ),
                              Container(
                                width: 100,
                                child: MyText(
                                  text: !sdkModel.apiConnected
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
                          !sdkModel.apiConnected
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: 150,
                                    child: MyText(
                                      text: sdkModel.mBalance,
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
                          Clipboard.setData(ClipboardData(
                                  text: sdkModel.userModel.address))
                              .then((value) => {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text('Copied to Clipboard')))
                                  });
                        },
                        child: MyText(
                          top: 16,
                          width: 200,
                          text: sdkModel.userModel.address ?? "address",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
                              centerText: 'KMPI',
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
              Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 5,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
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
                  )),
            ],
          ),
        ),
        sdkModel.contractModel.pBalance != ''
            ? GestureDetector(
                onTap: () {
                  //balanceOf();
                  Navigator.push(
                    context,
                    RouteAnimation(
                      enterPage: AssetInfo(
                        sdk: sdkModel.sdk,
                        keyring: sdkModel.keyring,
                        sdkModel: sdkModel,
                      ),
                    ),
                  );
                },
                child: AnimatedOpacity(
                  opacity: sdkModel.contractModel.pBalance != '' ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: buildRowList(
                    portfolioM.list,
                    portfolioRateM.totalRate,
                    sdkModel,
                  ),
                ),
              )
            : Container(
                child: SvgPicture.asset(
                  'assets/no_data.svg',
                  width: 200,
                  height: 200,
                ),
              ),
      ],
    );
  }
}
