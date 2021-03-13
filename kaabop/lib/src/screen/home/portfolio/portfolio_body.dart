import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

import 'package:pie_chart/pie_chart.dart';
import 'package:wallet_apps/src/components/portfolio_c.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

class PortfolioBody extends StatelessWidget {
  final List<dynamic> listData;

  final PortfolioM portfolioM;

  const PortfolioBody({@required this.listData, @required this.portfolioM});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyAppBar(
          title: "Portfolio",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        if (listData == null)
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/no_data.svg', height: 200),
              const MyText(text: "There are no portfolio found")
            ],
          ))
        else
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  top: 16,
                ),
                padding: const EdgeInsets.only(
                  left: 25,
                  top: 25,
                  bottom: 25,
                ),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: hexaCodeToColor(AppColors.cardColor),
                  borderRadius: BorderRadius.circular(8),
                ),
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
              Container(
                height: 150,
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(bottom: 16, text: "Wallet"),
                          MyPercentText(
                            value: "+10.5",
                          ),
                          LinearPercentIndicator(
                            alignment: MainAxisAlignment.center,
                            width: 100.0,
                            percent: 0.5,
                            backgroundColor:
                                hexaCodeToColor(AppColors.cardColor),
                            progressColor:
                                hexaCodeToColor(AppColors.secondarytext),
                            animation: true,
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 2,
                      color: hexaCodeToColor(AppColors.cardColor),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MyText(bottom: 16, text: "Market"),
                          MyPercentText(
                            value: "0.0",
                          ),
                          LinearPercentIndicator(
                            alignment: MainAxisAlignment.center,
                            width: 100.0,
                            percent: 0.5,
                            backgroundColor:
                                hexaCodeToColor(AppColors.cardColor),
                            progressColor: hexaCodeToColor("#00FFF0"),
                            animation: true,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              MyRowHeader(),
              Container(
                constraints: const BoxConstraints(
                  minHeight: 100,
                  maxHeight: 500,
                ),
               // child: MyColumnBuilder(data: listData),
              ),
            ],
          ),
      ],
    );
  }
}
