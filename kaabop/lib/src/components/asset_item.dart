import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class AssetItem extends StatefulWidget {

  final String asset;
  final String tokenSymbol;
  final String org;
  final String balance;
  final String marketPrice;
  final String priceChange24h;
  final Color color;
  final double size;
  final List<List<double>> lineChartData;

  AssetItem(this.asset, this.tokenSymbol, this.org, this.balance, this.color,
      {this.marketPrice, this.priceChange24h, this.size, this.lineChartData});

  @override
  _AssetItemState createState() => _AssetItemState();
}

class _AssetItemState extends State<AssetItem> {

  String totalUsd = '';

  final int _divider = 5;

  final int _leftLabelsCount = 6;

  List<FlSpot> _values = const [];

  double _minX = 0;

  double _maxX = 0;

  double _minY = 0;

  double _maxY = 0;

  double _leftTitlesInterval = 0;

  List<Color> _gradientColors = [
    hexaCodeToColor(AppColors.secondary),
    hexaCodeToColor("#00ff6b")
  ];

  void _prepareCryptoData(List<List<double>> data) {
    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _values = data.map((price) {
      if (minY > price.last) minY = price.last;
      if (maxY < price.last) maxY = price.last;

      return FlSpot(price.first, price.last);
    }).toList();

    _minX = _values.first.x;
    _maxX = _values.last.x;
    _minY = (minY / _divider).floorToDouble() * _divider;

    _maxY = (maxY / _divider).ceilToDouble() * _divider;

    _leftTitlesInterval =
        ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

    setState(() {});
  }

  @override
  void initState() {
    if (widget.lineChartData != null) _prepareCryptoData(widget.lineChartData);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.balance != AppText.loadingPattern && widget.marketPrice != null) {
      var res = double.parse(widget.balance) * double.parse(widget.marketPrice);
      totalUsd = res.toStringAsFixed(2);
    }

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return rowDecorationStyle(
      color: isDarkTheme
      ? hexaCodeToColor(AppColors.darkCard)
      : hexaCodeToColor(AppColors.whiteHexaColor),
      child: Row(
        children: <Widget>[
          Container(
            width: 65, //size ?? 65,
            height: 65, //size ?? 65,
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Image.asset(
              widget.asset,
              fit: BoxFit.contain,
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: widget.tokenSymbol,
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme
                    ? AppColors.whiteColorHexa
                    : AppColors.textColor,
                  bottom: 4.0,
                ),
                if (widget.marketPrice == null) 

                  if (widget.org == '') Container()
                  else MyText(
                    text: widget.org,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme
                      ? AppColors.darkSecondaryText
                      : AppColors.darkSecondaryText,
                  )
                else
                  Row(
                    children: [

                      widget.tokenSymbol == "KGO"
                      ? MyText(
                        text: '\$ ${widget.marketPrice.substring(0, 8)}' ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.darkSecondaryText,
                      )
                      : MyText(
                        text: '\$ ${widget.marketPrice}' ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.darkSecondaryText,
                      ),

                      const SizedBox(width: 6.0),
                      MyText(
                        text: widget.priceChange24h.substring(0, 1) == '-'
                          ? '${widget.priceChange24h}%'
                          : '+${widget.priceChange24h}%',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.priceChange24h.substring(0, 1) == '-'
                          ? '#FF0000'
                          : isDarkTheme
                            ? '#00FF00'
                            : '#66CD00',
                      ),
                    ],
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.16,
              child: widget.lineChartData == null || _leftTitlesInterval == 0
                ? LineChart(avgData())
                : LineChart(mainData()),
            ),
          ),
          
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    width: double.infinity,
                    text: widget.balance ?? '0',
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme
                      ? AppColors.whiteColorHexa
                      : AppColors.textColor,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    bottom: 4.0,
                  ),
                  MyText(
                    width: double.infinity,
                    text: widget.balance != AppText.loadingPattern && widget.marketPrice != null
                      ? '\$$totalUsd'
                      : '\$0.00',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    color: isDarkTheme
                      ? AppColors.darkSecondaryText
                      : AppColors.darkSecondaryText,
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  LineChartData avgData() {
    final isDarkTheme = Provider.of<ThemeProvider>(context, listen: false).isDark;
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d), width: 1)
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 0),
            FlSpot(2.6, 0),
            FlSpot(4.9, 0),
            FlSpot(6.8, 0),
            FlSpot(8, 0),
            FlSpot(9.5, 0),
            FlSpot(11, 0),
          ],
          isCurved: true,
          colors: isDarkTheme
            ? [hexaCodeToColor('#00FF00')]
            : [hexaCodeToColor('#66CD00')],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: _gradientColors[0], end: _gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
            ColorTween(begin: _gradientColors[0], end: _gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

  LineChartData mainData() {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: false,
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
            showTitles: false,
            getTextStyles: (value) => const TextStyle(
                  color: Color(0xff67727d),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return '10k';
                case 3:
                  return '30k';
                case 5:
                  return '50k';
              }
              return '';
            },
            reservedSize: 28,
            margin: 12,
            interval: _leftTitlesInterval),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d), width: 1)
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [
        LineChartBarData(
          spots: _values,
          isCurved: true,
          colors: widget.priceChange24h.substring(0, 1) == '-'
            ? [hexaCodeToColor('#FF0000')]
            : isDarkTheme
              ? [hexaCodeToColor('#00FF00')]
              : [hexaCodeToColor('#66CD00')],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            //gradientColorStops: const [0.25, 0.5, 0.75],
            gradientFrom: const Offset(0.2, 1.2),
            gradientTo: const Offset(0.2, 0),
            colors: widget.priceChange24h.substring(0, 1) == '-'
              ? [
                  Colors.white.withOpacity(0.2),
                  hexaCodeToColor('#FF0000').withOpacity(0.2)
                ]
              : [
                  Colors.white.withOpacity(0.2),
                  hexaCodeToColor('#00FF00').withOpacity(0.2),
                ],
            // colors:
            //     _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  Widget rowDecorationStyle({Widget child, double mTop = 0, double mBottom = 16, Color color}) {
    return Container(
      margin: EdgeInsets.only(top: mTop, bottom: 2),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
      height: 100,
      color: color ?? hexaCodeToColor(AppColors.whiteHexaColor),
      child: child
    );
  }
}

