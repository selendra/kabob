import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/portfolio_c.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

class PortFolioCus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        //color: hexaCodeToColor(AppColors.cardColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Align(
              child: SizedBox(
                width: 140,
                height: 140,
                child: Consumer<WalletProvider>(
                  builder: (context, value, child) {
                    return value.dataMap.isEmpty
                        ? PieChart(
                            ringStrokeWidth: 15,
                            dataMap: const {'SEL': 100},
                            chartType: ChartType.ring,
                            //colorList: value.pieColorList,
                            centerText: "100%",
                            legendOptions: const LegendOptions(
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
                          )
                        : PieChart(
                            ringStrokeWidth: 15,
                            dataMap: value.dataMap,
                            chartType: ChartType.ring,
                            //colorList: value.pieColorList,
                            centerText: "100%",
                            legendOptions: const LegendOptions(
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
                          );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<WalletProvider>(
              builder: (context, value, child) {
                return value.portfolio.isEmpty
                    ? const Center(
                        child: MyText(
                          text: "Portfolio...",
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          value.portfolio.length,
                          (index) {
                            return MyPieChartRow(
                              color: value.portfolio[index].color,
                              centerText: value.portfolio[index].symbol,
                              endText: value.portfolio[index].percentage,
                            );
                          },
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
