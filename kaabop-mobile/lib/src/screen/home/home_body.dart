import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dimissible_background.dart';
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
  final Function onDismiss;

  HomeBody(
      {this.homeM,
      this.portfolioM,
      this.portfolioRateM,
      this.pieColorList,
      this.dataMap,
      this.sdkModel,
      this.balanceOf,
      this.onDismiss});

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
                                      text: '', //sdkModel.nativeBalance,
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
                          width: 300,
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
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AddAsset.route);
                        },
                        child: Container(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 30,
                            ),
                            // child: MyText(
                            //   text: 'Add',
                            //   color: "#FFFFFF",
                            // ),
                          ),
                        ),
                      )),
                    ],
                  )),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  //balanceOf();
                  Navigator.push(
                    context,
                    RouteAnimation(
                      enterPage: AssetInfo(
                        sdkModel: sdkModel,
                        assetLogo: sdkModel.nativeToken,
                        balance: sdkModel.nativeBalance,
                        tokenSymbol: sdkModel.nativeSymbol,
                      ),
                    ),
                  );
                },
                child: portFolioItemRow(
                    sdkModel.nativeToken,
                    sdkModel.nativeSymbol,
                    sdkModel.nativeOrg,
                    sdkModel.nativeBalance,
                    Colors.white),
              ),
              sdkModel.contractModel.pHash != ''
                  ? Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        onDismiss();
                      },
                      child: GestureDetector(
                        onTap: () {
                          // balanceOf();
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                sdkModel: sdkModel,
                                assetLogo: sdkModel.contractModel.ptLogo,
                                balance: sdkModel.contractModel.pBalance,
                                tokenSymbol:
                                    sdkModel.contractModel.pTokenSymbol,
                              ),
                            ),
                          );
                        },
                        child: portFolioItemRow(
                            sdkModel.contractModel.ptLogo,
                            sdkModel.contractModel.pTokenSymbol,
                            sdkModel.contractModel.pOrg,
                            sdkModel.contractModel.pBalance,
                            Colors.black),
                      ),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  //hexaCodeToColor(AppColors.secondary)

  Widget portFolioItemRow(String asset, String tokenSymbol, String org,
      String balance, Color color) {
    return rowDecorationStyle(
        child: Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          padding: EdgeInsets.all(6),
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(40)),
          child: Image.asset(asset),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: tokenSymbol,
                  color: "#FFFFFF",
                  fontSize: 18,
                ),
                MyText(text: org, fontSize: 15),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                    width: double.infinity,
                    text: balance, //portfolioData[0]["data"]['balance'],
                    color: "#FFFFFF",
                    fontSize: 18,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ],
    ));
  }

// Portfolow Row Decoration
  Widget rowDecorationStyle(
      {Widget child, double mTop: 0, double mBottom = 16}) {
    return Container(
        margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
        padding: EdgeInsets.fromLTRB(15, 9, 15, 9),
        height: 90,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0,
                offset: Offset(1.0, 1.0))
          ],
          color: hexaCodeToColor(AppColors.cardColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child);
  }
}
