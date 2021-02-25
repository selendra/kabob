import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/portfolio_c.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:wallet_apps/src/screen/home/portfolio/portfolio.dart';

class PortFolioCus extends StatelessWidget {
   final HomeModel homeM;
   final PortfolioM portfolioM;
   final List<Color> pieColorList;
   final Map<String, double> dataMap;
   PortFolioCus(this.homeM,this.portfolioM,this.pieColorList,this.dataMap);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}