import 'package:wallet_apps/index.dart';

class PortfolioM {
  Color color;
  String symbol;
  String percentage;

  PortfolioM({this.color,this.symbol,this.percentage});

  List<Map<String, dynamic>> list = [];

  // GlobalKey<AnimatedCircularChartState> chartKey = GlobalKey<AnimatedCircularChartState>();

  // List<CircularSegmentEntry> circularChart;

  double total = 0;

  double remainDataChart = 100;
}
