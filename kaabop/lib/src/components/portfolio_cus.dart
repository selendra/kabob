import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/portfolio_c.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

class PortFolioCus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: hexaCodeToColor(AppColors.secondary),
                ),
              ),
              const MyText(
                text: 'Portfolio',
                fontSize: 27,
                color: AppColors.whiteColorHexa,
                left: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16, top: 16),
          padding: const EdgeInsets.only(left: 25, top: 25, bottom: 25),
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
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Consumer<WalletProvider>(
                      builder: (context, value, child) {
                        return PieChart(
                          ringStrokeWidth: 15,
                          dataMap: value.dataMap,
                          chartType: ChartType.ring,
                          colorList: value.pieColorList,
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
                    return Column(
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
        ),
      ],
    );
  }
}
